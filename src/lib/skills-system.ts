/**
 * Character Skills System
 * Define todos os tipos, interfaces e utilitários para o sistema de skills
 */

export type SkillType = 'active' | 'passive' | 'buff' | 'debuff'
export type SkillRarity = 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'

export interface Skill {
  id: string
  code: string
  name: string
  description: string
  emoji: string
  class_id: string
  skill_type: SkillType
  rarity: SkillRarity
  
  required_level: number
  required_skill_points: number
  
  cooldown_seconds: number
  energy_cost: number
  
  attack_multiplier: number
  defense_multiplier: number
  hp_multiplier: number
  
  attack_bonus: number
  defense_bonus: number
  hp_bonus: number
  crit_chance_bonus: number
  
  special_effect: string | null
  can_miss: boolean
  can_crit: boolean
  
  max_level: number
  scaling_per_level: number
  
  created_at: string
  updated_at: string
}

export interface PlayerSkill {
  id: string
  player_id: string
  skill_id: string
  skill_level: number
  learned_at: string
  last_used_at: string | null
  times_used: number
}

export interface SkillWithDetails extends Skill {
  character_classes?: {
    name: string
    code: string
  }
}

export interface PlayerSkillWithDetails extends PlayerSkill {
  skills?: Skill
}

/**
 * Rarity colors for UI
 */
export const RARITY_COLORS: Record<SkillRarity, string> = {
  common: 'text-slate-400',
  uncommon: 'text-green-400',
  rare: 'text-blue-400',
  epic: 'text-purple-400',
  legendary: 'text-yellow-500'
}

export const RARITY_BG: Record<SkillRarity, string> = {
  common: 'bg-slate-900',
  uncommon: 'bg-green-900/20',
  rare: 'bg-blue-900/20',
  epic: 'bg-purple-900/20',
  legendary: 'bg-yellow-900/20'
}

/**
 * Rarity level for sorting
 */
export function getRarityLevel(rarity: SkillRarity): number {
  const levels: Record<SkillRarity, number> = {
    common: 1,
    uncommon: 2,
    rare: 3,
    epic: 4,
    legendary: 5
  }
  return levels[rarity]
}

/**
 * Get stat name in Portuguese
 */
export function getStatName(stat: 'attack' | 'defense' | 'hp' | 'crit'): string {
  const names: Record<string, string> = {
    attack: 'Ataque',
    defense: 'Defesa',
    hp: 'Vida',
    crit: 'Crítico'
  }
  return names[stat]
}

/**
 * Calculate actual damage/effect based on skill level and scaling
 */
export function calculateSkillValue(
  baseValue: number,
  skillLevel: number,
  scalingPerLevel: number
): number {
  return baseValue * (1 + (skillLevel - 1) * scalingPerLevel)
}

/**
 * Calculate cooldown based on skill level (decreases with level)
 */
export function calculateCooldown(
  baseCooldown: number,
  skillLevel: number
): number {
  return Math.max(baseCooldown * (1 - (skillLevel - 1) * 0.1), 0)
}

/**
 * Format skill effect string with values
 */
export function formatSkillEffect(
  skill: Skill,
  playerLevel: number = 1,
  skillLevel: number = 1
): string {
  let effect = skill.special_effect || ''

  // Replace placeholders with calculated values
  if (skill.attack_multiplier > 0) {
    const dmg = Math.round(skill.attack_multiplier * 100 * (1 + (skillLevel - 1) * skill.scaling_per_level))
    effect = effect.replace('{damage}', `${dmg}%`)
  }

  if (skill.defense_multiplier > 0) {
    const def = Math.round(skill.defense_multiplier * 100 * (1 + (skillLevel - 1) * skill.scaling_per_level))
    effect = effect.replace('{defense}', `${def}%`)
  }

  if (skill.hp_multiplier > 0) {
    const hp = Math.round(skill.hp_multiplier * 100 * (1 + (skillLevel - 1) * skill.scaling_per_level))
    effect = effect.replace('{healing}', `${hp}%`)
  }

  return effect
}

/**
 * Check if player can learn skill
 */
export function canLearnSkill(
  skill: Skill,
  playerLevel: number,
  skillPoints: number,
  alreadyLearned: boolean = false
): { can: boolean; reason?: string } {
  if (alreadyLearned && playerLevel >= skill.required_level) {
    return { can: true }
  }

  if (playerLevel < skill.required_level) {
    return { can: false, reason: `Nível insuficiente (${playerLevel}/${skill.required_level})` }
  }

  if (skillPoints < skill.required_skill_points) {
    return { can: false, reason: `Pontos insuficientes (${skillPoints}/${skill.required_skill_points})` }
  }

  return { can: true }
}

