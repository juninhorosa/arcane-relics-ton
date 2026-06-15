import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import { validateTelegramInitData } from '../../../lib/telegram-auth'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/nations/join')({
  POST: async ({ request }) => {
    try {
      const { initData, nationCode } = await request.json()

      if (!validateTelegramInitData(initData, TELEGRAM_BOT_TOKEN)) {
        return new Response(JSON.stringify({ error: 'Sessão inválida' }), { status: 401 })
      }

      const urlParams = new URLSearchParams(initData)
      const userStr = urlParams.get('user')
      if (!userStr) return new Response(JSON.stringify({ error: 'Dados de usuário ausentes' }), { status: 400 })
      const tgUser = JSON.parse(userStr)

      const { data: nation } = await supabase.from('nations').select('id, name').eq('code', nationCode).single()
      const { data: profile } = await supabase.from('profiles').select('id').eq('telegram_id', tgUser.id).single()

      if (!nation || !profile) {
        return new Response(JSON.stringify({ error: 'Nação ou Perfil não encontrado' }), { status: 404 })
      }

      // Verifica se o jogador já existe para evitar múltiplas escolhas
      const { data: existingPlayer } = await supabase.from('players').select('id').eq('user_id', profile.id).single()
      if (existingPlayer) {
        return new Response(JSON.stringify({ error: 'Você já possui uma nação' }), { status: 400 })
      }

      const { error: joinError } = await supabase.from('players').insert({
        user_id: profile.id,
        nation_id: nation.id
      })

      if (joinError) throw joinError

      return new Response(JSON.stringify({ success: true }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})