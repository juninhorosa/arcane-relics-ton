// Generator: 500 items (20 grades × 5 classes × 5 slots)
const fs = require('fs')

const GRADES = [
  { id: 1,  name: 'Ferro',      theme: 'ferro',      rarity: 'common',    min_level: 1,  max_level: 5  },
  { id: 2,  name: 'Bronze',     theme: 'bronze',     rarity: 'common',    min_level: 5,  max_level: 10 },
  { id: 3,  name: 'Aco',        theme: 'aco',        rarity: 'common',    min_level: 10, max_level: 15 },
  { id: 4,  name: 'Prata',      theme: 'prata',      rarity: 'uncommon',  min_level: 15, max_level: 20 },
  { id: 5,  name: 'Ouro',       theme: 'ouro',       rarity: 'uncommon',  min_level: 20, max_level: 25 },
  { id: 6,  name: 'Rubi',       theme: 'rubi',       rarity: 'uncommon',  min_level: 25, max_level: 30 },
  { id: 7,  name: 'Safira',     theme: 'safira',     rarity: 'rare',      min_level: 30, max_level: 35 },
  { id: 8,  name: 'Jade',       theme: 'jade',       rarity: 'rare',      min_level: 35, max_level: 40 },
  { id: 9,  name: 'Obsidiana',  theme: 'obsidiana',  rarity: 'rare',      min_level: 40, max_level: 45 },
  { id: 10, name: 'Cristal',    theme: 'cristal',    rarity: 'epic',      min_level: 45, max_level: 50 },
  { id: 11, name: 'Ametista',   theme: 'ametista',   rarity: 'epic',      min_level: 50, max_level: 55 },
  { id: 12, name: 'Diamante',   theme: 'diamante',   rarity: 'epic',      min_level: 55, max_level: 60 },
  { id: 13, name: 'Mitril',     theme: 'mitril',     rarity: 'legendary', min_level: 60, max_level: 65 },
  { id: 14, name: 'Adamante',   theme: 'adamante',   rarity: 'legendary', min_level: 65, max_level: 70 },
  { id: 15, name: 'Oricalco',   theme: 'oricalco',   rarity: 'legendary', min_level: 70, max_level: 75 },
  { id: 16, name: 'Astral',     theme: 'astral',     rarity: 'legendary', min_level: 75, max_level: 80 },
  { id: 17, name: 'Eclipse',    theme: 'eclipse',    rarity: 'legendary', min_level: 80, max_level: 85 },
  { id: 18, name: 'Solar',      theme: 'solar',      rarity: 'legendary', min_level: 85, max_level: 90 },
  { id: 19, name: 'Cosmico',    theme: 'cosmico',    rarity: 'legendary', min_level: 90, max_level: 95 },
  { id: 20, name: 'Primordial', theme: 'primordial',  rarity: 'legendary', min_level: 95, max_level: 100 },
]

