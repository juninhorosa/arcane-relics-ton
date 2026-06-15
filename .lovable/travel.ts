import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/player/travel')({
  POST: async ({ request }) => {
    try {
      const { initData, mapId } = await request.json()

      if (!validateTelegramInitData(initData, TELEGRAM_BOT_TOKEN)) {
        return new Response(JSON.stringify({ error: 'Sessão inválida' }), { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const userStr = urlParams.get('user')
      if (!userStr) return new Response(JSON.stringify({ error: 'Dados de usuário ausentes' }), { status: 400 })
      const tgUser = JSON.parse(userStr)

      // 1. Obter dados do jogador e do mapa
      const { data: playerProfile } = await supabase
        .from('profiles')
        .select('players(id, level)')
        .eq('telegram_id', tgUser.id)
        .single()
      
      const player = (playerProfile as any)?.players?.[0]
      if (!player) return new Response(JSON.stringify({ error: 'Jogador não encontrado' }), { status: 404 })

      const { data: map, error: mapError } = await supabase
        .from('maps')
        .select('id, name, min_level')
        .eq('id', mapId)
        .single()

      if (mapError || !map) {
        return new Response(JSON.stringify({ error: 'Mapa não encontrado' }), { status: 404 })
      }

      // 2. Validar se o jogador tem nível para o mapa
      if (player.level < map.min_level) {
        return new Response(JSON.stringify({ error: `Você precisa ser nível ${map.min_level} para viajar para ${map.name}` }), { status: 403 })
      }

      // 3. Atualizar o mapa atual do jogador
      await supabase.from('players').update({ current_map_id: mapId }).eq('id', player.id)

      return new Response(JSON.stringify({ success: true, message: `Você viajou para ${map.name}!` }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})