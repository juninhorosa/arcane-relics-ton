import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '@/lib/telegram-auth'

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!)
const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

export const APIRoute = createAPIFileRoute('/api/inventory/use')({
  POST: async ({ request }) => {
    try {
      const { initData, inventoryItemId } = await request.json()
      if (!validateTelegramInitData(initData, BOT_TOKEN)) {
        return new Response('Unauthorized', { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const tgUser = JSON.parse(urlParams.get('user')!)

      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(id)')
        .eq('telegram_id', tgUser.id)
        .single()

      const player = (profile as any)?.players?.[0]
      if (!player) {
        return new Response(JSON.stringify({ error: 'Jogador não encontrado' }), { status: 404 })
      }

      const { data: invItem, error: invErr } = await supabase
        .from('player_inventory')
        .select('*, items(*)')
        .eq('id', inventoryItemId)
        .eq('player_id', player.id)
        .single()

      if (invErr || !invItem) {
        return new Response(JSON.stringify({ error: 'Item não encontrado no inventário' }), { status: 404 })
      }

      const item = (invItem as any).items
      if (!item) {
        return new Response(JSON.stringify({ error: 'Template do item não encontrado' }), { status: 404 })
      }

      if (!item.code.startsWith('POTION_HP_')) {
        return new Response(JSON.stringify({ error: 'Este item não pode ser usado' }), { status: 400 })
      }

      const healAmount = item.hp_bonus || 0
      if (healAmount <= 0) {
        return new Response(JSON.stringify({ error: 'Item sem efeito de cura' }), { status: 400 })
      }

      const newQuantity = (invItem as any).quantity - 1
      if (newQuantity <= 0) {
        await supabase.from('player_inventory').delete().eq('id', inventoryItemId)
      } else {
        await supabase.from('player_inventory').update({ quantity: newQuantity }).eq('id', inventoryItemId)
      }

      return new Response(JSON.stringify({ success: true, healAmount }), { status: 200 })
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), { status: 500 })
    }
  }
})
