import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'
import { verifyAdmin } from '../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/audit-logs')({
  GET: async ({ request }) => {
    const { error: adminError } = await verifyAdmin(request, supabase)
    if (adminError) return adminError

    const url = new URL(request.url)
    const type = url.searchParams.get('type')
    const search = url.searchParams.get('search')
    const page = parseInt(url.searchParams.get('page') || '0')
    const pageSize = 20
    const from = page * pageSize
    const to = from + pageSize - 1

    // Ao realizar busca, utilizamos !inner joins para filtrar as linhas raiz baseadas nos dados do perfil do herói alvo
    const selectStr = search 
      ? `
        id,
        action_type,
        reason,
        created_at,
        target:target_player_id!inner(profiles!inner(display_name, username)),
        admin:admin_id(id)
      `
      : `
        id,
        action_type,
        reason,
        created_at,
        target:target_player_id(profiles(display_name, username)),
        admin:admin_id(id)
      `;

    let query = supabase
      .from('admin_audit_logs')
      .select(selectStr, { count: 'exact' })

    if (type && type !== 'all') {
      query = query.eq('action_type', type)
    }

    if (search) {
      // Filtra por display_name ou username do herói alvo (profiles)
      // O caminho reflete os aliases definidos no select: target -> profiles
      query = query.or(`display_name.ilike.%${search}%,username.ilike.%${search}%`, { foreignTable: 'target.profiles' })
    }

    const { data, error, count } = await query
      .order('created_at', { ascending: false })
      .range(from, to)

    if (error) return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    return new Response(JSON.stringify({ data, count }), { status: 200 })
  }
})