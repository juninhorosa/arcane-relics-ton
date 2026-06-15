// @ts-nocheck - tables not yet migrated
import { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'
import type { Skill, PlayerSkill } from '../lib/skills-system'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)

/**
 * Hook para carregar todas as skills de uma classe
 */
export function useClassSkills(classCode?: string) {
  const [skills, setSkills] = useState<Skill[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!classCode) {
      setSkills([])
      setLoading(false)
      return
    }

    const loadSkills = async () => {
      try {
        setLoading(true)
        const { data, error: err } = await supabase
          .from('skills')
          .select('*')
          .eq('character_classes.code', classCode)
          .order('required_level', { ascending: true })

        if (err) throw err
        setSkills(data || [])
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar skills')
      } finally {
        setLoading(false)
      }
    }

    loadSkills()
  }, [classCode])

  return { skills, loading, error }
}

/**
 * Hook para gerenciar skills do jogador
 */
export function usePlayerSkills(playerId?: string) {
  const [playerSkills, setPlayerSkills] = useState<Map<string, number>>(new Map())
  const [allSkills, setAllSkills] = useState<Skill[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  // Carregar skills aprendidas do jogador
  useEffect(() => {
    if (!playerId) return

    const loadPlayerSkills = async () => {
      try {
        setLoading(true)

        const { data, error: err } = await supabase
          .from('player_skills')
          .select('*, skills(*)')
          .eq('player_id', playerId)

        if (err) throw err

        // Criar mapa de skills aprendidas
        const skillsMap = new Map<string, number>()
        data?.forEach((ps: any) => {
          skillsMap.set(ps.skills?.code, ps.skill_level)
        })

        setPlayerSkills(skillsMap)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar skills do player')
      } finally {
        setLoading(false)
      }
    }

    loadPlayerSkills()
  }, [playerId])

  // Aprender nova skill
  const learnSkill = async (skillId: string) => {
    if (!playerId) return false

    try {
      const { data, error: err } = await supabase
        .from('player_skills')
        .insert({
          player_id: playerId,
          skill_id: skillId,
          skill_level: 1
        })
        .select()

      if (err) throw err

      // Atualizar mapa local
      const skillCode = allSkills.find(s => s.id === skillId)?.code
      if (skillCode) {
        const newMap = new Map(playerSkills)
        newMap.set(skillCode, 1)
        setPlayerSkills(newMap)
      }

      return true
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Erro ao aprender skill')
      return false
    }
  }

  // Evoluir skill
  const upgradeSkill = async (skillCode: string) => {
    if (!playerId) return false

    try {
      const skillId = allSkills.find(s => s.code === skillCode)?.id
      if (!skillId) return false

      const currentLevel = playerSkills.get(skillCode) || 0

      const { error: err } = await supabase
        .from('player_skills')
        .update({ skill_level: currentLevel + 1 })
        .eq('player_id', playerId)
        .eq('skill_id', skillId)

      if (err) throw err

      // Atualizar mapa local
      const newMap = new Map(playerSkills)
      newMap.set(skillCode, currentLevel + 1)
      setPlayerSkills(newMap)

      return true
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Erro ao evoluir skill')
      return false
    }
  }

  // Usar skill em combate (incrementa counter)
  const useSkill = async (skillCode: string) => {
    if (!playerId) return false

    try {
      const skillId = allSkills.find(s => s.code === skillCode)?.id
      if (!skillId) return false

      const { data: ps } = await supabase
        .from('player_skills')
        .select('times_used')
        .eq('player_id', playerId)
        .eq('skill_id', skillId)
        .single()

      const timesUsed = (ps?.times_used || 0) + 1

      const { error: err } = await supabase
        .from('player_skills')
        .update({
          times_used: timesUsed,
          last_used_at: new Date().toISOString()
        })
        .eq('player_id', playerId)
        .eq('skill_id', skillId)

      if (err) throw err

      return true
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Erro ao usar skill')
      return false
    }
  }

  return {
    playerSkills,
    allSkills,
    loading,
    error,
    learnSkill,
    upgradeSkill,
    useSkill
  }
}

/**
 * Hook para carregar skills disponíveis para aprender
 */
export function useAvailableSkills(playerId?: string, classCode?: string, playerLevel?: number) {
  const [availableSkills, setAvailableSkills] = useState<Skill[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!classCode || !playerLevel) return

    const loadAvailableSkills = async () => {
      try {
        setLoading(true)

        // Buscar todas as skills da classe
        const { data: allSkills, error: err1 } = await supabase
          .from('skills')
          .select('*')
          .eq('character_classes.code', classCode)
          .lte('required_level', playerLevel)
          .order('required_level', { ascending: true })

        if (err1) throw err1

        // Se tem playerId, filtrar as já aprendidas
        if (playerId) {
          const { data: learnedSkills, error: err2 } = await supabase
            .from('player_skills')
            .select('skill_id')
            .eq('player_id', playerId)

          if (err2) throw err2

          const learnedIds = new Set(learnedSkills?.map(ps => ps.skill_id))
          setAvailableSkills((allSkills || []).filter(s => !learnedIds.has(s.id)))
        } else {
          setAvailableSkills(allSkills || [])
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar skills disponíveis')
      } finally {
        setLoading(false)
      }
    }

    loadAvailableSkills()
  }, [playerId, classCode, playerLevel])

  return { availableSkills, loading, error }
}

/**
 * Hook para estatísticas de skills do jogador
 */
export function usePlayerSkillStats(playerId?: string) {
  const [stats, setStats] = useState({
    totalSkills: 0,
    skillsLearned: 0,
    averageLevel: 0,
    skillPointsUsed: 0
  })
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!playerId) return

    const loadStats = async () => {
      try {
        setLoading(true)

        const { data: playerSkills, error: err1 } = await supabase
          .from('player_skills')
          .select('skill_level')
          .eq('player_id', playerId)

        if (err1) throw err1

        const { data: player, error: err2 } = await supabase
          .from('players')
          .select('skill_points_used')
          .eq('id', playerId)
          .single()

        if (err2) throw err2

        const skillCount = playerSkills?.length || 0
        const totalLevel = playerSkills?.reduce((sum: number, ps: any) => sum + (ps.skill_level || 0), 0) || 0

        setStats({
          totalSkills: skillCount,
          skillsLearned: skillCount,
          averageLevel: skillCount > 0 ? Math.round(totalLevel / skillCount) : 0,
          skillPointsUsed: player?.skill_points_used || 0
        })
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar estatísticas')
      } finally {
        setLoading(false)
      }
    }

    loadStats()
  }, [playerId])

  return { stats, loading, error }
}
