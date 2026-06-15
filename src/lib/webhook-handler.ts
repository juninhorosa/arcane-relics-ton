import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!
const MINI_APP_URL = process.env.MINI_APP_URL!
const TELEGRAM_SECRET_TOKEN = process.env.TELEGRAM_SECRET_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export async function handleTelegramWebhook(request: Request): Promise<Response | null> {
  const url = new URL(request.url)
  if (request.method !== 'POST' || url.pathname !== '/api/public/telegram/webhook') {
    return null
  }

  const secretToken = request.headers.get('X-Telegram-Bot-Api-Secret-Token')
  if (secretToken !== TELEGRAM_SECRET_TOKEN) {
    return new Response('Unauthorized', { status: 403 })
  }

  let update: any
  try {
    update = await request.json()
  } catch {
    return new Response('Bad Request', { status: 400 })
  }

  try {
    const tgId = update.message?.from?.id || update.callback_query?.from?.id
    if (tgId) {
      const { data: banCheck } = await supabase
        .from('profiles')
        .select('is_banned')
        .eq('telegram_id', tgId)
        .maybeSingle()

      if (banCheck?.is_banned) {
        const chatId = update.message?.chat?.id || update.callback_query?.message?.chat?.id
        if (chatId) await sendTelegramMessage(chatId, "🚫 *ACESSO NEGADO*\n\nSua conta foi banida por violar os termos do jogo.")
        return new Response('Banned', { status: 200 })
      }
    }

    if (update.message?.text) {
      const chatId = update.message.chat.id
      const text = update.message.text
      const telegramId = update.message.from.id
      const username = update.message.from.username
      const displayName = update.message.from.first_name

      if (text === '/start') {
        return handleStart(chatId, telegramId, username, displayName)
      }
      if (text === '/perfil') {
        return handleProfile(chatId, telegramId)
      }
      if (text === '/farm') {
        return handleFarm(chatId, telegramId)
      }
      if (text.startsWith('/atacar')) {
        const target = text.split(' ')[1]
        if (!target) return sendTelegramMessage(chatId, "❌ Use: `/atacar @username`", { parse_mode: 'Markdown' })
        return handleAttack(chatId, telegramId, target)
      }
    }

    if (update.callback_query) {
      const data = update.callback_query.data
      const telegramId = update.callback_query.from.id
      const chatId = update.callback_query.message.chat.id

      if (data === 'menu_profile') return handleProfile(chatId, telegramId)
      if (data === 'menu_ranking') return handleRanking(chatId)
      if (data === 'menu_battle') return sendTelegramMessage(chatId, "⚔️ Digite `/atacar @usuario` para desafiar alguém!")
      if (data === 'menu_shop' || data === 'menu_inventory') return sendTelegramMessage(chatId, "🏰 Acesse o Mini App para Loja e Inventário!")

      if (data.startsWith('join_nation:')) {
        const nationCode = data.split(':')[1]
        return handleNationJoin(chatId, telegramId, nationCode)
      }
      if (data === 'defend_invasion') {
        return sendTelegramMessage(chatId, "🛡️ *ÀS ARMAS!* Abra o Mini App para se juntar à defesa!", { inline_keyboard: [[{ text: "🏰 DEFENDER AGORA", web_app: { url: `${MINI_APP_URL}/invasion` } }]] })
      }
    }

    return new Response('OK', { status: 200 })
  } catch (err) {
    console.error('Webhook error:', err)
    return new Response('Internal Server Error', { status: 500 })
  }
}

async function handleStart(chatId: number, telegramId: number, username: string, displayName: string) {
  let { data: profile } = await supabase
    .from('profiles')
    .select('id, players(id, level, nation_id)')
    .eq('telegram_id', telegramId)
    .maybeSingle()

  const player = (profile as any)?.players?.[0]

  if (!profile || !player || player.level < 5 || !player.nation_id) {
    await sendTelegramMessage(chatId, "⚔️ Bem-vindo ao *Arcane Relics*!\n\nAbra o reino para começar sua jornada!", {
      inline_keyboard: [[{ text: "🏰 ENTRAR NO REINO", web_app: { url: MINI_APP_URL! } }]]
    })
    return new Response('OK', { status: 200 })
  }

  return handleMainMenu(chatId)
}

