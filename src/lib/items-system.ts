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

const GRADE_THEMES: Record<number, string> = {
  1: 'Ferro', 2: 'Bronze', 3: 'Aço', 4: 'Prata', 5: 'Ouro',
  6: 'Rubi', 7: 'Safira', 8: 'Jade', 9: 'Obsidiana', 10: 'Cristal',
  11: 'Ametista', 12: 'Diamante', 13: 'Mitril', 14: 'Adamante', 15: 'Oricalco',
  16: 'Astral', 17: 'Eclipse', 18: 'Solar', 19: 'Cósmico', 20: 'Primordial',
}

const CLASS_SET_NAMES: Record<string, string[]> = {
  paladin: [
    'Protetores de Ferro', 'Escudo de Bronze', 'Lâmina de Aço', 'Justiça Prateada', 'Coroa Dourada',
    'Cruz Rubi', 'Juramento Safira', 'Equilíbrio de Jade', 'Julgamento Obsidiano', 'Luz Cristalina',
    'Véu de Ametista', 'Muralha de Diamante', 'Armadura Mitril', 'Escudo Adamante', 'Alma de Oricalco',
    'Vigia Astral', 'Luar Eclipse', 'Coroa Solar', 'Guardião Cósmico', 'Forja dos Deuses',
  ],
  warrior: [
    'Esmagadores de Ferro', 'Punhos de Bronze', 'Couraça de Aço', 'Garras Prateadas', 'Trono Dourado',
    'Fúria Rubi', 'Ímpeto Safira', 'Força de Jade', 'Fúria Obsidiana', 'Golpe Cristalino',
    'Fúria de Ametista', 'Punho de Diamante', 'Lâmina Mitril', 'Martelo Adamante', 'Fúria de Oricalco',
    'Fúria Astral', 'Escuridão Eclipse', 'Queimadura Solar', 'Caos Cósmico', 'Caos Primordial',
  ],
  mage: [
    'Runas de Ferro', 'Círculos de Bronze', 'Orbes de Aço', 'Estrelas Prateadas', 'Pergaminho Dourado',
    'Chama Rubi', 'Visão Safira', 'Sabedoria de Jade', 'Abismo Obsidiano', 'Prisma Cristalino',
    'Mistério de Ametista', 'Estilhaços de Diamante', 'Tecido Mitril', 'Selos Adamantes', 'Energia de Oricalco',
    'Projeção Astral', 'Sombras Eclipse', 'Explosão Solar', 'Tecelão Cósmico', 'Fonte do Universo',
  ],
  archer: [
    'Pontas de Ferro', 'Aljava de Bronze', 'Gatilho de Aço', 'Flechas Prateadas', 'Mira Dourada',
    'Pontaria Rubi', 'Precisão Safira', 'Leveza de Jade', 'Sombra Obsidiana', 'Mira Cristalina',
    'Sombra de Ametista', 'Olho de Diamante', 'Arco Mitril', 'Flecha Adamante', 'Mira de Oricalco',
    'Cometa Astral', 'Crepúsculo Eclipse', 'Raio Solar', 'Estrela Cósmica', 'Primeira Flecha',
  ],
  cleric: [
    'Fé de Ferro', 'Sino de Bronze', 'Cálice de Aço', 'Bênção Prateada', 'Cálice Dourado',
    'Sangue Rubi', 'Cura Safira', 'Paz de Jade', 'Luto Obsidiano', 'Pureza Cristalina',
    'Fé de Ametista', 'Altar de Diamante', 'Cálice Mitril', 'Relicário Adamante', 'Sopro de Oricalco',
    'Corpo Astral', 'Silêncio Eclipse', 'Bênção Solar', 'Nexus Cósmico', 'Voz da Criação',
  ],
}

export function getSetName(setId: string): string {
  const parts = setId.split('_')
  if (parts.length < 4) return setId
  const gradeId = parseInt(parts[1], 10)
  const classCode = parts[3]
  if (isNaN(gradeId) || gradeId < 1 || gradeId > 20) return setId
  const classNames = CLASS_SET_NAMES[classCode]
  if (!classNames) return setId
  return classNames[gradeId - 1] || setId
}

export function getGradeTheme(gradeId: number): string {
  return GRADE_THEMES[gradeId] || `Grade ${gradeId}`
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
