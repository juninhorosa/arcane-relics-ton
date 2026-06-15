import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../../integrations/supabase/types'
import { verifyAdmin } from '../../../../lib/admin-auth'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/admin/ranking/refresh')({
  POST: async ({ request }) => {
    try {
      const { error: adminError } = await verifyAdmin(request, supabase)
      if (adminError) return adminError

      // 1. Buscar nações e o ouro total dos jogadores
      const { data: nations } = await supabase
        .from('nations')
        .select('id, players ( gold, level )')

      if (!nations) throw new Error('Nations not found')

      const snapshots = nations.map(n => {
        const totalGold = n.players.reduce((sum, p) => sum + Number(p.gold), 0)
        const totalPower = n.players.reduce((sum, p) => sum + (p.level * 10), 0)
        
        return {
          nation_id: n.id,
          total_gold: totalGold,
          total_power: totalPower,
          total_players: n.players.length,
          snapshot_date: new Date().toISOString().split('T')[0]
        }
      })

      // Ordenar para definir o Rank
      snapshots.sort((a, b) => b.total_gold - a.total_gold)
      const rankedSnapshots = snapshots.map((s, i) => ({ ...s, rank: i + 1 }))

      // 2. Upsert no banco (Cache persistente)
      const { error } = await supabase
        .from('nation_ranking')
        .upsert(rankedSnapshots, { onConflict: 'nation_id,snapshot_date' })

      if (error) throw error

      return new Response(JSON.stringify({ success: true }), { status: 200 })
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})