async function handleMainMenu(chatId: number) {
  await sendTelegramMessage(chatId, "🏰 *Menu Principal*", {
    inline_keyboard: [
      [{ text: "👤 Perfil", callback_data: "menu_profile" }, { text: "🏆 Ranking", callback_data: "menu_ranking" }],
      [{ text: "🛒 Loja", callback_data: "menu_shop" }, { text: "🎒 Inventário", callback_data: "menu_inventory" }],
      [{ text: "⚔️ Combate", callback_data: "menu_battle" }],
      [{ text: "⚔️ ENTRAR NO REINO (JOGAR)", web_app: { url: MINI_APP_URL! } }]
    ]
  })
  return new Response('OK', { status: 200 })
}

async function handleNationJoin(chatId: number, telegramId: number, nationCode: string) {
  const { data: nation } = await supabase.from('nations').select('id, name').eq('code', nationCode).maybeSingle()
  const { data: profile } = await supabase.from('profiles').select('id').eq('telegram_id', telegramId).maybeSingle()

  if (nation && profile) {
    await supabase.from('players').insert({ user_id: profile.id, nation_id: nation.id })
    await sendTelegramMessage(chatId, `✅ Você agora faz parte de *${nation.name}*!`)
    await handleMainMenu(chatId)
  }
  return new Response('OK', { status: 200 })
}

async function handleProfile(chatId: number, telegramId: number) {
  const { data: profile } = await supabase
    .from('profiles')
    .select('*, players(*, nations(*))')
    .eq('telegram_id', telegramId)
    .maybeSingle()

  const player = (profile as any)?.players?.[0]
  if (!player) return handleStart(chatId, telegramId, '', '')

  const power = await calculatePower(player.id, player.level)
  const text = `👤 *${profile.display_name}*\n🚩 Nação: ${player.nations?.name}\n🎖 Nível: ${player.level}\n✨ XP: ${player.xp}\n💰 Gold: ${player.gold}\n⚔️ Poder: ${Math.floor(power)}\n📊 Vitórias: ${player.wins}`

  await sendTelegramMessage(chatId, text)
  return new Response('OK', { status: 200 })
}

async function handleFarm(chatId: number, telegramId: number) {
  const { data: profile } = await supabase
    .from('profiles')
    .select('players(*)')
    .eq('telegram_id', telegramId)
    .maybeSingle()

  const player = (profile as any)?.players?.[0]
  if (!player) return

  const now = new Date()
  const lastFarm = player.last_farm_at ? new Date(player.last_farm_at) : new Date(0)

  if (now.getTime() - lastFarm.getTime() < 3600000) {
    const remaining = Math.ceil((3600000 - (now.getTime() - lastFarm.getTime())) / 60000)
    return sendTelegramMessage(chatId, `⏳ Você está exausto! Volte em ${remaining} minutos.`)
  }

  const { data: counts } = await supabase.rpc('get_nation_player_counts')
  const totalPlayers = counts?.reduce((acc: number, curr: any) => acc + Number(curr.count), 0) || 0
  const playerNation = counts?.find((c: any) => c.code === player.nations?.code)
  const isUnderpopulated = totalPlayers > 10 && (Number(playerNation?.count || 0) / totalPlayers) < 0.15

  const isBoosted = player.boost_xp_until && new Date(player.boost_xp_until) > now
  const xpMultiplier = isBoosted ? 2 : 1
  const goldMultiplier = isUnderpopulated ? 1.25 : 1

  let xpGain, goldGain, farmMsg
  let currentMap = null

  if (player.current_map_id) {
    const { data: map } = await supabase.from('maps').select('*').eq('id', player.current_map_id).maybeSingle()
    currentMap = map
  }

  if (player.level < 5) {
    xpGain = Math.floor(Math.random() * 30) + 20
    goldGain = Math.floor(Math.random() * 10) + 5
    farmMsg = `⚔️ *Batalha Inicia!* Você derrotou um Lobo nos Campos de Treinamento.\n✨ +${xpGain} XP\n💰 +${goldGain} Gold\n\n*Faltam ${5 - player.level} níveis para escolher sua nação!*`
  } else {
    if (currentMap) {
      xpGain = Math.floor(currentMap.base_xp_per_hour / 60 * (Math.random() * 0.5 + 0.75)) * xpMultiplier
      goldGain = Math.floor(currentMap.base_gold_per_hour / 60 * (Math.random() * 0.5 + 0.75)) * goldMultiplier
      farmMsg = `🚜 *Farm em ${currentMap.name} concluído!*${isBoosted ? ' (XP 2x 🔥)' : ''}\n✨ +${xpGain} XP\n💰 +${goldGain} Gold`
    } else {
      xpGain = (Math.floor(Math.random() * 100) + 50) * player.level * xpMultiplier
      goldGain = Math.floor((Math.floor(Math.random() * 40) + 10) * player.level * goldMultiplier)
      farmMsg = `🚜 *Farm concluído!*${isBoosted ? ' (XP 2x 🔥)' : ''}\n✨ +${xpGain} XP\n💰 +${goldGain} Gold`
    }
  }

  await supabase.from('players').update({
    xp: player.xp + xpGain,
    gold: player.gold + goldGain,
    last_farm_at: now.toISOString()
  }).eq('id', player.id)

  await sendTelegramMessage(chatId, farmMsg)
  return new Response('OK', { status: 200 })
}

