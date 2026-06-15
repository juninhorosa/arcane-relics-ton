import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/inventory/use')({
  POST: async ({ request }) => {
    try {
      const { initData, inventoryItemId } = await request.json()

      if (!validateTelegramInitData(initData, TELEGRAM_BOT_TOKEN)) {
        return new Response(JSON.stringify({ error: 'Sessão inválida' }), { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const tgUser = JSON.parse(urlParams.get('user')!)

      // 1. Buscar o Player ID
      const { data: profile } = await supabase
        .from('profiles')
        .select('players(id)')
        .eq('telegram_id', tgUser.id)
        .single()

      const playerId = (profile as any)?.players?.[0]?.id
      if (!playerId) return new Response(JSON.stringify({ error: 'Herói não encontrado' }), { status: 404 })

      // 2. Chamar o RPC de cura
      const { data, error } = await supabase.rpc('use_health_potion', {
        p_player_id: playerId,
        p_inventory_item_id: inventoryItemId
      })

      if (error || !data.success) {
        return new Response(JSON.stringify({ error: data?.error || 'Erro ao usar poção' }), { status: 400 })
      }

      return new Response(JSON.stringify({ 
        success: true, 
        message: `Você recuperou ${data.healed} de vida!` 
      }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})