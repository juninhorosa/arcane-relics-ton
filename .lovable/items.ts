import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'
import { verifyAdmin } from '../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/items')({
  GET: async ({ request }) => {
    const { error: adminError } = await verifyAdmin(request, supabase)
    if (adminError) return adminError

    const { data, error } = await supabase
      .from('item_templates')
      .select('*')
      .order('class', { ascending: false })
    
    if (error) return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    return new Response(JSON.stringify(data), { status: 200 })
  },
  POST: async ({ request }) => {
    try {
      const { error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError

      const item = await request.json()
      
      // Validação básica: relíquias devem ser classe 20
      if (item.is_relic && item.class !== 20) {
        return new Response(JSON.stringify({ error: 'Relíquias devem ser de classe 20' }), { status: 400 })
      }

      const { data, error } = await supabase
        .from('item_templates')
        .insert(item)
        .select()
        .single()

      if (error) throw error

      // Se for uma relíquia, registrar na tabela de relics também
      if (data.is_relic) {
        await supabase.from('relics').insert({ template_id: data.id })
      }

      return new Response(JSON.stringify({ 
        success: true, 
        message: 'Item forjado com sucesso!',
        data 
      }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})