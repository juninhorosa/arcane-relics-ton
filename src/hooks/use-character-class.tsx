// @ts-nocheck - tables not yet migrated
import { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'
import type { CharacterClass, CharacterClassCode } from '../lib/character-classes'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)

/**
 * Hook para gerenciar a classe do jogador
 */
export function usePlayerClass(playerId?: string) {
  const [playerClass, setPlayerClass] = useState<CharacterClass | null>(null)
  const [classes, setClasses] = useState<CharacterClass[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  // Carregar classes disponíveis
  useEffect(() => {
    const loadClasses = async () => {
      try {
        const { data, error: err } = await supabase
          .from('character_classes')
          .select('*')
          .order('code', { ascending: true })

        if (err) throw err
        setClasses(data || [])
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar classes')
      }
    }

    loadClasses()
  }, [])

  // Carregar classe do jogador
  useEffect(() => {
    if (!playerId) return

    const loadPlayerClass = async () => {
      try {
        setLoading(true)
        const { data, error: err } = await supabase
          .from('players')
          .select('class_id, character_classes(*)')
          .eq('id', playerId)
          .single()

        if (err) throw err

        if (data?.character_classes) {
          setPlayerClass(data.character_classes as CharacterClass)
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar classe')
      } finally {
        setLoading(false)
      }
    }

    loadPlayerClass()
  }, [playerId])

  // Atualizar classe do jogador
  const updatePlayerClass = async (classCode: CharacterClassCode) => {
    if (!playerId) {
      setError('ID do jogador não fornecido')
      return false
    }

    try {
      setLoading(true)

      // Encontrar o ID da classe
      const targetClass = classes.find(c => c.code === classCode)
      if (!targetClass) {
        setError('Classe não encontrada')
        return false
      }

      // Atualizar jogador com a classe
      const { error: err } = await supabase
        .from('players')
        .update({ class_id: targetClass.id })
        .eq('id', playerId)

      if (err) throw err

      setPlayerClass(targetClass)
      setError(null)
      return true
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : 'Erro ao atualizar classe'
      setError(errorMsg)
      return false
    } finally {
      setLoading(false)
    }
  }

  return {
    playerClass,
    classes,
    loading,
    error,
    updatePlayerClass
  }
}

/**
 * Hook para carregar todas as classes disponíveis
 */
export function useCharacterClasses() {
  const [classes, setClasses] = useState<CharacterClass[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const loadClasses = async () => {
      try {
        const { data, error: err } = await supabase
          .from('character_classes')
          .select('*')
          .order('code', { ascending: true })

        if (err) throw err
        setClasses(data || [])
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar classes')
      } finally {
        setLoading(false)
      }
    }

    loadClasses()
  }, [])

  return { classes, loading, error }
}
