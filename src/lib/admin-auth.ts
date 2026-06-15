import { SupabaseClient } from '@supabase/supabase-js'
import { Database } from '../integrations/supabase/types'

/**
 * Verifica se a requisição provém de um usuário autenticado com a role 'admin'.
 * Retorna o objeto do usuário em caso de sucesso ou uma Response de erro em caso de falha.
 */
export async function verifyAdmin(request: Request, supabase: SupabaseClient<Database>) {
  const authHeader = request.headers.get('Authorization')
  if (!authHeader) {
    return { error: new Response(JSON.stringify({ error: 'Não autorizado' }), { status: 401 }) }
  }

  const { data: { user }, error: authError } = await supabase.auth.getUser(authHeader.replace('Bearer ', ''))
  if (authError || !user) {
    return { error: new Response(JSON.stringify({ error: 'Sessão inválida ou expirada' }), { status: 401 }) }
  }

  const { data: roleData, error: roleError } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', user.id)
    .eq('role', 'admin')
    .single()

  if (roleError || !roleData) {
    return { error: new Response(JSON.stringify({ error: 'Acesso negado: Requer privilégios de administrador' }), { status: 403 }) }
  }

  return { user }
}