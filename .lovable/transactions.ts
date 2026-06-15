import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'
import { verifyAdmin } from '../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/transactions')({
  GET: async ({ request }) => {
    const { error: adminError } = await verifyAdmin(request, supabase)
    if (adminError) return adminError

    const { data, error } = await supabase
      .from('pack_purchases')
      .select('*, profiles:players(profiles(display_name, username)), packs(name)')
      .order('created_at', { ascending: false })
    
    if (error) return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    return new Response(JSON.stringify(data), { status: 200 })
  },
  // Confirmação Manual (Fallback)
  POST: async ({ request }) => {
    try {
      const { error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError

      const { purchaseId } = await request.json()
      
      // Chamamos o serviço de verificação existente, mas forçando o status
      // Aqui poderíamos ter uma lógica específica de 'manual_confirm'
      const res = await fetch(`${new URL(request.url).origin}/api/purchases/verify`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          purchaseId,
          txHash: 'MANUAL_CONFIRM_' + Date.now(),
          amountReceived: 0 // No modo manual ignoramos a conferência de valor on-chain
        })
      })

      const result = await res.json()
      return new Response(JSON.stringify(result), { status: res.status })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})