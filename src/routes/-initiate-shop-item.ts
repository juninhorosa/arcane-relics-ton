import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!)
const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

export const APIRoute = createAPIFileRoute('/api/purchases/initiate-shop-item')({
  POST: async ({ request }) => {
    try {
      const { initData, itemCode } = await request.json()
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

      const { data: shopItem, error: shopErr } = await supabase
        .from('shop_items')
        .select('*')
        .eq('code', itemCode)
        .eq('active', true)
        .single()

      if (shopErr || !shopItem) {
        return new Response(JSON.stringify({ error: 'Item não encontrado na loja' }), { status: 404 })
      }

      const { data: purchase, error: insertErr } = await supabase
        .from('pack_purchases')
        .insert({
          player_id: player.id,
          ton_amount: shopItem.ton_price,
          status: 'pending',
          pack_id: null,
          shop_item_id: shopItem.id
        })
        .select()
        .single()

      if (insertErr) {
        return new Response(JSON.stringify({ error: 'Erro ao criar compra' }), { status: 500 })
      }

      return new Response(JSON.stringify({
        purchaseId: purchase.id,
        amount: shopItem.ton_price,
        receiver: process.env.TON_RECEIVER_WALLET || ''
      }), { status: 200 })
    } catch (e: any) {
      return new Response(JSON.stringify({ error: e.message }), { status: 500 })
    }
  }
})
