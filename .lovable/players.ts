import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'
import { verifyAdmin } from '../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/players')({
  GET: async ({ request }) => {
    // Validação de Admin
    const { error: adminError } = await verifyAdmin(request, supabase)
    if (adminError) return adminError

    const url = new URL(request.url)
    const search = url.searchParams.get('search')

    let query = supabase
      .from('players')
      .select('*, profiles(display_name, username, is_banned), nations(name)')

    if (search) {
      query = query.or(`profiles.display_name.ilike.%${search}%,profiles.username.ilike.%${search}%`)
    }

    const { data, error } = await query.order('created_at', { ascending: false }).limit(50)

    if (error) return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    return new Response(JSON.stringify(data), { status: 200 })
  },
  PATCH: async ({ request }) => {
    try {
      // Validação de Admin
      const { user, error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError

      const { playerId, updates, reason } = await request.json()

      // Se a atualização for de banimento, afeta a tabela profiles
      if (updates.is_banned !== undefined) {
        const { data: player } = await supabase.from('players').select('user_id').eq('id', playerId).single();
        if (player) {
          const { error: profError } = await supabase.from('profiles').update({ is_banned: updates.is_banned }).eq('id', player.user_id);
          if (profError) throw profError;

          // Registrar log de auditoria
          await supabase.from('admin_audit_logs').insert({
            admin_id: user?.id,
            target_player_id: playerId,
            action_type: updates.is_banned ? 'ban' : 'unban',
            reason: reason || 'Sem motivo especificado'
          });
        }
        return new Response(JSON.stringify({ success: true, message: 'Status de banimento atualizado' }), { status: 200 });
      }

      // Lista branca de campos permitidos para edição via admin
      const allowedUpdates: any = {}
      if (updates.gold !== undefined) allowedUpdates.gold = updates.gold
      if (updates.level !== undefined) allowedUpdates.level = updates.level
      if (updates.nation_id !== undefined) allowedUpdates.nation_id = updates.nation_id

      const { data, error } = await supabase
        .from('players')
        .update(allowedUpdates)
        .eq('id', playerId)
        .select()
        .single()

      if (error) throw error

      // Log da ação (Opcional: implementar tabela de admin_logs no futuro)
      await supabase.from('gold_log').insert({
        player_id: playerId,
        amount: updates.gold || 0,
        reason: 'Ajuste manual via Painel Admin',
      })

      return new Response(JSON.stringify({ 
        success: true, 
        message: 'Jogador atualizado com sucesso',
        data 
      }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})