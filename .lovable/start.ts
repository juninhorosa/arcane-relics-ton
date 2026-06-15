import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!)
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

export const APIRoute = createAPIFileRoute('/api/invasion/start')({
  POST: async ({ request }) => {
    const { attackerId, targetNationId } = await request.json()
    
    // 1. Criar registro de invasão
    const { data: invasion } = await supabase.from('active_invasions' as any).insert({
      attacker_player_id: attackerId,
      target_nation_id: targetNationId,
      status: 'starting', // Fase de alerta (2 min)
      relic_health: 50000
    }).select('*, nations:target_nation_id(name)').single()

    // 2. Alertas Globais (Fase 11.3)
    const { data: attacker } = await supabase.from('players').select('nations(name, code)').eq('id', attackerId).single()
    
    // Alerta para a Nação Atacada
    await broadcastToNation(targetNationId, 
      `🚨 *ALERTA DE INVASÃO!* 🚨\nO herói de ${attacker.nations.name} está invadindo nossas terras!\n` +
      `O ataque à nossa Relíquia começará em *2 MINUTOS*. Reúnam-se para DEFENDER!`,
      true // Mostrar botão "Defender"
    )

    // Alerta para a Nação Atacante
    await broadcastToNation(attacker.nation_id, 
      `⚔️ *ORDEM DE ATAQUE!* ⚔️\nEstamos invadindo a nação de ${invasion.nations.name}.\n` +
      `Precisamos de todos os civis para apoiar a destruição da Relíquia inimiga em 2 minutos!`
    )

    return new Response(JSON.stringify({ success: true }))
  }
})

async function broadcastToNation(nationId: string, text: string, showDefendBtn = false) {
  const { data: players } = await supabase.from('players').select('profiles(telegram_id)').eq('nation_id', nationId)
  
  const replyMarkup = showDefendBtn ? {
    inline_keyboard: [[{ text: "🛡️ DEFENDER AGORA", web_app: { url: `${process.env.MINI_APP_URL}/invasion` } }]]
  } : {
    inline_keyboard: [[{ text: "⚔️ APOIAR ATAQUE", web_app: { url: `${process.env.MINI_APP_URL}/invasion` } }]]
  }

  for (const p of players || []) {
    const tgId = (p.profiles as any)?.telegram_id
    if (tgId) {
      await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          chat_id: tgId,
          text: text,
          parse_mode: 'Markdown',
          reply_markup: replyMarkup
        })
      })
    }
  }
}