const CLASSES = [
  {
    code: 'paladin', name: 'Paladino',
    set_names: [
      'Protetores de Ferro', 'Escudo de Bronze', 'Lâmina de Aço', 'Justiça Prateada', 'Coroa Dourada',
      'Cruz Rubi', 'Juramento Safira', 'Equilíbrio de Jade', 'Julgamento Obsidiano', 'Luz Cristalina',
      'Véu de Ametista', 'Muralha de Diamante', 'Armadura Mitril', 'Escudo Adamante', 'Alma de Oricalco',
      'Vigia Astral', 'Luar Eclipse', 'Coroa Solar', 'Guardião Cósmico', 'Forja dos Deuses',
    ],
    emoji: '⚔️',
    atk_mul: 0.8, def_mul: 1.2, hp_mul: 1.3, crit_mul: 0.5, dodge_mul: 0.5,
  },
  {
    code: 'warrior', name: 'Guerreiro',
    set_names: [
      'Esmagadores de Ferro', 'Punhos de Bronze', 'Couraça de Aço', 'Garras Prateadas', 'Trono Dourado',
      'Fúria Rubi', 'Ímpeto Safira', 'Força de Jade', 'Fúria Obsidiana', 'Golpe Cristalino',
      'Fúria de Ametista', 'Punho de Diamante', 'Lâmina Mitril', 'Martelo Adamante', 'Fúria de Oricalco',
      'Fúria Astral', 'Escuridão Eclipse', 'Queimadura Solar', 'Caos Cósmico', 'Caos Primordial',
    ],
    emoji: '🗡️',
    atk_mul: 1.5, def_mul: 0.7, hp_mul: 1.0, crit_mul: 1.0, dodge_mul: 0.3,
  },
  {
    code: 'mage', name: 'Mago',
    set_names: [
      'Runas de Ferro', 'Círculos de Bronze', 'Orbes de Aço', 'Estrelas Prateadas', 'Pergaminho Dourado',
      'Chama Rubi', 'Visão Safira', 'Sabedoria de Jade', 'Abismo Obsidiano', 'Prisma Cristalino',
      'Mistério de Ametista', 'Estilhaços de Diamante', 'Tecido Mitril', 'Selos Adamantes', 'Energia de Oricalco',
      'Projeção Astral', 'Sombras Eclipse', 'Explosão Solar', 'Tecelão Cósmico', 'Fonte do Universo',
    ],
    emoji: '🔮',
    atk_mul: 1.3, def_mul: 0.8, hp_mul: 0.7, crit_mul: 1.5, dodge_mul: 0.3,
  },
  {
    code: 'archer', name: 'Arqueiro',
    set_names: [
      'Pontas de Ferro', 'Aljava de Bronze', 'Gatilho de Aço', 'Flechas Prateadas', 'Mira Dourada',
      'Pontaria Rubi', 'Precisão Safira', 'Leveza de Jade', 'Sombra Obsidiana', 'Mira Cristalina',
      'Sombra de Ametista', 'Olho de Diamante', 'Arco Mitril', 'Flecha Adamante', 'Mira de Oricalco',
      'Cometa Astral', 'Crepúsculo Eclipse', 'Raio Solar', 'Estrela Cósmica', 'Primeira Flecha',
    ],
    emoji: '🏹',
    atk_mul: 1.2, def_mul: 0.6, hp_mul: 0.5, crit_mul: 2.0, dodge_mul: 2.0,
  },
  {
    code: 'cleric', name: 'Clérigo',
    set_names: [
      'Fé de Ferro', 'Sino de Bronze', 'Cálice de Aço', 'Bênção Prateada', 'Cálice Dourado',
      'Sangue Rubi', 'Cura Safira', 'Paz de Jade', 'Luto Obsidiano', 'Pureza Cristalina',
      'Fé de Ametista', 'Altar de Diamante', 'Cálice Mitril', 'Relicário Adamante', 'Sopro de Oricalco',
      'Corpo Astral', 'Silêncio Eclipse', 'Bênção Solar', 'Nexus Cósmico', 'Voz da Criação',
    ],
    emoji: '✨',
    atk_mul: 0.5, def_mul: 1.3, hp_mul: 1.8, crit_mul: 0.3, dodge_mul: 0.8,
  },
]

const SLOTS = [
  { key: 'weapon', name: 'Arma',     emoji: '⚔️', atk: 0.40, def: 0.05, hp: 0.00, crit: 0.20, dodge: 0.00 },
  { key: 'helmet', name: 'Capacete', emoji: '🪖', atk: 0.15, def: 0.30, hp: 0.20, crit: 0.10, dodge: 0.10 },
  { key: 'armor',  name: 'Armadura', emoji: '🛡️', atk: 0.10, def: 0.40, hp: 0.40, crit: 0.00, dodge: 0.00 },
  { key: 'gloves', name: 'Luvas',    emoji: '🧤', atk: 0.25, def: 0.10, hp: 0.10, crit: 0.50, dodge: 0.10 },
  { key: 'boots',  name: 'Botas',    emoji: '👢', atk: 0.10, def: 0.15, hp: 0.30, crit: 0.20, dodge: 0.80 },
]

