import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../../integrations/supabase/types'
import { verifyAdmin } from '../../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/inventory/grant')({
  POST: async ({ request }) => {
    try {
      // 0. Verificar autenticação e role de admin
      const { user, error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError

      const { playerId, templateId, quantity } = await request.json()
      const grantQuantity = parseInt(quantity) || 1

      // 1. Validar item template
      const { data: template, error: tError } = await supabase
        .from('item_templates')
        .select('name')
        .eq('id', templateId)
        .single()

      if (tError || !template) {
        return new Response(JSON.stringify({ error: 'Template de item não encontrado' }), { status: 404 })
      }

      // 2. Buscar se já possui no inventário
      const { data: existing } = await supabase
        .from('inventory')
        .select('id, quantity')
        .eq('player_id', playerId)
        .eq('template_id', templateId)
        .single()

      if (existing) {
        await supabase
          .from('inventory')
          .update({ quantity: existing.quantity + grantQuantity })
          .eq('id', existing.id)
      } else {
        await supabase
          .from('inventory')
          .insert({
            player_id: playerId,
            template_id: templateId,
            quantity: grantQuantity
          })
      }

      // 3. Registrar no log de auditoria
      await supabase.from('admin_audit_logs').insert({
        admin_id: user?.id,
        target_player_id: playerId,
        action_type: 'grant_item',
        reason: `Concedido(a) ${grantQuantity}x ${template.name}`
      })

      return new Response(JSON.stringify({ 
        success: true, 
        message: `Concedido(a) ${grantQuantity}x ${template.name}` 
      }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})