/**
 * Get skill tree path (prereq skills)
 */
export function getSkillTreePath(skillCode: string): string[] {
  // Define skill tree progressions
  const skillPaths: Record<string, string[]> = {
    // Paladino
    PALADIN_CONVICTION: [],
    PALADIN_HOLY_STRIKE: ['PALADIN_CONVICTION'],
    PALADIN_DIVINE_SHIELD: ['PALADIN_HOLY_STRIKE'],
    PALADIN_WRATH: ['PALADIN_DIVINE_SHIELD'],
    PALADIN_REDEMPTION: ['PALADIN_WRATH'],

    // Guerreiro
    WARRIOR_BLOODLUST: [],
    WARRIOR_CLEAVE: ['WARRIOR_BLOODLUST'],
    WARRIOR_EXECUTE: ['WARRIOR_CLEAVE'],
    WARRIOR_SHIELDBREAKER: ['WARRIOR_EXECUTE'],
    WARRIOR_ENDURANCE: ['WARRIOR_SHIELDBREAKER'],

    // Mago
    MAGE_ARCANE_MASTERY: [],
    MAGE_FIREBALL: ['MAGE_ARCANE_MASTERY'],
    MAGE_MANA_SHIELD: ['MAGE_FIREBALL'],
    MAGE_ICE_STORM: ['MAGE_MANA_SHIELD'],
    MAGE_TIMERIFT: ['MAGE_ICE_STORM'],

    // Arqueiro
    ARCHER_CRITICAL_MASTERY: [],
    ARCHER_PIERCING_SHOT: ['ARCHER_CRITICAL_MASTERY'],
    ARCHER_MULTISHOT: ['ARCHER_PIERCING_SHOT'],
    ARCHER_EVASION: ['ARCHER_MULTISHOT'],
    ARCHER_DEADSHOT: ['ARCHER_EVASION'],

    // Clérigo
    CLERIC_HOLY_AURA: [],
    CLERIC_HEAL: ['CLERIC_HOLY_AURA'],
    CLERIC_PROTECTION: ['CLERIC_HEAL'],
    CLERIC_SMITE: ['CLERIC_PROTECTION'],
    CLERIC_RESURRECT: ['CLERIC_SMITE']
  }

  return skillPaths[skillCode] || []
}

/**
 * Get skill stats display
 */
export function getSkillStats(skill: Skill): Array<{ label: string; value: string; icon: string }> {
  const stats: Array<{ label: string; value: string; icon: string }> = []

  if (skill.required_level > 1) {
    stats.push({ label: 'Nível Necessário', value: `${skill.required_level}`, icon: '📊' })
  }

  if (skill.cooldown_seconds > 0) {
    stats.push({ label: 'Cooldown', value: `${skill.cooldown_seconds}s`, icon: '⏱️' })
  }

  if (skill.energy_cost > 0) {
    stats.push({ label: 'Custo', value: `${skill.energy_cost} Energia`, icon: '⚡' })
  }

  if (skill.attack_multiplier > 0) {
    stats.push({ label: 'Dano', value: `${Math.round(skill.attack_multiplier * 100)}% ATK`, icon: '⚔️' })
  }

  if (skill.defense_multiplier > 0) {
    stats.push({ label: 'Defesa', value: `${Math.round(skill.defense_multiplier * 100)}% DEF`, icon: '🛡️' })
  }

  if (skill.hp_multiplier > 0) {
    stats.push({ label: 'Cura', value: `${Math.round(skill.hp_multiplier * 100)}% HP`, icon: '❤️' })
  }

  if (skill.attack_bonus > 0) {
    stats.push({ label: 'Bônus ATK', value: `+${skill.attack_bonus}`, icon: '📈' })
  }

  if (skill.defense_bonus > 0) {
    stats.push({ label: 'Bônus DEF', value: `+${skill.defense_bonus}`, icon: '🛡️' })
  }

  if (skill.hp_bonus > 0) {
    stats.push({ label: 'Bônus HP', value: `+${skill.hp_bonus}`, icon: '❤️' })
  }

  if (skill.crit_chance_bonus > 0) {
    stats.push({ label: 'Crítico', value: `+${Math.round(skill.crit_chance_bonus)}%`, icon: '💥' })
  }

  return stats
}