const ITEM_DESCRIPTIONS = {
  paladin: {
    weapon: ['Lâmina sagrada que brilha com luz celestial', 'Espada forjada com bênçãos ancestrais', 'Arma divina que protege os justos'],
    helmet: ['Elmo que guarda a sabedoria dos antigos cavaleiros', 'Proteção sagrada para a mente do paladino', 'Coroa da fé que resguarda o espírito'],
    armor: ['Armadura imbuída com proteção divina', 'Couraça que reflete a luz da justiça', 'Vestes de batalha abençoadas pelos céus'],
    gloves: ['Luvas que canalizam o poder divino', 'Manoplas da justiça que punem os ímpios', 'Protetores das mãos que empunham a fé'],
    boots: ['Grevas que pisam o caminho da retidão', 'Botas da jornada sagrada do paladino', 'Passos firmes na trilha da justiça'],
  },
  warrior: {
    weapon: ['Arma brutal forjada em sangue e aço', 'Machado que grita por batalha', 'Arma de guerra que conhece mil campos'],
    helmet: ['Elmo marcado por cicatrizes de batalhas', 'Proteção feroz para o guerreiro indomável', 'Capacete de guerra temperado no fogo'],
    armor: ['Armadura que carrega as marcas da guerra', 'Couraça resistente forjada para o combate', 'Proteção total para o campo de batalha'],
    gloves: ['Luvas que esmagam ossos e escudos', 'Manoplas da força bruta e destruição', 'Protetores dos punhos do guerreiro'],
    boots: ['Botas que avançam sem medo na batalha', 'Grevas da investida feroz', 'Passos de guerra que tremem o chão'],
  },
  mage: {
    weapon: ['Cajado que canaliza energias arcanas', 'Bastão imbuído com magia ancestral', 'Arcano foco de poder místico'],
    helmet: ['Tiara que amplia o poder da mente', 'Coroa arcana que protege o intelecto', 'Elmo da sabedoria mística'],
    armor: ['Vestes tecidas com fios de mana pura', 'Túnica protegida por encantamentos', 'Armadura arcana de tecido estelar'],
    gloves: ['Luvas que potencializam feitiços', 'Manoplas arcanas de canalização mágica', 'Protetores dos dedos do conjurador'],
    boots: ['Botas que flutuam entre planos', 'Sandálias aladas de velocidade mágica', 'Calçados que pisam o éter'],
  },
  archer: {
    weapon: ['Arco que dispara flechas infalíveis', 'Besta de precisão mortal', 'Arco longo de madeira encantada'],
    helmet: ['Elmo que aguça a visão do caçador', 'Gorjal que protege o pescoço do atirador', 'Capuz da precisão silenciosa'],
    armor: ['Gibão leve que permite movimento rápido', 'Colete de couro reforçado para flexibilidade', 'Armadura leve de caçador experiente'],
    gloves: ['Luvas que estabilizam a mira', 'Dedais de pontaria precisa', 'Manoplas leves para puxar o arco'],
    boots: ['Botas silenciosas para mover-se nas sombras', 'Calçados da agilidade do vento', 'Passos ligeiros do rastreador'],
  },
  cleric: {
    weapon: ['Maça que cura tanto quanto fere', 'Martelo da redenção divina', 'Bastão sagrado de poder celestial'],
    helmet: ['Auréola de fé que protege o espírito', 'Elmo da devoção eterna', 'Coroa de luz sagrada'],
    armor: ['Vestes imaculadas de poder divino', 'Túnica sagrada da cura', 'Armadura da fé inquebrável'],
    gloves: ['Luvas que canalizam energia curativa', 'Manoplas da restauração divina', 'Protetores das mãos que abençoam'],
    boots: ['Sandálias da jornada espiritual', 'Botas que pisam terras sagradas', 'Calçados do peregrino da fé'],
  },
}

const GRADE_THEME_DESC = {
  ferro: 'de Ferro', bronze: 'de Bronze', aco: 'de Aço', prata: 'Prateado',
  ouro: 'Dourado', rubi: 'Rubi', safira: 'Safira', jade: 'de Jade',
  obsidiana: 'Obsidiano', cristal: 'Cristalino', ametista: 'de Ametista',
  diamante: 'de Diamante', mitril: 'Mitril', adamante: 'Adamante',
  oricalco: 'de Oricalco', astral: 'Astral', eclipse: 'Eclipse',
  solar: 'Solar', cosmico: 'Cósmico', primordial: 'Primordial',
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1)
}

function calcStat(baseVal, classMul, slotPct, gradeId) {
  const raw = baseVal * classMul * slotPct
  const variation = 0.85 + (Math.sin(gradeId * 13.7 + slotPct * 7.3) * 0.15) // pseudo-random feel
  return Math.max(1, Math.round(raw * variation))
}

