import type { Item } from './items-system'

export function calculatePower(
  level: number,
  baseStats: { attack: number; defense: number; hp: number },
  equippedItems: (Item | null)[],
  setBonusPercent: number = 0,
  isVip: boolean = false,
  classBonuses?: { attack: number; defense: number; hp: number }
): number {
  let totalAtk = baseStats.attack || 0
  let totalDef = baseStats.defense || 0
  let totalHp = baseStats.hp || 0

  if (classBonuses) {
    totalAtk += classBonuses.attack
    totalDef += classBonuses.defense
    totalHp += classBonuses.hp
  }

  for (const item of equippedItems) {
    if (!item) continue
    totalAtk += item.attack_bonus
    totalDef += item.defense_bonus
    totalHp += item.hp_bonus
  }

  if (setBonusPercent > 0) {
    const bonusMultiplier = 1 + setBonusPercent / 100
    totalAtk = Math.floor(totalAtk * bonusMultiplier)
    totalDef = Math.floor(totalDef * bonusMultiplier)
    totalHp = Math.floor(totalHp * bonusMultiplier)
  }

  if (isVip) {
    totalAtk = Math.floor(totalAtk * 1.3)
    totalDef = Math.floor(totalDef * 1.3)
    totalHp = Math.floor(totalHp * 1.3)
  }

  return totalAtk + totalDef + Math.floor(totalHp / 10)
}

export function calculateMaxHp(
  baseHp: number,
  equippedItems: (Item | null)[],
  setBonusPercent: number = 0,
  isVip: boolean = false,
  classHpBonus: number = 0
): number {
  let totalHp = baseHp + classHpBonus

  for (const item of equippedItems) {
    if (!item) continue
    totalHp += item.hp_bonus
  }

  if (setBonusPercent > 0) {
    totalHp = Math.floor(totalHp * (1 + setBonusPercent / 100))
  }

  if (isVip) {
    totalHp = Math.floor(totalHp * 1.3)
  }

  return totalHp
}
