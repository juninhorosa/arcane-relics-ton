import { createFileRoute } from '@tanstack/react-router'
import { createClient } from '@supabase/supabase-js'
import { useEffect, useState } from 'react'
import { Battlefield3D } from '../components/Battlefield3D'
import { cn } from '../lib/utils'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/invasion')({
  component: InvasionScreen,
})

function InvasionScreen() {
  const [invasion, setInvasion] = useState<any>(null)
  const [defenders, setDefenders] = useState<any[]>([])
  const [timeLeft, setTimeLeft] = useState<string>('00:00')
  const [phase, setPhase] = useState<'prep' | 'attack' | 'ended'>('prep')
  const [loading, setLoading] = useState(true)
  const [attacking, setAttacking] = useState(false)
  const [damagePopups, setDamagePopups] = useState<{id: number, val: number, type: string}[]>([])

  const initData = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initData : ''

  useEffect(() => {
    const fetchInvasion = async () => {
      const { data } = await supabase
        .from('active_invasions' as any)
        .select('*, nations:target_nation_id(name, code)')
        .eq('status', 'active') // Busca a invasÃ£o global ativa
        .single()

      if (data) setInvasion(data)
      
      // Carregar defensores ativos
      const { data: defs } = await supabase
        .from('invasion_participants')
        .select('*, profiles:player_id(display_name)')
        .eq('invasion_id', data?.id)
        .eq('side', 'defender')
        .gt('current_hp', 0)
      
      setDefenders(defs || [])
      setLoading(false)
    }

    fetchInvasion()
    const sub = supabase.channel('invasions').on('postgres_changes', { event: '*', schema: 'public', table: 'active_invasions' }, fetchInvasion).subscribe()
    const subDefs = supabase.channel('defenders').on('postgres_changes', { event: '*', schema: 'public', table: 'invasion_participants' }, fetchInvasion).subscribe()
    
    return () => { 
      supabase.removeChannel(sub)
      supabase.removeChannel(subDefs)
    }
  }, [])

  // Timer Logic
  useEffect(() => {
    if (!invasion) return

    const timer = setInterval(() => {
      const now = new Date().getTime()
      const prepEnd = new Date(invasion.preparation_ends_at).getTime()
      const attackEnd = new Date(invasion.attack_ends_at).getTime()

      if (now < prepEnd) {
        setPhase('prep')
        const diff = prepEnd - now
        setTimeLeft(formatTime(diff))
      } else if (now < attackEnd) {
        setPhase('attack')
        const diff = attackEnd - now
        setTimeLeft(formatTime(diff))
      } else {
        setPhase('ended')
        setTimeLeft('00:00')
        clearInterval(timer)
      }
    }, 1000)

    return () => clearInterval(timer)
  }, [invasion])

  const formatTime = (ms: number) => {
    const m = Math.floor(ms / 60000)
    const s = Math.floor((ms % 60000) / 1000)
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
  }

  const handleStrike = async () => {
    if (phase !== 'attack' || attacking) return
    setAttacking(true)
    
    try {
      const res = await fetch('/api/invasion/damage', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ initData, invasionId: invasion.id })
      })
      const data = await res.json()
      if (data.success) {
        const newPopup = { id: Date.now(), val: data.damage, type: data.targetType }
        setDamagePopups(prev => [...prev, newPopup])
        setTimeout(() => setDamagePopups(prev => prev.filter(p => p.id !== newPopup.id)), 800)
      }
    } catch (e) { console.error(e) }
    finally { setAttacking(false) }
  }

  if (loading) return <div className="min-h-screen bg-void-slate flex items-center justify-center font-cinzel text-arcane-gold">Rastreando exÃ©rcitos...</div>
  if (!invasion) return (
    <div className="min-h-screen bg-void-slate flex flex-col items-center justify-center p-8 text-center text-white">
      <div className="text-6xl mb-4">ðŸ•Šï¸</div>
      <h1 className="text-2xl font-black font-cinzel text-arcane-gold mb-2">Paz no Horizonte</h1>
      <p className="text-slate-400">Nenhuma naÃ§Ã£o estÃ¡ sob ataque no momento.</p>
    </div>
  )

  const healthPercent = (invasion.relic_health / invasion.max_relic_health) * 100

  return (
    <div className="min-h-screen bg-void-slate text-white p-4 flex flex-col items-center overflow-hidden">
      {/* Header Status */}
      <div className="w-full text-center mt-4">
        <div className={cn(
          "inline-block px-6 py-1 rounded-full text-xs font-black uppercase tracking-widest mb-2",
          phase === 'prep' ? "bg-blue-600 animate-pulse" : "bg-red-600 shadow-[0_0_15px_rgba(220,38,38,0.5)]"
        )}>
          {phase === 'prep' ? 'âš ï¸ PREPARAÃ‡ÃƒO PARA ATAQUE' : 'âš”ï¸ FASE DE DESTRUIÃ‡ÃƒO'}
        </div>
        <h1 className="text-3xl font-black font-cinzel text-white">
          CERCO A {invasion.nations.name.toUpperCase()}
        </h1>
        <div className="text-5xl font-mono font-black text-arcane-gold mt-2">{timeLeft}</div>
      </div>

      {/* Visual 3D */}
      <div className="relative w-full">
        <Battlefield3D isActive={phase === 'attack'} healthPercent={healthPercent} />
        
        {/* Popups de Dano Animados */}
        {damagePopups.map(p => (
          <div key={p.id} className={cn(
            "absolute left-1/2 top-1/2 -translate-x-1/2 text-4xl font-black animate-ping-once pointer-events-none z-50",
            p.type === 'relic' ? "text-yellow-500" : "text-red-500"
          )}>
            -{p.val}
          </div>
        ))}
      </div>

      {/* Lista de Defensores (Barreira Humana) */}
      <div className="w-full max-w-sm px-4 mb-6">
        <h3 className="text-[10px] font-bold text-blue-400 uppercase mb-2 tracking-widest">
          ðŸ›¡ï¸ Linha de Defesa ({defenders.length})
        </h3>
        <div className="flex gap-2 overflow-x-auto pb-2">
          {defenders.map(d => (
            <div key={d.id} className="min-w-[80px] bg-blue-900/20 border border-blue-500/30 p-2 rounded-lg text-center">
              <div className="text-[8px] truncate mb-1 text-blue-200">{d.profiles?.display_name}</div>
              <div className="h-1 w-full bg-slate-800 rounded-full overflow-hidden">
                <div className="h-full bg-blue-500" style={{ width: `${(d.current_hp / d.max_hp) * 100}%` }} />
              </div>
            </div>
          ))}
          {defenders.length === 0 && <div className="text-[10px] text-slate-600 italic font-cinzel">Defesas rompidas! RelÃ­quia exposta!</div>}
        </div>
      </div>

      {/* Relic Health Bar */}
      <div className="w-full max-w-sm px-4 mb-8">
        <div className="flex justify-between text-[10px] font-bold text-slate-500 mb-1">
          <span>INTEGRIDADE DA RELÃQUIA</span>
          <span className="text-white">{Math.floor(invasion.relic_health).toLocaleString()} HP</span>
        </div>
        <div className="h-4 w-full bg-slate-900 rounded-full border border-slate-700 p-0.5 overflow-hidden">
          <div 
            className="h-full bg-gradient-to-r from-red-600 to-red-400 rounded-full transition-all duration-500" 
            style={{ width: `${healthPercent}%` }}
          />
        </div>
      </div>

      {/* Action Area */}
      <div className="w-full max-w-sm space-y-4">
        <button 
          onClick={handleStrike}
          disabled={phase !== 'attack' || attacking}
          className={cn(
            "w-full py-5 rounded-2xl font-black text-xl uppercase tracking-widest transition-all active:scale-95",
            phase === 'attack' 
              ? "bg-red-600 shadow-[0_0_30px_rgba(220,38,38,0.3)] hover:bg-red-500" 
              : "bg-slate-800 opacity-50 cursor-not-allowed"
          )}
        >
          {phase === 'prep' ? 'Aguarde InÃ­cio...' : attacking ? 'GOLPEANDO...' : 'âš”ï¸ ATACAR RELÃQUIA'}
        </button>
        
        <div className="bg-slate-900/60 border border-white/5 p-4 rounded-xl text-center">
          <p className="text-[10px] text-slate-500 uppercase leading-relaxed">
            {phase === 'prep' 
              ? "Invasores estÃ£o se posicionando. Defensores, reÃºnam seus exÃ©rcitos agora!" 
              : "A RelÃ­quia estÃ¡ vulnerÃ¡vel! Todos os atacantes devem focar o dano. Defensores, tentem expulsar os invasores!"}
          </p>
        </div>
      </div>
    </div>
  )
}

export default InvasionScreen