async function handleAttack(chatId: number, attackerTelegramId: number, targetUsername: string) {
  const username = targetUsername.replace('@', '')

  const { data: attackerProfile } = await supabase.from('profiles').select('*, players(*, nations(*))').eq('telegram_id', attackerTelegramId).maybeSingle()
  const { data: targetProfile } = await supabase.from('profiles').select('*, players(*, nations(*))').eq('username', username).maybeSingle()

  const attacker = (attackerProfile as any)?.players?.[0]
  const target = (targetProfile as any)?.players?.[0]

  if (!target) return sendTelegramMessage(chatId, "❌ Oponente não encontrado no reino.")
  if (attacker.id === target.id) return sendTelegramMessage(chatId, "❌ Você não pode atacar a si mesmo.")

  const targetNation = target.nations
  if (targetNation?.divine_protection_until && new Date(targetNation.divine_protection_until) > new Date()) {
    const diff = new Date(targetNation.divine_protection_until).getTime() - Date.now()
    const minutes = Math.ceil(diff / 60000)
    return sendTelegramMessage(chatId, `🛡️ A nação de *${targetNation.name}* está sob *Proteção Divina* por mais ${minutes}m e não pode ser atacada.`)
  }

  const now = new Date()
  const lastBattle = attacker.updated_at ? new Date(attacker.updated_at) : new Date(0)

  const aPower = await calculatePower(attacker.id, attacker.level)
  const tPower = await calculatePower(target.id, target.level)

  const isSameNation = attacker.nation_id === target.nation_id

  const aFinal = aPower * (0.8 + Math.random() * 0.4)
  const tFinal = tPower * (0.8 + Math.random() * 0.4)
  const win = aFinal > tFinal

  const goldStolen = (win && !isSameNation) ? Math.floor(target.gold * 0.1) : 0

  if (win) {
    await supabase.from('players').update({ gold: attacker.gold + goldStolen, wins: attacker.wins + 1 }).eq('id', attacker.id)
    await supabase.from('players').update({ gold: target.gold - goldStolen, losses: target.losses + 1 }).eq('id', target.id)

    if (Math.random() < 0.05) {
      const { data: relic } = await supabase.from('inventory').select('id, template_id').eq('player_id', target.id).eq('item_templates.is_relic', true).limit(1).maybeSingle()
      if (relic) {
        await supabase.from('inventory').update({ player_id: attacker.id }).eq('id', relic.id)
        await sendTelegramMessage(chatId, "💎 *LENDÁRIO!* Você roubou uma Relíquia do oponente!")
      }
    }
  } else {
    await supabase.from('players').update({ losses: attacker.losses + 1 }).eq('id', attacker.id)
    await supabase.from('players').update({ wins: target.wins + 1 }).eq('id', target.id)
  }

  await supabase.from('battles').insert({
    attacker_id: attacker.id,
    defender_id: target.id,
    winner_id: win ? attacker.id : target.id,
    attacker_power: Math.floor(aPower),
    defender_power: Math.floor(tPower),
    gold_stolen: goldStolen
  })

  if (attacker.nation_id && target.nation_id && !isSameNation) {
    const winnerNationId = win ? attacker.nation_id : target.nation_id
    const loserNationId = win ? target.nation_id : attacker.nation_id

    const { data: consecutiveWins } = await supabase.rpc('update_nation_rivalry', {
      p_winner_id: winnerNationId,
      p_loser_id: loserNationId
    })

    if (consecutiveWins && consecutiveWins >= 50) {
      const protectionUntil = new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString()
      const loserNationName = win ? target.nations.name : attacker.nations.name
      await supabase.from('nations').update({ divine_protection_until: protectionUntil }).eq('id', loserNationId)
      await notifyNationProtection(loserNationId, loserNationName)
      await sendTelegramMessage(chatId, `✨ *FATO ÉPICO!* A nação de *${loserNationName}* foi massacrada repetidamente e agora está sob *Proteção Divina* de 2 horas!`)
    }
  }

  let resultText = win ? `🏆 Vitória!` : `💀 Derrota!`
  if (win && isSameNation) resultText += `\n⚠️ *Aviso:* Atacar aliados não gera ouro!`
  else if (win) resultText += `\nVocê saqueou 💰 ${goldStolen} Gold de um inimigo de ${targetProfile.players[0].nations.name}!`

  if (targetProfile.telegram_id) {
    const notificationText = win
      ? `⚔️ *ALERTA DE INVASÃO!*\nO herói @${attackerProfile.username} de ${attackerProfile.players[0].nations.name} atacou você e roubou 💰 ${goldStolen} gold!`
      : `⚔️ *ATAQUE DEFENDIDO!*\n@${attackerProfile.username} tentou atacar você, mas suas defesas foram superiores!`

    await sendTelegramMessage(Number(targetProfile.telegram_id), notificationText)
  }

  await sendTelegramMessage(chatId, resultText)
  return new Response('OK', { status: 200 })
}

