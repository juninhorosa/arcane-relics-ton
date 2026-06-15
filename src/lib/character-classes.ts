/**
 * Character Classes for Arcane Relics
 * Define os tipos e atributos das classes disponíveis no jogo
 */

export type CharacterClassCode = 'paladin' | 'guerreiro' | 'mago' | 'archer' | 'clerigo'

export interface CharacterClass {
  id: string
  code: CharacterClassCode
  name: string
  emoji: string
  description: string
  attack_bonus: number
  defense_bonus: number
  hp_bonus: number
  ability: string
  created_at: string
  updated_at: string
}

/**
 * Definições das classes do jogo com bônus e habilidades
 */
export const CHARACTER_CLASSES: Record<CharacterClassCode, Omit<CharacterClass, 'id' | 'created_at' | 'updated_at'>> = {
  paladin: {
    code: 'paladin',
    name: 'Paladino',
    emoji: '⚔️',
    description: 'Guerreiro sagrado que equilibra força e defesa',
    attack_bonus: 8,
    defense_bonus: 15,
    hp_bonus: 20,
    ability: 'Proteção Divina: +30% de defesa em combates contra classes sombrias'
  },
  guerreiro: {
    code: 'guerreiro',
    name: 'Guerreiro',
    emoji: '🗡️',
    description: 'Mestre da luta corpo a corpo com poder devastador',
    attack_bonus: 20,
    defense_bonus: 5,
    hp_bonus: 15,
    ability: 'Grito de Guerra: +25% de ataque contra inimigos únicos'
  },
  mago: {
    code: 'mago',
    name: 'Mago',
    emoji: '🔮',
    description: 'Manipulador de magia arcana com poderes místicos',
    attack_bonus: 15,
    defense_bonus: 8,
    hp_bonus: 10,
    ability: 'Explosão Arcana: Pode fazer dano splash (20% do dano a inimigos próximos)'
  },
  archer: {
    code: 'archer',
    name: 'Arqueiro',
    emoji: '🏹',
    description: 'Atirador preciso que evita confrontos diretos',
    attack_bonus: 12,
    defense_bonus: 10,
    hp_bonus: 8,
    ability: 'Tiro Crítico: 15% de chance de acerto crítico (dano x2)'
  },
  clerigo: {
    code: 'clerigo',
    name: 'Clérigo',
    emoji: '✨',
    description: 'Curador e suporte que oferece bênçãos divinas',
    attack_bonus: 5,
    defense_bonus: 12,
    hp_bonus: 25,
    ability: 'Bênção Curadora: Recupera 10% de HP ao vencer combate'
  }
}

/**
 * Obtém uma classe pelo código
 */
export function getClassByCode(code: CharacterClassCode) {
  return CHARACTER_CLASSES[code]
}

/**
 * Retorna array de todas as classes
 */
export function getAllClasses() {
  return Object.values(CHARACTER_CLASSES)
}

/**
 * Verifica se o código é uma classe válida
 */
export function isValidClassCode(code: string): code is CharacterClassCode {
  return code in CHARACTER_CLASSES
}

/**
 * Calcula bônus totais da classe para um jogador
 */
export function getClassBonuses(classCode: CharacterClassCode) {
  const playerClass = CHARACTER_CLASSES[classCode]
  return {
    attack: playerClass.attack_bonus,
    defense: playerClass.defense_bonus,
    hp: playerClass.hp_bonus
  }
}

/**
 * Formata nome da classe para exibição
 */
export function formatClassName(code: CharacterClassCode) {
  const playerClass = CHARACTER_CLASSES[code]
  return `${playerClass.emoji} ${playerClass.name}`
}
