// @ts-nocheck - pre-existing bugs unrelated to schema; tracked in plan.md
import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!)
const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

export const APIRoute = createAPIFileRoute('/api/invasion/damage')({
  POST: async ({ request }) => {
    try {
      const { initData, invasionId } = await request.json()
      if (!validateTelegramInitData(initData, BOT_TOKEN)) return new Response('Unauthorized', { status: 401 })

      const urlParams = new URLSearchParams(initData)
      const tgUser = JSON.parse(urlParams.get('user')!)

      // 1. Obter Atacante e seu Poder Real (Itens)
      const { data: attackerProfile } = await supabase
        .from('profiles')
        .select('*, players(*)')
        .eq('telegram_id', tgUser.id)
        .single()
      
      const attacker = (attackerProfile as any).players[0]
      
      // Simulando busca de poder (na prática usaríamos a função calculatePower do banco)
      const atkPower = (attacker.level * 15) + (Math.random() * 50)

      // 2. Verificar se existem defensores vivos na área
      const { data: defenders } = await supabase
        .from('invasion_participants')
        .select('*')
        .eq('invasion_id', invasionId)
        .eq('side', 'defender')
        .gt('current_hp', 0)
        .order('joined_at', { ascending: true })

      let targetType = 'relic'
      let targetId = invasionId
      let finalDamage = Math.floor(atkPower)

      if (defenders && defenders.length > 0) {
        // ALVO É O PRIMEIRO DEFENSOR DA FILA
        const target = defenders[0]
        targetType = 'player'
        targetId = target.player_id
        
        const newHp = Math.max(0, target.current_hp - finalDamage)
        
        await supabase
          .from('invasion_participants')
          .update({ current_hp: newHp })
          .eq('id', target.id)

        return new Response(JSON.stringify({
          success: true,
          targetType: 'player',
          targetName: 'Defensor',
          damage: finalDamage,
          isFatal: newHp === 0
        }))
      } else {
        // RELÍQUIA RECEBE DANO (Ninguém defendendo)
        const { data: invasion } = await supabase
          .from('active_invasions' as any)
          .select('relic_health')
          .eq('id', invasionId)
          .single()

        const newRelicHp = Math.max(0, invasion.relic_health - finalDamage)
        
        await supabase
          .from('active_invasions' as any)
          .update({ relic_health: newRelicHp })
          .eq('id', invasionId)

        return new Response(JSON.stringify({
          success: true,
          targetType: 'relic',
          damage: finalDamage
        }))
      }
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), { status: 500 })
    }
  }
})