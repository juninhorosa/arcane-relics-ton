import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/world-boss/attack')({
  POST: async ({ request }) => {
    try {
      const { initData, bossId } = await request.json()

      // 1. Validar jogador
      if (!validateTelegramInitData(initData, TELEGRAM_BOT_TOKEN)) {
        return new Response(JSON.stringify({ error: 'Sessão inválida' }), { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const tgUser = JSON.parse(urlParams.get('user')!)

      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(*)')
        .eq('telegram_id', tgUser.id)
        .single()

      const player = (profile as any)?.players?.[0]
      if (!player) return new Response(JSON.stringify({ error: 'Herói não encontrado' }), { status: 404 })

      // 2. Verificar se o Boss está ativo
      const { data: boss, error: bError } = await supabase
        .from('world_bosses' as any) // Tabela a ser criada na Fase 9
        .select('*')
        .eq('id', bossId)
        .eq('status', 'active')
        .single()

      if (bError || !boss || boss.current_hp <= 0) {
        return new Response(JSON.stringify({ error: 'Este Boss já foi derrotado ou não está ativo' }), { status: 400 })
      }

      // 3. Calcular Dano (Poder do Jogador / 100 como base de dano ao Boss)
      // Aqui idealmente usaríamos a função calculatePower compartilhada
      const damage = Math.floor((player.level * 10) * (0.9 + Math.random() * 0.2))

      // 4. Atualizar HP do Boss e registrar log de dano (Operação atômica recomendada via RPC)
      const { error: uError } = await supabase.rpc('inflict_boss_damage', {
        p_boss_id: bossId,
        p_player_id: player.id,
        p_damage: damage
      })

      if (uError) throw uError

      // 5. Chance de Drop Imediato (Gold pequeno por ataque)
      const goldReward = Math.floor(damage / 10)
      if (goldReward > 0) {
        await supabase.from('players').update({ 
          gold: player.gold + goldReward 
        }).eq('id', player.id)
      }

      return new Response(JSON.stringify({ 
        success: true, 
        damage_dealt: damage,
        gold_earned: goldReward,
        boss_remaining_hp: boss.current_hp - damage
      }), { status: 200 })

    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})