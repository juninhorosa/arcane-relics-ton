import { createFileRoute } from '@tanstack/react-router'
import { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'
import { NationCrest } from '../components/NationCrest'
import { cn } from '@/lib/utils'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

interface Nation {
  id: string
  code: string
  name: string
  description: string | null
  color: string | null
  emblem_url: string | null
}

export const Route = createFileRoute('/select-nation')({
  component: SelectNation,
})

function SelectNation() {
  const [playerId, setPlayerId] = useState<string | null>(null)
  const [nations, setNations] = useState<Nation[]>([])
  const [selectedNation, setSelectedNation] = useState<string | null>(null)
  const [currentNationId, setCurrentNationId] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState('')

  useEffect(() => {
    const load = async () => {
      const tgUser = (window as any).Telegram?.WebApp?.initDataUnsafe?.user
      if (!tgUser) return

      const { data: nationData } = await supabase.from('nations').select('*')
      if (nationData) setNations(nationData)

      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(id, nation_id)')
        .eq('telegram_id', tgUser.id)
        .single()

      const player = (profile as any)?.players?.[0]
      if (player) {
        setPlayerId(player.id)
        if (player.nation_id) {
          setCurrentNationId(player.nation_id)
          setSelectedNation(player.nation_id)
        }
      }
    }

    load()
  }, [])

  const handleSelectNation = async (nationId: string) => {
    if (!playerId) {
      setMessage('Erro: Jogador nÃ£o encontrado')
      return
    }

    setLoading(true)
    setMessage('')

    try {
      const { error: updateErr } = await supabase
        .from('players')
        .update({ nation_id: nationId })
        .eq('id', playerId)

      if (updateErr) {
        setMessage('Erro ao atualizar naÃ§Ã£o')
        return
      }

      setCurrentNationId(nationId)
      setSelectedNation(nationId)
      const nation = nations.find(n => n.id === nationId)
      setMessage(`âœ… Lealdade jurada Ã  ${nation?.name || nationId}!`)

      setTimeout(() => {
        window.location.href = '/'
      }, 1500)
    } catch {
      setMessage('Erro ao processar solicitaÃ§Ã£o')
    } finally {
      setLoading(false)
    }
  }

  if (!playerId) {
    return (
      <div className="min-h-screen bg-void-slate text-white p-6 flex flex-col items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-black text-arcane-gold font-cinzel mb-4">âš ï¸ Erro</h1>
          <p className="text-slate-400">Abrindo no Telegram WebApp...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-void-slate text-white pb-24">
      <div className="border-b border-arcane-gold/20 px-4 py-6">
        <h1 className="text-3xl font-black font-cinzel text-arcane-gold uppercase tracking-tighter mb-2">
          Jure Lealdade
        </h1>
        <p className="text-slate-400 text-sm">
          {currentNationId
            ? `Naï¿½ï¿½o atual: ${nations.find(n => n.id === currentNationId)?.name || currentNationId}`
            : 'Escolha sua naÃ§Ã£o para continuar a jornada'}
        </p>
      </div>

      <div className="px-4 py-6 space-y-3">
        {nations.map(nation => (
          <button
            key={nation.id}
            onClick={() => handleSelectNation(nation.id)}
            disabled={loading}
            className={cn(
              'w-full p-4 rounded-lg border-2 transition-all text-left flex items-center gap-4',
              'hover:border-arcane-gold/50 disabled:opacity-50 disabled:cursor-not-allowed',
              selectedNation === nation.id
                ? 'border-arcane-gold bg-arcane-gold/10 shadow-lg shadow-arcane-gold/30'
                : 'border-slate-700 bg-slate-900 hover:bg-slate-800'
            )}
          >
            <NationCrest nationCode={nation.code} size={64} />
            <div className="flex-1">
              <h3 className="text-lg font-bold">{nation.name}</h3>
              {nation.description && (
                <p className="text-sm text-slate-300 mt-1">{nation.description}</p>
              )}
            </div>
            {selectedNation === nation.id && (
              <span className="text-arcane-gold text-2xl">âœ“</span>
            )}
          </button>
        ))}
      </div>

      {message && (
        <div className={cn(
          'px-4 py-2 text-center text-sm font-bold',
          message.includes('âœ…') ? 'text-emerald-400' : 'text-red-400'
        )}>
          {message}
        </div>
      )}

      {loading && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-slate-900 border border-arcane-gold p-6 rounded-lg text-center">
            <p className="text-arcane-gold font-bold mb-2">âš™ï¸ Processando...</p>
            <p className="text-slate-400 text-sm">Jurando lealdade Ã  naÃ§Ã£o</p>
          </div>
        </div>
      )}
    </div>
  )
}
