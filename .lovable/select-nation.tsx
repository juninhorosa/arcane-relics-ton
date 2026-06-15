import { createFileRoute, useNavigate } from '@tanstack/react-start'
import { createClient } from '@supabase/supabase-js'
import { useEffect, useState } from 'react'
import type { Database } from '../integrations/supabase/types'
import { NationCrest } from '../components/NationCrest'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/select-nation')({
  component: SelectNation,
})

function SelectNation() {
  const navigate = useNavigate()
  const [nations, setNations] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [joining, setJoining] = useState(false)
  const [totalPlayers, setTotalPlayers] = useState(0)

  const initData = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initData : ''

  useEffect(() => {
    const fetchData = async () => {
      // Obtém contagem de jogadores para bônus de balanceamento (Fase 8.4)
      const { data: counts } = await supabase.rpc('get_nation_player_counts' as any)
      const { data: nationsData } = await supabase.from('nations').select('*')
      
      const total = counts?.reduce((acc: number, curr: any) => acc + Number(curr.count), 0) || 0
      setTotalPlayers(total)

      const processed = nationsData?.map(n => {
        const count = counts?.find((c: any) => c.code === n.code)?.count || 0
        return { ...n, count: Number(count) }
      })

      setNations(processed || [])
      setLoading(false)
    }
    fetchData()
  }, [])

  const handleJoin = async (code: string) => {
    if (!confirm('Esta escolha é permanente. Deseja jurar lealdade a esta nação?')) return
    
    setJoining(true)
    try {
      const res = await fetch('/api/nations/join', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ initData, nationCode: code })
      })
      const data = await res.json()
      if (res.ok) {
        navigate({ to: '/' })
      } else {
        alert(data.error)
      }
    } catch (e) {
      console.error(e)
    } finally {
      setJoining(false)
    }
  }

  if (loading) return <div className="p-8 text-center font-cinzel italic text-slate-500">Revelando o destino do reino...</div>

  return (
    <div className="p-4 bg-slate-900 min-h-screen text-white flex flex-col items-center">
      <header className="mb-8 text-center pt-6">
        <h1 className="text-3xl font-black text-yellow-500 uppercase tracking-widest mb-2 font-cinzel">Jure Lealdade</h1>
        <p className="text-slate-400 text-sm max-w-[280px] mx-auto">
          Sua escolha definirá seus bônus, seus aliados e seus inimigos eternos.
        </p>
      </header>

      <div className="grid grid-cols-1 gap-4 w-full max-w-sm pb-10">
        {nations.map((n) => {
          const isUnderpopulated = totalPlayers > 10 && (n.count / totalPlayers) < 0.15
          
          return (
            <button
              key={n.id}
              disabled={joining}
              onClick={() => handleJoin(n.code)}
              className="relative overflow-hidden bg-slate-800 border border-slate-700 rounded-2xl p-5 text-left transition-all active:scale-95 hover:border-yellow-600/50 group"
            >
              <div className="absolute top-0 left-0 w-1 h-full" style={{ backgroundColor: n.color }}></div>
              
              <div className="flex items-center gap-5 relative z-10">
                <NationCrest nationCode={n.code} size={64} className="group-hover:scale-110 transition-transform duration-300" />
                
                <div className="flex-1">
                  <div className="flex items-center justify-between mb-1">
                    <h3 className="text-xl font-black tracking-tight font-cinzel">{n.name}</h3>
                    {isUnderpopulated && (
                      <span className="bg-yellow-500/10 text-yellow-500 text-[10px] px-2 py-0.5 rounded-full font-bold animate-pulse">
                        🔥 BÔNUS 25%
                      </span>
                    )}
                  </div>
                  <p className="text-xs text-slate-500 italic">
                    {n.code === 'BLOOD' && "Herdeiros do sacrifício e da fúria."}
                    {n.code === 'VOID' && "Arquitetos do vazio e do arcano."}
                    {n.code === 'GOLD' && "Linhagem da ordem e da luz eterna."}
                    {n.code === 'IRON' && "A força inquebrável das forjas."}
                    {n.code === 'SHADOW' && "Aqueles que caminham entre os mundos."}
                  </p>
                </div>
              </div>

              {/* Efeito de brilho ao passar o mouse */}
              <div className="absolute inset-0 bg-gradient-to-r from-transparent to-yellow-600/5 opacity-0 group-hover:opacity-100 transition-opacity"></div>
            </button>
          )
        })}
      </div>

      <p className="text-[10px] text-slate-600 uppercase text-center mt-auto pb-4 tracking-widest font-cinzel">
        Uma vez escolhido, o caminho não pode ser desfeito.
      </p>
    </div>
  )
}