async function notifyNationProtection(nationId: string, nationName: string) {
  const { data: members } = await supabase
    .from('players')
    .select('profiles(telegram_id)')
    .eq('nation_id', nationId)

  if (!members) return

  const message = `🛡️ *ALERTA SAGRADO DE ${nationName.toUpperCase()}*\n\nNossos deuses viram nosso sofrimento. A nação entrou em *Proteção Divina* por 2 horas. Invasores não podem mais nos atacar neste período. Aproveitem para farmar e se fortalecer!`

  const replyMarkup = {
    inline_keyboard: [[{ text: "🏰 ENTRAR NO REINO", web_app: { url: MINI_APP_URL } }]]
  }

  for (const member of members) {
    const tgId = (member.profiles as any)?.telegram_id
    if (tgId) {
      await sendTelegramMessage(Number(tgId), message, replyMarkup)
    }
  }
}

async function calculatePower(playerId: string, level: number) {
  const { data: eq } = await supabase
    .from('equipment')
    .select('inventory(item_templates(*))')
    .eq('player_id', playerId)

  let atk = 0, def = 0, hp = 0

  eq?.forEach((item: any) => {
    const template = item.inventory.item_templates
    atk += template.attack || 0
    def += template.defense || 0
    hp += template.hp || 0
  })

  return (level * 10) + atk + def + (hp / 10)
}

async function handleRanking(chatId: number) {
  const { data: ranking } = await supabase
    .from('players')
    .select('gold, profiles(display_name)')
    .order('gold', { ascending: false })
    .limit(10)

  if (!ranking) return

  let text = "🏆 *TOP 10 HERÓIS MAIS RICOS*\n\n"
  ranking.forEach((entry: any, index: number) => {
    const medal = index === 0 ? "🥇" : index === 1 ? "🥈" : index === 2 ? "🥉" : "👤"
    text += `${medal} ${entry.profiles.display_name}: 💰 ${entry.gold.toLocaleString()}\n`
  })

  await sendTelegramMessage(chatId, text)
  return new Response('OK', { status: 200 })
}

async function sendTelegramMessage(chatId: number, text: string, replyMarkup?: any) {
  await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: chatId,
      text: text,
      parse_mode: 'Markdown',
      reply_markup: replyMarkup
    })
  })
}
