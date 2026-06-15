import { cn } from '../lib/utils'
import { RARITY_COLORS, RARITY_BG, getSkillStats, formatSkillEffect, type Skill, type SkillRarity } from '../lib/skills-system'

interface SkillCardProps {
  skill: Skill
  skillLevel?: number
  isLearned?: boolean
  canLearn?: boolean
  onLearn?: () => void
  onUpgrade?: () => void
  compact?: boolean
  playerLevel?: number
}

export function SkillCard({
  skill,
  skillLevel = 0,
  isLearned = false,
  canLearn = false,
  onLearn,
  onUpgrade,
  compact = false,
  playerLevel = 1
}: SkillCardProps) {
  const stats = getSkillStats(skill)
  const rarityColor = RARITY_COLORS[skill.rarity]
  const rarityBg = RARITY_BG[skill.rarity]

  if (compact) {
    return (
      <div className={cn(
        'p-2 rounded border-2 flex items-center gap-2',
        isLearned 
          ? `border-arcane-gold ${rarityBg}`
          : 'border-slate-700 bg-slate-900/50'
      )}>
        <span className="text-2xl">{skill.emoji}</span>
        <div className="flex-1 min-w-0">
          <p className="font-bold text-sm truncate">{skill.name}</p>
          <p className="text-xs text-slate-400">Nível {skill.required_level}</p>
        </div>
        {isLearned && (
          <span className="text-xs font-bold bg-arcane-gold/20 px-2 py-1 rounded">
            Lv {skillLevel}
          </span>
        )}
      </div>
    )
  }

  return (
    <div className={cn(
      'rounded-lg border-2 p-4 transition-all',
      isLearned 
        ? `border-arcane-gold ${rarityBg} shadow-lg shadow-arcane-gold/20`
        : 'border-slate-700 bg-slate-900 hover:border-slate-600'
    )}>
      {/* Header */}
      <div className="flex items-start justify-between mb-2">
        <div className="flex items-center gap-2">
          <span className="text-3xl">{skill.emoji}</span>
          <div>
            <h3 className="font-bold text-lg">{skill.name}</h3>
            <p className={cn('text-sm font-bold', rarityColor)}>
              {skill.rarity.toUpperCase()}
            </p>
          </div>
        </div>
        {isLearned && (
          <div className="text-center">
            <p className="text-2xl font-black text-arcane-gold">{skillLevel}</p>
            <p className="text-xs text-slate-400">/ {skill.max_level}</p>
          </div>
        )}
      </div>

      {/* Description */}
      <p className="text-sm text-slate-300 mb-3">{skill.description}</p>

      {/* Special Effect */}
      {skill.special_effect && (
        <p className="text-xs text-amber-400 italic mb-3 border-l-2 border-amber-400 pl-2">
          ✨ {formatSkillEffect(skill, playerLevel, skillLevel)}
        </p>
      )}

      {/* Stats Grid */}
      {stats.length > 0 && (
        <div className="grid grid-cols-2 gap-2 mb-3">
          {stats.map((stat, idx) => (
            <div key={idx} className="bg-slate-800/50 p-2 rounded text-xs">
              <p className="text-slate-400">{stat.icon} {stat.label}</p>
              <p className="font-bold text-arcane-gold">{stat.value}</p>
            </div>
          ))}
        </div>
      )}

      {/* Requirements */}
      <div className="text-xs text-slate-400 mb-3 space-y-1">
        {skill.required_level > 1 && (
          <p>
            Nível necessário: <span className={playerLevel >= skill.required_level ? 'text-emerald-400' : 'text-red-400'}>
              {playerLevel}/{skill.required_level}
            </span>
          </p>
        )}
        {skill.required_skill_points > 0 && (
          <p>Pontos de skill necessários: {skill.required_skill_points}</p>
        )}
      </div>

      {/* Actions */}
      {!isLearned && canLearn && (
        <button
          onClick={onLearn}
          className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2 rounded transition-colors"
        >
          Aprender Skill
        </button>
      )}

      {isLearned && skillLevel < skill.max_level && (
        <button
          onClick={onUpgrade}
          className="w-full bg-arcane-gold/20 hover:bg-arcane-gold/30 text-arcane-gold font-bold py-2 rounded border border-arcane-gold/50 transition-colors"
        >
          Evoluir para Nível {skillLevel + 1}
        </button>
      )}

      {isLearned && skillLevel >= skill.max_level && (
        <p className="w-full text-center text-arcane-gold font-bold py-2">
          ✨ Máximo nível atingido
        </p>
      )}
    </div>
  )
}

