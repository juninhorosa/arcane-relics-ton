// @ts-nocheck - pending schema migration
import { createFileRoute } from '@tanstack/react-router'
import { useEffect, useState } from 'react'
import { createClient } from '@supabase/supabase-js'
import { SkillTree, SkillCard, SkillDisplay } from '../components/SkillCard'
import { usePlayerSkills, useAvailableSkills, usePlayerSkillStats } from '../hooks/use-skills'
import type { Skill } from '../lib/skills-system'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/skills')({
  component: SkillsPage,
})

function SkillsPage() {
  const [player, setPlayer] = useState<any>(null)
  const [classSkills, setClassSkills] = useState<Skill[]>([])
  const [selectedSkill, setSelectedSkill] = useState<Skill | null>(null)
  const [tab, setTab] = useState<'tree' | 'available' | 'learned'>('tree')
  const [loading, setLoading] = useState(true)

  const { playerSkills, allSkills, learnSkill, upgradeSkill } = usePlayerSkills(player?.id)
  const { availableSkills } = useAvailableSkills(player?.id, player?.character_classes?.code, player?.level)
  const { stats } = usePlayerSkillStats(player?.id)

  // Carregar jogador e suas skills
  useEffect(() => {
    const loadPlayer = async () => {
      const tgUser = (window as any).Telegram?.WebApp?.initDataUnsafe?.user
      if (!tgUser) return

      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(*, character_classes(*))')
        .eq('telegram_id', tgUser.id)
        .single()

      const playerData = (profile as any)?.players?.[0]
      if (playerData) {
        setPlayer(playerData)

        // Carregar skills da classe
        const { data: skills } = await supabase
          .from('skills')
          .select('*')
          .eq('class_id', playerData.character_classes?.id)
          .order('required_level', { ascending: true })

        setClassSkills(skills || [])
      }

      setLoading(false)
    }

    loadPlayer()
  }, [])

  if (loading) {
    return (
      <div className="min-h-screen bg-void-slate text-white p-6 flex items-center justify-center">
        <p className="text-arcane-gold">Carregando skills...</p>
      </div>
    )
  }

  if (!player) {
    return (
      <div className="min-h-screen bg-void-slate text-white p-6 flex items-center justify-center">
        <p className="text-red-400">Erro ao carregar dados do jogador</p>
      </div>
    )
  }

  const learnedSkills = classSkills.filter(s => playerSkills.has(s.code))
  const learnableSkills = classSkills.filter(
    s => !playerSkills.has(s.code) && s.required_level <= player.level
  )

  return (
    <div className="min-h-screen bg-void-slate text-white pb-24">
      {/* Header */}
      <div className="border-b border-arcane-gold/20 px-4 py-6 sticky top-0 z-10 bg-void-slate">
        <h1 className="text-3xl font-black font-cinzel text-arcane-gold uppercase tracking-tighter mb-2">
          ðŸ—¡ï¸ Skill Tree
        </h1>
        <p className="text-slate-400 text-sm mb-4">
          {player.character_classes?.name} â€¢ NÃ­vel {player.level}
        </p>

        {/* Stats Bar */}
        <div className="grid grid-cols-4 gap-2 text-xs">
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-slate-400">Skills Aprendidas</p>
            <p className="font-bold text-arcane-gold">{stats.skillsLearned}</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-slate-400">NÃ­vel MÃ©dio</p>
            <p className="font-bold text-arcane-gold">{stats.averageLevel}</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-slate-400">Pontos Usados</p>
            <p className="font-bold text-arcane-gold">{stats.skillPointsUsed}</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-slate-400">DisponÃ­veis</p>
            <p className="font-bold text-emerald-400">{learnableSkills.length}</p>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 px-4 py-4 border-b border-slate-700 sticky top-24 z-10 bg-void-slate">
        {[
          { id: 'tree', label: 'ðŸŒ³ Ãrvore de Skills' },
          { id: 'learned', label: `âœ¨ Aprendidas (${learnedSkills.length})` },
          { id: 'available', label: `ðŸŽ DisponÃ­veis (${learnableSkills.length})` }
        ].map(t => (
          <button
            key={t.id}
            onClick={() => setTab(t.id as any)}
            className={`px-4 py-2 rounded font-bold text-sm transition-colors ${
              tab === t.id
                ? 'bg-arcane-gold text-void-slate'
                : 'bg-slate-900 text-slate-300 hover:bg-slate-800'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="p-4">
        {tab === 'tree' && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
            <div className="lg:col-span-2">
              <SkillTree
                skills={classSkills}
                learnedSkills={playerSkills}
                playerLevel={player.level}
              />
            </div>

            {/* Selected Skill */}
            {selectedSkill && (
              <div className="sticky top-32">
                <h3 className="font-bold text-arcane-gold mb-3">ðŸ“‹ Detalhes</h3>
                <SkillDisplay
                  skill={selectedSkill}
                  skillLevel={playerSkills.get(selectedSkill.code) || 0}
                />
              </div>
            )}
          </div>
        )}

        {tab === 'learned' && (
          <div>
            <h2 className="text-xl font-bold text-arcane-gold mb-4">âœ¨ Skills Aprendidas</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {learnedSkills.map(skill => (
                <div
                  key={skill.code}
                  onClick={() => setSelectedSkill(skill)}
                  className="cursor-pointer"
                >
                  <SkillCard
                    skill={skill}
                    skillLevel={playerSkills.get(skill.code) || 0}
                    isLearned={true}
                    onUpgrade={() => upgradeSkill(skill.code)}
                    playerLevel={player.level}
                    compact={true}
                  />
                </div>
              ))}
            </div>

            {learnedSkills.length === 0 && (
              <div className="text-center py-8">
                <p className="text-slate-400">VocÃª ainda nÃ£o aprendeu nenhuma skill</p>
                <p className="text-slate-500 text-sm">VÃ¡ para "DisponÃ­veis" para aprender</p>
              </div>
            )}
          </div>
        )}

        {tab === 'available' && (
          <div>
            <h2 className="text-xl font-bold text-arcane-gold mb-4">ðŸŽ Skills DisponÃ­veis</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {learnableSkills.map(skill => (
                <SkillCard
                  key={skill.code}
                  skill={skill}
                  canLearn={true}
                  onLearn={() => {
                    learnSkill(skill.id)
                    setSelectedSkill(skill)
                  }}
                  playerLevel={player.level}
                  compact={true}
                />
              ))}
            </div>

            {learnableSkills.length === 0 && (
              <div className="text-center py-8">
                <p className="text-slate-400">Nenhuma skill disponÃ­vel no seu nÃ­vel</p>
                <p className="text-slate-500 text-sm">Continue evoluindo para desbloquear novas!</p>
              </div>
            )}
          </div>
        )}
      </div>

      {/* Legend */}
      <div className="px-4 py-6 border-t border-slate-700 text-xs text-slate-400 space-y-1">
        <p>ðŸ’« <strong>Passiva:</strong> Sempre ativa em combate</p>
        <p>âš”ï¸ <strong>Ativa:</strong> Pode ser ativada em combate</p>
        <p>ðŸ›¡ï¸ <strong>Buff:</strong> Aumenta stats temporariamente</p>
        <p>ðŸ’¢ <strong>Debuff:</strong> Diminui stats do inimigo</p>
      </div>
    </div>
  )
}
