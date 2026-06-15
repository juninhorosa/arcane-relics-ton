// @ts-nocheck - pending schema migration
import { createFileRoute } from '@tanstack/react-router'
import { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'
import { ClassSelector } from '../components/ClassSelector'
import { type CharacterClassCode } from '../lib/character-classes'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/select-class')({
  component: SelectClass,
})

function SelectClass() {
  const [playerId, setPlayerId] = useState<string | null>(null)
  const [selectedClass, setSelectedClass] = useState<CharacterClassCode | null>(null)
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [currentClass, setCurrentClass] = useState<CharacterClassCode | null>(null)

  useEffect(() => {
    const loadPlayer = async () => {
      const tgUser = (window as any).Telegram?.WebApp?.initDataUnsafe?.user
      if (!tgUser) return

      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(id, class_id, character_classes(code))')
        .eq('telegram_id', tgUser.id)
        .single()

      const player = (profile as any)?.players?.[0]
      if (player) {
        setPlayerId(player.id)
        if (player.character_classes?.code) {
          setCurrentClass(player.character_classes.code)
          setSelectedClass(player.character_classes.code)
        }
      }
    }

    loadPlayer()
  }, [])

  const handleSelectClass = async (classCode: CharacterClassCode) => {
    if (!playerId) {
      setMessage('Erro: Jogador nÃ£o encontrado')
      return
    }

    setLoading(true)
    setMessage('')

    try {
      // Buscar ID da classe
      const { data: classData, error: classErr } = await supabase
        .from('character_classes')
        .select('id')
        .eq('code', classCode)
        .single()

      if (classErr || !classData) {
        setMessage('Erro: Classe nÃ£o encontrada')
        return
      }

      // Atualizar jogador com a classe
      const { error: updateErr } = await supabase
        .from('players')
        .update({ class_id: classData.id })
        .eq('id', playerId)

      if (updateErr) {
        setMessage('Erro ao atualizar classe')
        return
      }

      setCurrentClass(classCode)
      setSelectedClass(classCode)
      setMessage(`âœ… Classe ${classCode} selecionada com sucesso!`)

      // Redirecionar apÃ³s sucesso
      setTimeout(() => {
        window.location.href = '/'
      }, 1500)
    } catch (error) {
      setMessage('Erro ao processar solicitaÃ§Ã£o')
      console.error(error)
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
      {/* Header */}
      <div className="border-b border-arcane-gold/20 px-4 py-6">
        <h1 className="text-3xl font-black font-cinzel text-arcane-gold uppercase tracking-tighter mb-2">
          Escolha Sua Classe
        </h1>
        <p className="text-slate-400 text-sm">
          {currentClass 
            ? `Classe atual: ${currentClass.toUpperCase()}` 
            : 'Selecione o seu arquÃ©tipo de herÃ³i'}
        </p>
      </div>

      {/* Class Selector */}
      <div className="px-4 py-6">
        <ClassSelector 
          selected={selectedClass}
          onSelect={handleSelectClass}
          disabled={loading}
          showDescription={true}
        />
      </div>

      {/* Message */}
      {message && (
        <div className={`px-4 py-2 text-center text-sm font-bold ${
          message.includes('âœ…') ? 'text-emerald-400' : 'text-red-400'
        }`}>
          {message}
        </div>
      )}

      {/* Loading State */}
      {loading && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-slate-900 border border-arcane-gold p-6 rounded-lg text-center">
            <p className="text-arcane-gold font-bold mb-2">âš™ï¸ Processando...</p>
            <p className="text-slate-400 text-sm">Selecionando sua classe</p>
          </div>
        </div>
      )}

      {/* Info Box */}
      <div className="px-4 py-6">
        <div className="bg-slate-900 border border-arcane-gold/20 rounded-lg p-4">
          <h3 className="font-bold text-arcane-gold mb-2">ðŸ’¡ Dica</h3>
          <p className="text-sm text-slate-300">
            Cada classe tem atributos Ãºnicos e habilidades especiais. Escolha aquela que melhor combina com seu estilo de jogo!
          </p>
          <p className="text-xs text-slate-500 mt-2 italic">
            VocÃª pode mudar de classe mais tarde visitando o Templo de TransformaÃ§Ã£o
          </p>
        </div>
      </div>
    </div>
  )
}