interface SkillGridProps {
  skills: Skill[]
  learnedSkills?: Map<string, number>
  playerLevel?: number
  onLearn?: (skillCode: string) => void
  onUpgrade?: (skillCode: string) => void
  compact?: boolean
}

export function SkillGrid({
  skills,
  learnedSkills = new Map(),
  playerLevel = 1,
  onLearn,
  onUpgrade,
  compact = false
}: SkillGridProps) {
  return (
    <div className={cn(
      'grid gap-3',
      compact ? 'grid-cols-2' : 'grid-cols-1'
    )}>
      {skills.map((skill) => {
        const skillLevel = learnedSkills.get(skill.code) || 0
        const isLearned = skillLevel > 0

        return (
          <SkillCard
            key={skill.code}
            skill={skill}
            skillLevel={skillLevel}
            isLearned={isLearned}
            canLearn={playerLevel >= skill.required_level && !isLearned}
            onLearn={() => onLearn?.(skill.code)}
            onUpgrade={() => onUpgrade?.(skill.code)}
            compact={compact}
            playerLevel={playerLevel}
          />
        )
      })}
    </div>
  )
}

interface SkillTreeProps {
  skills: Skill[]
  learnedSkills?: Map<string, number>
  playerLevel?: number
  skillPoints?: number
}

export function SkillTree({
  skills,
  learnedSkills = new Map(),
  playerLevel = 1,
  skillPoints = 0
}: SkillTreeProps) {
  // Group skills by tier/level
  const skillsByLevel: Record<number, Skill[]> = {}

  skills.forEach(skill => {
    const level = skill.required_level
    if (!skillsByLevel[level]) skillsByLevel[level] = []
    skillsByLevel[level].push(skill)
  })

  return (
    <div className="space-y-6">
      {Object.entries(skillsByLevel).map(([level, levelSkills]) => (
        <div key={level}>
          <h3 className="font-bold text-arcane-gold mb-3 flex items-center gap-2">
            <span className="text-2xl">📊</span>
            Level {level}
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pl-4 border-l-2 border-arcane-gold/30">
            {levelSkills.map((skill) => {
              const skillLevel = learnedSkills.get(skill.code) || 0

              return (
                <div
                  key={skill.code}
                  className={cn(
                    'p-3 rounded border-l-4 bg-slate-900/50',
                    skillLevel > 0
                      ? 'border-l-arcane-gold bg-arcane-gold/10'
                      : 'border-l-slate-700'
                  )}
                >
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <span className="text-2xl">{skill.emoji}</span>
                      <div>
                        <p className="font-bold">{skill.name}</p>
                        <p className="text-xs text-slate-400">{skill.rarity}</p>
                      </div>
                    </div>
                    {skillLevel > 0 && (
                      <span className="text-arcane-gold font-bold">
                        Lv {skillLevel}/{skill.max_level}
                      </span>
                    )}
                  </div>
                  <p className="text-xs text-slate-300 mb-2">{skill.description}</p>
                  {skill.special_effect && (
                    <p className="text-xs text-amber-400">✨ {skill.special_effect}</p>
                  )}
                </div>
              )
            })}
          </div>
        </div>
      ))}
    </div>
  )
}

interface SkillDisplayProps {
  skill: Skill | null
  skillLevel?: number
}

export function SkillDisplay({ skill, skillLevel = 1 }: SkillDisplayProps) {
  if (!skill) {
    return <p className="text-slate-400">Nenhuma skill selecionada</p>
  }

  const stats = getSkillStats(skill)

  return (
    <div className="bg-slate-900 border border-slate-700 rounded-lg p-4">
      <div className="flex items-center gap-3 mb-3">
        <span className="text-4xl">{skill.emoji}</span>
        <div>
          <h2 className="font-bold text-xl">{skill.name}</h2>
          <p className={cn('text-sm font-bold', RARITY_COLORS[skill.rarity])}>
            {skill.rarity.toUpperCase()} • Nível {skillLevel}/{skill.max_level}
          </p>
        </div>
      </div>

      <p className="text-sm text-slate-300 mb-3">{skill.description}</p>

      {skill.special_effect && (
        <p className="text-sm text-amber-400 italic mb-3 border-l-2 border-amber-400 pl-2">
          {skill.special_effect}
        </p>
      )}

      <div className="grid grid-cols-2 gap-2">
        {stats.map((stat, idx) => (
          <div key={idx} className="bg-slate-800 p-2 rounded">
            <p className="text-xs text-slate-400">{stat.label}</p>
            <p className="font-bold text-arcane-gold">{stat.value}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
