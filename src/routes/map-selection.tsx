import { createFileRoute, useNavigate } from '@tanstack/react-router'
import { createClient } from '@supabase/supabase-js'
import { useEffect, useState } from 'react'
import type { Database } from '../integrations/supabase/types'
import { Arcane3D } from '../components/Arcane3D'
import { cn } from '../lib/utils'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/map-selection')({
  component: MapSelection,
})

function MapSelection() {
  const navigate = useNavigate()
  const [maps, setMaps] = useState<any[]>([])
  const [player, setPlayer] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [traveling, setTraveling] = useState(false)

  const initData = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initData : ''

  useEffect(() => {
    const fetchData = async () => {
      const tgUser = (window as any).Telegram?.WebApp?.initDataUnsafe?.user
      if (!tgUser) return

      const { data: profile } = await supabase
        .from('profiles')
        .select('players(id, level, current_map_id)')
        .eq('telegram_id', tgUser.id)
        .single()
      
      const playerData = (profile as any)?.players?.[0]
      if (!playerData) return // Redirecionar para home se nÃ£o for player
      setPlayer(playerData)

      const { data: mapsData } = await supabase
        .from('maps')
        .select('*')
        .order('min_level', { ascending: true })
      
      setMaps(mapsData || [])
      setLoading(false)
    }
    fetchData()
  }, [])

  const handleTravel = async (mapId: string) => {
    if (!player) return

    const selectedMap = maps.find(m => m.id === mapId)
    if (!selectedMap) return

    if (player.level < selectedMap.min_level) {
      alert(`VocÃª precisa ser nÃ­vel ${selectedMap.min_level} para viajar para ${selectedMap.name}!`)
      return
    }

    setTraveling(true)
    try {
      const res = await fetch('/api/player/travel', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ initData, mapId })
      })
      const data = await res.json()
      if (res.ok) {
        alert(data.message)
        navigate({ to: '/' }) // Volta para a home apÃ³s viajar
      } else {
        alert(data.error)
      }
    } catch (e) {
      console.error(e)
    } finally {
      setTraveling(false)
    }
  }

  if (loading) return <div className="min-h-screen bg-void-slate flex items-center justify-center font-cinzel text-arcane-gold animate-pulse text-xl">Carregando mapas...</div>

  return (
    <div className="p-4 bg-void-slate min-h-screen text-white flex flex-col items-center">
      <header className="mb-8 text-center pt-6">
        <h1 className="text-3xl font-black text-arcane-gold uppercase tracking-widest mb-2 font-cinzel">Jornada Arcana</h1>
        <p className="text-slate-400 text-sm max-w-[280px] mx-auto">
          Escolha sua prÃ³xima regiÃ£o de caÃ§a. Mapas mais perigosos oferecem maiores recompensas.
        </p>
      </header>

      {/* Visual 3D Central */}
      <div className="relative w-full h-64 mb-8">
        <Arcane3D />
        <div className="absolute inset-0 flex items-center justify-center z-10">
          <p className="text-xl font-cinzel text-arcane-gold drop-shadow-lg">
            {player?.current_map_id ? maps.find(m => m.id === player.current_map_id)?.name : 'Selecione um Mapa'}
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-4 w-full max-w-sm pb-10">
        {maps.map((map) => {
          const isLocked = player && player.level < map.min_level
          const isCurrent = player && player.current_map_id === map.id

          return (
            <button
              key={map.id}
              disabled={isLocked || traveling || isCurrent}
              onClick={() => handleTravel(map.id)}
              className={cn(
                "relative overflow-hidden bg-slate-800/40 border rounded-2xl p-5 text-left transition-all active:scale-95 group",
                isLocked ? "border-slate-700 opacity-50 cursor-not-allowed" : "border-slate-700 hover:border-arcane-gold/50",
                isCurrent && "border-emerald-500 ring-2 ring-emerald-500/30"
              )}
            >
              <div className="absolute top-0 left-0 w-1 h-full bg-slate-600" style={{ backgroundColor: isCurrent ? '#10B981' : isLocked ? '#475569' : '#D4AF37' }}></div>
              
              <div className="flex items-center gap-4 relative z-10">
                <div className="text-4xl">{isLocked ? 'ðŸ”’' : 'ðŸ—ºï¸'}</div>
                <div className="flex-1">
                  <h3 className="text-xl font-black tracking-tight font-cinzel">{map.name}</h3>
                  <p className="text-xs text-slate-500 italic">NÃ­vel MÃ­nimo: {map.min_level}</p>
                </div>
                {isCurrent && <span className="bg-emerald-500/10 text-emerald-500 text-[10px] px-2 py-0.5 rounded-full font-bold">ATUAL</span>}
              </div>
            </button>
          )
        })}
      </div>
    </div>
  )
}
