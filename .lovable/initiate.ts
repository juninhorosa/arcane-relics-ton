import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!
const TON_RECEIVER_WALLET = process.env.TON_RECEIVER_WALLET!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/purchases/initiate')({
  POST: async ({ request }) => {
    try {
      const { initData, packCode } = await request.json()

      // 1. Validar sessão do Telegram
      if (!validateTelegramInitData(initData, TELEGRAM_BOT_TOKEN)) {
        return new Response(JSON.stringify({ error: 'Sessão inválida' }), { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const userStr = urlParams.get('user')
      if (!userStr) return new Response(JSON.stringify({ error: 'Dados de usuário ausentes' }), { status: 400 })
      const tgUser = JSON.parse(userStr)

      // 2. Buscar Jogador
      const { data: profile, error: pError } = await supabase
        .from('profiles')
        .select('id, players(id)')
        .eq('telegram_id', tgUser.id)
        .single()

      const player = (profile as any)?.players?.[0]
      if (pError || !player) {
        return new Response(JSON.stringify({ error: 'Jogador não encontrado' }), { status: 404 })
      }

      // 3. Buscar informações do Pack
      const { data: pack, error: pkError } = await supabase
        .from('packs')
        .select('*')
        .eq('code', packCode)
        .single()

      if (pkError || !pack) {
        return new Response(JSON.stringify({ error: 'Pack não encontrado' }), { status: 404 })
      }

      // 4. Criar registro de compra pendente
      const { data: purchase, error: iError } = await supabase
        .from('pack_purchases')
        .insert({
          player_id: player.id,
          pack_id: pack.id,
          ton_amount: pack.ton_price,
          status: 'pending'
        })
        .select()
        .single()

      if (iError || !purchase) {
        throw new Error('Falha ao criar registro de compra')
      }

      return new Response(JSON.stringify({
        purchaseId: purchase.id,
        amount: pack.ton_price,
        receiver: TON_RECEIVER_WALLET
      }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})