function generateSQL() {
  const lines = []

  lines.push('-- ============================================================================')
  lines.push('-- ITEMS SYSTEM MIGRATION v2')
  lines.push('-- 500 items: 20 grades × 5 classes × 5 slots')
  lines.push('-- Generated: ' + new Date().toISOString())
  lines.push('-- ============================================================================')
  lines.push('')
  lines.push('-- First, remove old seed data (25 items from v1)')
  lines.push("DELETE FROM player_inventory;")
  lines.push("DELETE FROM items;")
  lines.push('')
  lines.push('-- Get class IDs')
  lines.push('DO $$')
  lines.push('DECLARE')
  lines.push('  v_paladin_id UUID;')
  lines.push('  v_warrior_id UUID;')
  lines.push('  v_mage_id UUID;')
  lines.push('  v_archer_id UUID;')
  lines.push('  v_cleric_id UUID;')
  lines.push('  v_set_id TEXT;')
  lines.push('  v_item_count INTEGER := 0;')
  lines.push('BEGIN')
  lines.push('  SELECT id INTO v_paladin_id FROM character_classes WHERE code = \'paladin\';')
  lines.push('  SELECT id INTO v_warrior_id FROM character_classes WHERE code = \'warrior\';')
  lines.push('  SELECT id INTO v_mage_id FROM character_classes WHERE code = \'mage\';')
  lines.push('  SELECT id INTO v_archer_id FROM character_classes WHERE code = \'archer\';')
  lines.push('  SELECT id INTO v_cleric_id FROM character_classes WHERE code = \'cleric\';')
  lines.push('')

  for (const grade of GRADES) {
    const themeLabel = capitalize(grade.theme)
    lines.push(`  -- ========================================================================`)
    lines.push(`  -- GRADE ${grade.id} — ${grade.name} (Níveis ${grade.min_level}-${grade.max_level}) — ${grade.rarity.toUpperCase()}`)
    lines.push(`  -- ========================================================================`)
    lines.push('')

    for (const cls of CLASSES) {
      const setId = `grade_${grade.id}_${grade.theme}_${cls.code}`
      const baseVal = grade.id * 10 + 5
      const setIdx = grade.id - 1
      const setName = cls.set_names[setIdx]

      lines.push(`    -- ${cls.name} — ${setName}`)

      for (const slot of SLOTS) {
        const code = `${cls.code}_g${String(grade.id).padStart(2, '0')}_${slot.key}`
        const itemName = `${setName} — ${slot.name}`
        const descTemplates = ITEM_DESCRIPTIONS[cls.code][slot.key]
        const desc = descTemplates[grade.id % descTemplates.length]

        const atk = calcStat(baseVal, cls.atk_mul, slot.atk, grade.id)
        const def = calcStat(baseVal, cls.def_mul, slot.def, grade.id)
        const hp = calcStat(baseVal, cls.hp_mul, slot.hp, grade.id)
        const crit = Math.round((cls.crit_mul * slot.crit * (5 + grade.id * 0.5)) * 10) / 10
        const dodge = Math.round((cls.dodge_mul * slot.dodge * (3 + grade.id * 0.3)) * 10) / 10
        const requiredLevel = grade.min_level

        // Determine class_id variable
        let classVar = ''
        switch (cls.code) {
          case 'paladin': classVar = 'v_paladin_id'; break
          case 'warrior': classVar = 'v_warrior_id'; break
          case 'mage': classVar = 'v_mage_id'; break
          case 'archer': classVar = 'v_archer_id'; break
          case 'cleric': classVar = 'v_cleric_id'; break
        }

        lines.push(
          `    INSERT INTO items (code, name, emoji, description, category, class_id, ` +
          `attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)`
        )
        lines.push(
          `    VALUES ('${code}', '${itemName}', '${cls.emoji}', '${desc}', '${slot.key}', ${classVar}, ` +
          `${atk}, ${def}, ${hp}, ${crit}, ${dodge}, '${grade.rarity}', ${requiredLevel}, '${setId}', 5.0);`
        )
        lines.push(`    v_item_count := v_item_count + 1;`)
      }
      lines.push('')
    }
  }

  lines.push('  -- ========================================================================')
  lines.push('  -- SUMMARY')
  lines.push('  -- ========================================================================')
  lines.push('  RAISE NOTICE \'Created % items across % grades\', v_item_count, 20;')
  lines.push('END $$;')
  lines.push('')

  return lines.join('\n')
}

const sql = generateSQL()
fs.writeFileSync(
  'C:\\coisas novas interessantes telegram\\arcane-relics-ton-main\\.lovable\\20260615000007_items_v2_seed.sql',
  sql,
  'utf8'
)

// Count total INSERT statements
const insertCount = (sql.match(/INSERT INTO items/g) || []).length
console.log(`Generated ${insertCount} item INSERT statements`)
console.log('File saved to .lovable/20260615000007_items_v2_seed.sql')
