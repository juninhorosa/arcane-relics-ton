// @ts-nocheck - pending schema migration
import { createFileRoute } from '@tanstack/react-router'
import { createClient } from '@supabase/supabase-js'
import { useEffect, useState } from 'react'
import type { Database } from '../integrations/supabase/types'
import { NationCrest } from '../components/NationCrest'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/ranking')({
  component: Ranking,
})

function Ranking() {
  const [players, setPlayers] = useState<any[]>([])
  const [nations, setNations] = useState<any[]>([])
  const [tab, setTab] = useState<'players' | 'nations'>('players')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true)

      const { data: pData } = await supabase
        .from('players')
        .select('level, gold, wins, profiles(display_name, username), nations(name, code)')
        .order('gold', { ascending: false })
        .limit(20)

      const today = new Date().toISOString().split('T')[0]
      const { data: nRanking } = await supabase
        .from('nation_ranking')
        .select('*, nations(name, code, color, divine_protection_until)')
        .eq('snapshot_date', today)
        .order('rank', { ascending: true })

      let processedNations
      if (nRanking && nRanking.length > 0) {
        processedNations = nRanking.map(r => ({
          ...(r.nations as any),
          total_gold: r.total_gold,
          total_players: r.total_players
        }))
      } else {
        const { data: nData } = await supabase.from('nations').select('id, name, code, color, divine_protection_until, players ( gold )')
        processedNations = nData?.map(n => ({
          ...n,
          total_gold: n.players.reduce((sum: number, p: any) => sum + Number(p.gold), 0),
          total_players: n.players.length
        })).sort((a, b) => b.total_gold - a.total_gold) || []
      }

      setPlayers(pData || [])
      setNations(processedNations || [])
      setLoading(false)
    }

    fetchData()
  }, [])

  let content: React.ReactNode

  if (loading) {
    content = <div className="text-center py-10 italic text-slate-500">Consultando orÃ¡culos...</div>
  } else if (tab === 'players') {
    content = (
      <div className="space-y-3">
        {players.map((p, i) => (
          <div key={i} className={`flex items-center p-3 rounded-lg border ${i === 0 ? 'bg-yellow-900/20 border-yellow-600' : 'bg-slate-800/50 border-slate-700'}`}>
            <div className="w-8 font-mono text-lg font-bold text-slate-500">#{i + 1}</div>
            <NationCrest nationCode={p.nations?.code || 'GOLD'} size={32} className="mr-3" />
            <div className="flex-1">
              <div className="font-bold">{(p.profiles as any)?.display_name}</div>
              <div className="text-[10px] text-slate-400 uppercase tracking-tighter">
                {p.nations?.name} â€¢ LVL {p.level}
              </div>
            </div>
            <div className="text-right">
              <div className="text-yellow-500 font-bold">ðŸ’° {p.gold.toLocaleString()}</div>
              <div className="text-[10px] text-green-500">{p.wins} VitÃ³rias</div>
            </div>
          </div>
        ))}
      </div>
    )
  } else {
    content = (
      <div className="space-y-4">
        {nations.map((n, i) => {
          const isProtected = n.divine_protection_until && new Date(n.divine_protection_until) > new Date()
          return (
            <div key={n.id} className={`relative overflow-hidden bg-slate-800 border rounded-xl p-4 shadow-lg transition-all ${isProtected ? 'border-blue-500 ring-1 ring-blue-500/50' : 'border-slate-700'}`}>
              <div className="absolute top-0 left-0 w-1 h-full" style={{ backgroundColor: n.color }} />
              {isProtected && (
                <div className="absolute top-2 right-2 flex items-center gap-1 bg-blue-600 text-[10px] px-2 py-0.5 rounded-full font-bold animate-pulse">
                  PROTEÃ‡ÃƒO DIVINA
                </div>
              )}
              <div className="flex justify-between items-center relative z-10">
                <div className="flex items-center gap-4">
                  <NationCrest nationCode={n.code} size={48} />
                  <div>
                    <div className="text-xs text-slate-500 font-mono">RANK #{i + 1}</div>
                    <h3 className="text-xl font-bold">{n.name}</h3>
                    {isProtected && (
                      <div className="text-[9px] text-blue-400 mt-1 font-mono">
                        Expira: {new Date(n.divine_protection_until).toLocaleTimeString()}
                      </div>
                    )}
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-yellow-500 font-black text-lg">{n.total_gold.toLocaleString()}</div>
                  <div className="text-[10px] text-slate-400 uppercase">Ouro Total</div>
                </div>
              </div>
            </div>
          )
        })}
      </div>
    )
  }

  return (
    <div className="p-4 bg-slate-900 min-h-screen text-white pb-20">
      <header className="mb-6 text-center">
        <h1 className="text-2xl font-bold text-yellow-500">Hall da Fama</h1>
        <div className="flex mt-4 bg-slate-800 rounded-lg p-1">
          <button
            onClick={() => setTab('players')}
            className={`flex-1 py-2 rounded-md text-sm font-bold transition-all ${tab === 'players' ? 'bg-yellow-600 shadow-lg' : 'text-slate-400'}`}
          >
            HerÃ³is
          </button>
          <button
            onClick={() => setTab('nations')}
            className={`flex-1 py-2 rounded-md text-sm font-bold transition-all ${tab === 'nations' ? 'bg-yellow-600 shadow-lg' : 'text-slate-400'}`}
          >
            <div className="flex items-center justify-center gap-2">
              <NationCrest nationCode="GOLD" size={16} />
              NaÃ§Ãµes
            </div>
          </button>
        </div>
      </header>
      {content}
    </div>
  )
}
