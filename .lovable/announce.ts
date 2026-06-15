import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'
import { verifyAdmin } from '../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/announce')({
  POST: async ({ request }) => {
    try {
      const { error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError

      const { message } = await request.json()
      if (!message) return new Response('Mensagem vazia', { status: 400 })

      // Buscar todos os usuários com telegram_id
      const { data: profiles, error } = await supabase
        .from('profiles')
        .select('telegram_id')
        .not('telegram_id', 'is', null)

      if (error) throw error

      let successCount = 0
      // Envio sequencial (Para muitos usuários, o ideal seria uma fila/background job)
      for (const profile of profiles) {
        try {
          const res = await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              chat_id: profile.telegram_id,
              text: `📢 *ANÚNCIO GLOBAL*\n\n${message}`,
              parse_mode: 'Markdown'
            })
          })
          if (res.ok) successCount++
        } catch (e) {
          console.error(`Erro ao enviar para ${profile.telegram_id}:`, e)
        }
      }

      return new Response(JSON.stringify({ success: true, sentTo: successCount }), { status: 200 })

    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})