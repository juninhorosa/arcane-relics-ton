import { createFileRoute } from '@tanstack/react-start'
import { createClient } from '@supabase/supabase-js'
import { cn } from '../lib/utils'
import { useEffect, useState, useRef } from 'react'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/world-boss')({
  component: WorldBoss,
})

function WorldBoss() {
  const [boss, setBoss] = useState<any>(null)
  const [ranking, setRanking] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [attacking, setAttacking] = useState(false)
  const [isShaking, setIsShaking] = useState(false)
  const [particles, setParticles] = useState<{ id: number; x: number; y: number }[]>([])
  const [lastDamage, setLastDamage] = useState<number | null>(null)
  
  const initData = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initData : ''

  const fetchBossData = async () => {
    // 1. Buscar o boss ativo
    const { data: bossData } = await supabase
      .from('world_bosses' as any)
      .select('*')
      .eq('status', 'active')
      .single()

    if (bossData) {
      setBoss(bossData)
      
      // 2. Buscar ranking de dano para este boss
      const { data: rankData } = await supabase
        .from('boss_damage_ranking' as any) // View ou consulta agregada
        .select('damage, display_name')
        .eq('boss_id', bossData.id)
        .order('damage', { ascending: false })
        .limit(5)

      setRanking(rankData || [])
    }
    setLoading(false)
  }

  // Polling para manter o HP e o Ranking atualizados globalmente
  useEffect(() => {
    fetchBossData()
    const interval = setInterval(fetchBossData, 5000)
    return () => clearInterval(interval)
  }, [])

  const handleAttack = async () => {
    if (!boss || attacking) return
    setAttacking(true)
    
    try {
      const res = await fetch('/api/world-boss/attack', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ initData, bossId: boss.id })
      })
      
      const data = await res.json()
      if (res.ok) {
        const damage = data.damage_dealt
        setLastDamage(damage)
        setIsShaking(true)
        
        // Gerar partículas de impacto aleatórias (Fase 10.4)
        const burst = Array.from({ length: 12 }).map((_, i) => ({
          id: Date.now() + i,
          x: (Math.random() - 0.5) * 280,
          y: (Math.random() - 0.5) * 280,
        }))
        setParticles(burst)

        // Feedback visual rápido de redução de HP antes do próximo poll
        setBoss((prev: any) => ({ ...prev, current_hp: prev.current_hp - damage }))
        
        setTimeout(() => setIsShaking(false), 400)
        setTimeout(() => {
          setLastDamage(null)
          setParticles([])
        }, 800)
      } else {
        alert(data.error)
      }
    } catch (e) {
      console.error(e)
    } finally {
      setAttacking(false)
    }
  }

  if (loading) return <div className="p-8 text-center text-slate-500 italic">Invocando a besta...</div>
  if (!boss) return (
    <div className="p-8 text-center bg-slate-900 min-h-screen text-white flex flex-col justify-center">
      <div className="text-6xl mb-4">🕊️</div>
      <h2 className="text-2xl font-bold">O Reino está em Paz</h2>
      <p className="text-slate-400">Nenhum Chefe de Mundo detectado no momento.</p>
    </div>
  )

  const hpPercentage = Math.max(0, (boss.current_hp / boss.max_hp) * 100)

  return (
    <div className="p-4 bg-slate-900 min-h-screen text-white pb-24">
      {/* Cabeçalho do Boss */}
      <div className={cn("relative mb-8 text-center pt-8 transition-transform", isShaking && "animate-shake")}>
        {/* Partículas de Impacto */}
        {particles.map((p) => (
          <div
            key={p.id}
            className="absolute left-1/2 top-1/2 w-1.5 h-1.5 bg-yellow-500 rounded-full animate-particle pointer-events-none z-50"
            style={{
              '--particle-x': `${p.x}px`,
              '--particle-y': `${p.y}px`,
            } as any}
          />
        ))}

        <div className="text-6xl mb-4 animate-bounce">👿</div>
        <h1 className="text-3xl font-black text-red-500 uppercase tracking-widest mb-2">{boss.name}</h1>
        <div className="flex justify-center gap-4 text-xs font-mono text-slate-400 uppercase">
          <span>Nível {boss.level || '??'}</span>
          <span>Evento Global</span>
        </div>
      </div>

      {/* Barra de Vida Animada */}
      <div className="mb-10 relative">
        <div className="flex justify-between text-xs font-bold mb-2 px-1">
          <span className="text-red-400">HP DO BOSS</span>
          <span>{Math.floor(boss.current_hp).toLocaleString()} / {boss.max_hp.toLocaleString()}</span>
        </div>
        <div className="h-6 w-full bg-slate-800 rounded-full border border-slate-700 p-1 shadow-inner overflow-hidden">
          <div 
            className="h-full bg-gradient-to-r from-red-900 via-red-600 to-red-400 rounded-full transition-all duration-1000 ease-out relative"
            style={{ width: `${hpPercentage}%` }}
          >
            <div className="absolute inset-0 bg-white/20 animate-pulse"></div>
          </div>
        </div>
        
        {/* Overlay de Dano (Feedback de Ataque) */}
        {lastDamage && (
          <div className="absolute top-[-40px] left-1/2 -translate-x-1/2 text-4xl font-black text-yellow-500 animate-ping-once pointer-events-none drop-shadow-[0_2px_2px_rgba(0,0,0,0.8)]">
            -{lastDamage}
          </div>
        )}
      </div>

      {/* Ranking de Dano */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-2xl p-4 mb-8">
        <h3 className="text-sm font-bold text-slate-400 uppercase mb-4 flex items-center gap-2">
          <span className="text-yellow-500">🏆</span> Principais Contribuidores
        </h3>
        <div className="space-y-3">
          {ranking.map((r, i) => (
            <div key={i} className="flex justify-between items-center bg-slate-900/40 p-2 rounded-lg border border-white/5">
              <div className="flex items-center gap-3">
                <span className="text-xs font-mono text-slate-500 w-4">#{i+1}</span>
                <span className="text-sm font-bold">{r.display_name}</span>
              </div>
              <span className="font-mono text-xs text-red-400 font-bold">{r.damage.toLocaleString()}</span>
            </div>
          ))}
          {ranking.length === 0 && <div className="text-center text-xs text-slate-600 py-2">Ninguém atacou ainda. Seja o primeiro!</div>}
        </div>
      </div>

      {/* Botão de Ataque */}
      <div className="fixed bottom-6 left-4 right-4">
        <button
          onClick={handleAttack}
          disabled={attacking || boss.current_hp <= 0}
          className={`
            w-full py-4 rounded-2xl font-black text-xl uppercase tracking-wider transition-all active:scale-90 duration-100
            ${attacking ? 'bg-slate-700 opacity-50' : 'bg-red-600 hover:bg-red-500 shadow-[0_0_20px_rgba(220,38,38,0.4)]'}
          `}
        >
          {attacking ? 'Golpeando...' : '⚔️ ATACAR AGORA'}
        </button>
      </div>

      {/* Estilos específicos para animações personalizadas */}
      <style jsx>{`
        @keyframes ping-once {
          0% { transform: translate(-50%, 0) scale(0.5); opacity: 0; }
          50% { opacity: 1; }
          100% { transform: translate(-50%, -40px) scale(1.5); opacity: 0; }
        }
        .animate-ping-once {
          animation: ping-once 1s ease-out forwards;
        }
      `}</style>
    </div>
  )
}

export default WorldBoss;