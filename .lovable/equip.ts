import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/inventory/equip')({
  POST: async ({ request }) => {
    try {
      const { initData, inventoryItemId } = await request.json()

      if (!validateTelegramInitData(initData, TELEGRAM_BOT_TOKEN)) {
        return new Response(JSON.stringify({ error: 'Sessão inválida' }), { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const tgUser = JSON.parse(urlParams.get('user')!)

      // 1. Verificar se o item pertence ao jogador e pegar o slot
      const { data: item, error: iError } = await supabase
        .from('inventory')
        .select('*, item_templates(slot), players!inner(id, telegram_id)')
        .eq('id', inventoryItemId)
        .eq('players.telegram_id', tgUser.id)
        .single()

      if (iError || !item) {
        return new Response(JSON.stringify({ error: 'Item não encontrado no seu inventário' }), { status: 404 })
      }

      const playerId = (item as any).players.id
      const slot = (item as any).item_templates.slot

      // 2. Upsert no equipamento (substitui o que estiver no slot)
      const { error: eError } = await supabase
        .from('equipment')
        .upsert({
          player_id: playerId,
          slot: slot,
          inventory_item_id: inventoryItemId,
          equipped_at: new Date().toISOString()
        }, { onConflict: 'player_id,slot' })

      if (eError) throw eError

      return new Response(JSON.stringify({ 
        success: true, 
        message: `Equipado com sucesso no slot ${slot}` 
      }), { status: 200 })

    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})