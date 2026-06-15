import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'
import { verifyAdmin } from '../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/stats')({
  GET: async ({ request }) => {
    try {
      const { error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError
      
      // Total de Jogadores
      const { count: totalPlayers } = await supabase
        .from('players')
        .select('*', { count: 'exact', head: true })

      // TON Arrecadado
      const { data: purchases } = await supabase
        .from('pack_purchases')
        .select('ton_amount')
        .eq('status', 'confirmed')

      const totalTon = purchases?.reduce((sum, p) => sum + Number(p.ton_amount), 0) || 0

      // Packs Vendidos (Contagem por tipo)
      const { data: packStats } = await supabase
        .from('pack_purchases')
        .select('packs(name)')
        .eq('status', 'confirmed')

      const salesByPack = packStats?.reduce((acc: any, curr: any) => {
        const name = curr.packs.name
        acc[name] = (acc[name] || 0) + 1
        return acc
      }, {})

      // Batalhas Totais
      const { count: totalBattles } = await supabase
        .from('battles')
        .select('*', { count: 'exact', head: true })

      // Rivalidades Ativas (Streaks para Proteção Divina)
      const { data: rivalries } = await supabase
        .from('nation_consecutive_wins')
        .select(`
          count,
          winner:winner_nation_id(name),
          loser:loser_nation_id(name)
        `)
        .gt('count', 0)
        .order('count', { ascending: false })

      return new Response(JSON.stringify({
        totalPlayers,
        totalTon,
        totalBattles,
        salesByPack,
        rivalries: rivalries || []
      }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})