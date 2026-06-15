export type ItemCategory = 'weapon' | 'helmet' | 'armor' | 'gloves' | 'boots'
export type ItemRarity = 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'

export interface Item {
  id: string
  code: string
  name: string
  emoji: string
  description: string
  category: ItemCategory
  class_id: string
  attack_bonus: number
  defense_bonus: number
  hp_bonus: number
  crit_bonus: number
  dodge_bonus: number
  rarity: ItemRarity
  required_level: number
  slot_weight: number
  set_id: string
  set_bonus_percentage: number
  created_at: string
  updated_at: string
}

export interface PlayerInventoryItem {
  id: string
  player_id: string
  item_id: string
  quantity: number
  is_equipped: boolean
  equipped_slot: ItemCategory | null
  durability: number
  uses_count: number
  created_at: string
  updated_at: string
  items?: Item
}

export interface EquippedItems {
  weapon: (Item & { inventory_id: string }) | null
  helmet: (Item & { inventory_id: string }) | null
  armor: (Item & { inventory_id: string }) | null
  gloves: (Item & { inventory_id: string }) | null
  boots: (Item & { inventory_id: string }) | null
}

export interface SetBonus {
  setId: string
  setName: string
  equippedCount: number
  totalNeeded: number
  bonusPercent: number
  isComplete: boolean
}

export const RARITY_COLORS: Record<ItemRarity, string> = {
  common: 'text-slate-400',
  uncommon: 'text-green-400',
  rare: 'text-blue-400',
  epic: 'text-purple-400',
  legendary: 'text-yellow-500'
}

export const RARITY_BG: Record<ItemRarity, string> = {
  common: 'bg-slate-900',
  uncommon: 'bg-green-900/20',
  rare: 'bg-blue-900/20',
  epic: 'bg-purple-900/20',
  legendary: 'bg-yellow-900/20'
}

export const RARITY_BORDER: Record<ItemRarity, string> = {
  common: 'border-slate-700',
  uncommon: 'border-green-700/50',
  rare: 'border-blue-700/50',
  epic: 'border-purple-700/50',
  legendary: 'border-yellow-700/50'
}

export const CATEGORY_LABELS: Record<ItemCategory, string> = {
  weapon: 'Arma',
  helmet: 'Capacete',
  armor: 'Armadura',
  gloves: 'Luvas',
  boots: 'Botas'
}

export const CATEGORY_ORDER: ItemCategory[] = ['weapon', 'helmet', 'armor', 'gloves', 'boots']

export const SET_NAMES: Record<string, string> = {
  paladin_sanctity_set: 'Conjunto Sagrado',
  warrior_onslaught_set: 'Conjunto da Investida',
  mage_mystique_set: 'Conjunto Místico',
  archer_precision_set: 'Conjunto da Precisão',
  cleric_salvation_set: 'Conjunto da Salvação'
}

export function getRarityLevel(rarity: ItemRarity): number {
  const levels: Record<ItemRarity, number> = {
    common: 1,
    uncommon: 2,
    rare: 3,
    epic: 4,
    legendary: 5
  }
  return levels[rarity]
}

export function calculateItemPower(item: Item): number {
  return item.attack_bonus + item.defense_bonus + Math.round(item.hp_bonus / 10) + Math.round(item.crit_bonus * 2) + Math.round(item.dodge_bonus * 2)
}

export function calculateSetBonus(
  equippedItems: (Item | null)[],
  setBonusPercent: number = 5
): number {
  const validItems = equippedItems.filter((i): i is Item => i !== null)
  if (validItems.length === 0) return 0

  const setId = validItems[0].set_id
  const isComplete = validItems.length === 5 && validItems.every(i => i.set_id === setId)

  return isComplete ? setBonusPercent : 0
}

export function getSetStats(
  equippedItems: EquippedItems
): { setId: string | null; equippedCount: number; totalNeeded: number; isComplete: boolean; bonusPercent: number } {
  const items = Object.values(equippedItems).filter((i): i is NonNullable<typeof equippedItems[keyof typeof equippedItems]> => i !== null)

  if (items.length === 0) {
    return { setId: null, equippedCount: 0, totalNeeded: 5, isComplete: false, bonusPercent: 0 }
  }

  const setId = items[0].set_id
  const allSameSet = items.every(i => i.set_id === setId)
  const equippedCount = allSameSet ? items.length : 0
  const isComplete = equippedCount === 5

  return {
    setId: allSameSet ? setId : null,
    equippedCount,
    totalNeeded: 5,
    isComplete,
    bonusPercent: isComplete ? items[0].set_bonus_percentage : 0
  }
}
