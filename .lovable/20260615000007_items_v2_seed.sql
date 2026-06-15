-- ============================================================================
-- ITEMS SYSTEM MIGRATION v2
-- 500 items: 20 grades × 5 classes × 5 slots
-- Generated: 2026-06-15T12:00:53.874Z
-- ============================================================================

-- First, remove old seed data (25 items from v1)
DELETE FROM player_inventory;
DELETE FROM items;

-- Get class IDs
DO $$
DECLARE
  v_paladin_id UUID;
  v_warrior_id UUID;
  v_mage_id UUID;
  v_archer_id UUID;
  v_cleric_id UUID;
  v_item_count INTEGER := 0;
BEGIN
  SELECT id INTO v_paladin_id FROM character_classes WHERE code = 'paladin';
  SELECT id INTO v_warrior_id FROM character_classes WHERE code = 'warrior';
  SELECT id INTO v_mage_id FROM character_classes WHERE code = 'mage';
  SELECT id INTO v_archer_id FROM character_classes WHERE code = 'archer';
  SELECT id INTO v_cleric_id FROM character_classes WHERE code = 'cleric';

  -- ========================================================================
  -- GRADE 1 — Ferro (Níveis 1-5) — COMMON
  -- ========================================================================

    -- Paladino — Protetores de Ferro
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g01_weapon', 'Protetores de Ferro — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 4, 1, 1, 0.6, 0, 'common', 1, 'grade_1_ferro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g01_helmet', 'Protetores de Ferro — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 2, 4, 4, 0.3, 0.2, 'common', 1, 'grade_1_ferro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g01_armor', 'Protetores de Ferro — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 1, 5, 6, 0, 0, 'common', 1, 'grade_1_ferro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g01_gloves', 'Protetores de Ferro — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 3, 2, 2, 1.4, 0.2, 'common', 1, 'grade_1_ferro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g01_boots', 'Protetores de Ferro — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 1, 3, 5, 0.6, 1.3, 'common', 1, 'grade_1_ferro_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Esmagadores de Ferro
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g01_weapon', 'Esmagadores de Ferro — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 7, 1, 1, 1.1, 0, 'common', 1, 'grade_1_ferro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g01_helmet', 'Esmagadores de Ferro — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 3, 3, 3, 0.6, 0.1, 'common', 1, 'grade_1_ferro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g01_armor', 'Esmagadores de Ferro — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 2, 3, 4, 0, 0, 'common', 1, 'grade_1_ferro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g01_gloves', 'Esmagadores de Ferro — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 5, 1, 1, 2.8, 0.1, 'common', 1, 'grade_1_ferro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g01_boots', 'Esmagadores de Ferro — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 2, 2, 4, 1.1, 0.8, 'common', 1, 'grade_1_ferro_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Runas de Ferro
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g01_weapon', 'Runas de Ferro — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 6, 1, 1, 1.7, 0, 'common', 1, 'grade_1_ferro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g01_helmet', 'Runas de Ferro — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 3, 3, 2, 0.8, 0.1, 'common', 1, 'grade_1_ferro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g01_armor', 'Runas de Ferro — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 2, 4, 3, 0, 0, 'common', 1, 'grade_1_ferro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g01_gloves', 'Runas de Ferro — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 4, 1, 1, 4.1, 0.1, 'common', 1, 'grade_1_ferro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g01_boots', 'Runas de Ferro — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 2, 2, 3, 1.7, 0.8, 'common', 1, 'grade_1_ferro_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Pontas de Ferro
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g01_weapon', 'Pontas de Ferro — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 5, 1, 1, 2.2, 0, 'common', 1, 'grade_1_ferro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g01_helmet', 'Pontas de Ferro — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 3, 2, 1, 1.1, 0.7, 'common', 1, 'grade_1_ferro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g01_armor', 'Pontas de Ferro — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 2, 3, 2, 0, 0, 'common', 1, 'grade_1_ferro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g01_gloves', 'Pontas de Ferro — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 4, 1, 1, 5.5, 0.7, 'common', 1, 'grade_1_ferro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g01_boots', 'Pontas de Ferro — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 2, 1, 2, 2.2, 5.3, 'common', 1, 'grade_1_ferro_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Fé de Ferro
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g01_weapon', 'Fé de Ferro — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 2, 1, 1, 0.3, 0, 'common', 1, 'grade_1_ferro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g01_helmet', 'Fé de Ferro — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 1, 5, 5, 0.2, 0.3, 'common', 1, 'grade_1_ferro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g01_armor', 'Fé de Ferro — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 1, 6, 8, 0, 0, 'common', 1, 'grade_1_ferro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g01_gloves', 'Fé de Ferro — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 2, 2, 3, 0.8, 0.3, 'common', 1, 'grade_1_ferro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g01_boots', 'Fé de Ferro — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 1, 3, 7, 0.3, 2.1, 'common', 1, 'grade_1_ferro_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 2 — Bronze (Níveis 5-10) — COMMON
  -- ========================================================================

    -- Paladino — Escudo de Bronze
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g02_weapon', 'Escudo de Bronze — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 6, 1, 1, 0.6, 0, 'common', 5, 'grade_2_bronze_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g02_helmet', 'Escudo de Bronze — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 2, 6, 5, 0.3, 0.2, 'common', 5, 'grade_2_bronze_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g02_armor', 'Escudo de Bronze — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 2, 9, 9, 0, 0, 'common', 5, 'grade_2_bronze_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g02_gloves', 'Escudo de Bronze — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 4, 3, 3, 1.5, 0.2, 'common', 5, 'grade_2_bronze_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g02_boots', 'Escudo de Bronze — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 2, 4, 7, 0.6, 1.4, 'common', 5, 'grade_2_bronze_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Punhos de Bronze
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g02_weapon', 'Punhos de Bronze — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 11, 1, 1, 1.2, 0, 'common', 5, 'grade_2_bronze_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g02_helmet', 'Punhos de Bronze — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 5, 4, 4, 0.6, 0.1, 'common', 5, 'grade_2_bronze_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g02_armor', 'Punhos de Bronze — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 3, 5, 7, 0, 0, 'common', 5, 'grade_2_bronze_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g02_gloves', 'Punhos de Bronze — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 7, 2, 2, 3, 0.1, 'common', 5, 'grade_2_bronze_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g02_boots', 'Punhos de Bronze — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 3, 2, 5, 1.2, 0.9, 'common', 5, 'grade_2_bronze_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Círculos de Bronze
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g02_weapon', 'Círculos de Bronze — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 9, 1, 1, 1.8, 0, 'common', 5, 'grade_2_bronze_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g02_helmet', 'Círculos de Bronze — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 4, 4, 3, 0.9, 0.1, 'common', 5, 'grade_2_bronze_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g02_armor', 'Círculos de Bronze — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 3, 6, 5, 0, 0, 'common', 5, 'grade_2_bronze_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g02_gloves', 'Círculos de Bronze — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 6, 2, 2, 4.5, 0.1, 'common', 5, 'grade_2_bronze_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g02_boots', 'Círculos de Bronze — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 3, 2, 4, 1.8, 0.9, 'common', 5, 'grade_2_bronze_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Aljava de Bronze
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g02_weapon', 'Aljava de Bronze — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 9, 1, 1, 2.4, 0, 'common', 5, 'grade_2_bronze_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g02_helmet', 'Aljava de Bronze — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 4, 3, 2, 1.2, 0.7, 'common', 5, 'grade_2_bronze_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g02_armor', 'Aljava de Bronze — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 3, 4, 4, 0, 0, 'common', 5, 'grade_2_bronze_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g02_gloves', 'Aljava de Bronze — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 5, 1, 1, 6, 0.7, 'common', 5, 'grade_2_bronze_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g02_boots', 'Aljava de Bronze — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 3, 2, 3, 2.4, 5.8, 'common', 5, 'grade_2_bronze_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Sino de Bronze
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g02_weapon', 'Sino de Bronze — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 4, 2, 1, 0.4, 0, 'common', 5, 'grade_2_bronze_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g02_helmet', 'Sino de Bronze — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 2, 7, 7, 0.2, 0.3, 'common', 5, 'grade_2_bronze_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g02_armor', 'Sino de Bronze — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 1, 9, 13, 0, 0, 'common', 5, 'grade_2_bronze_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g02_gloves', 'Sino de Bronze — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 2, 3, 4, 0.9, 0.3, 'common', 5, 'grade_2_bronze_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g02_boots', 'Sino de Bronze — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 1, 4, 10, 0.4, 2.3, 'common', 5, 'grade_2_bronze_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 3 — Aco (Níveis 10-15) — COMMON
  -- ========================================================================

    -- Paladino — Lâmina de Aço
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g03_weapon', 'Lâmina de Aço — Arma', '⚔️', 'Lâmina sagrada que brilha com luz celestial', 'weapon', v_paladin_id, 10, 2, 1, 0.7, 0, 'common', 10, 'grade_3_aco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g03_helmet', 'Lâmina de Aço — Capacete', '⚔️', 'Elmo que guarda a sabedoria dos antigos cavaleiros', 'helmet', v_paladin_id, 3, 10, 6, 0.3, 0.2, 'common', 10, 'grade_3_aco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g03_armor', 'Lâmina de Aço — Armadura', '⚔️', 'Armadura imbuída com proteção divina', 'armor', v_paladin_id, 2, 14, 16, 0, 0, 'common', 10, 'grade_3_aco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g03_gloves', 'Lâmina de Aço — Luvas', '⚔️', 'Luvas que canalizam o poder divino', 'gloves', v_paladin_id, 5, 3, 3, 1.6, 0.2, 'common', 10, 'grade_3_aco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g03_boots', 'Lâmina de Aço — Botas', '⚔️', 'Grevas que pisam o caminho da retidão', 'boots', v_paladin_id, 2, 4, 10, 0.7, 1.6, 'common', 10, 'grade_3_aco_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Couraça de Aço
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g03_weapon', 'Couraça de Aço — Arma', '🗡️', 'Arma brutal forjada em sangue e aço', 'weapon', v_warrior_id, 18, 1, 1, 1.3, 0, 'common', 10, 'grade_3_aco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g03_helmet', 'Couraça de Aço — Capacete', '🗡️', 'Elmo marcado por cicatrizes de batalhas', 'helmet', v_warrior_id, 6, 6, 5, 0.7, 0.1, 'common', 10, 'grade_3_aco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g03_armor', 'Couraça de Aço — Armadura', '🗡️', 'Armadura que carrega as marcas da guerra', 'armor', v_warrior_id, 4, 8, 12, 0, 0, 'common', 10, 'grade_3_aco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g03_gloves', 'Couraça de Aço — Luvas', '🗡️', 'Luvas que esmagam ossos e escudos', 'gloves', v_warrior_id, 9, 2, 3, 3.3, 0.1, 'common', 10, 'grade_3_aco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g03_boots', 'Couraça de Aço — Botas', '🗡️', 'Botas que avançam sem medo na batalha', 'boots', v_warrior_id, 4, 3, 8, 1.3, 0.9, 'common', 10, 'grade_3_aco_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Orbes de Aço
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g03_weapon', 'Orbes de Aço — Arma', '🔮', 'Cajado que canaliza energias arcanas', 'weapon', v_mage_id, 16, 1, 1, 2, 0, 'common', 10, 'grade_3_aco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g03_helmet', 'Orbes de Aço — Capacete', '🔮', 'Tiara que amplia o poder da mente', 'helmet', v_mage_id, 5, 6, 3, 1, 0.1, 'common', 10, 'grade_3_aco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g03_armor', 'Orbes de Aço — Armadura', '🔮', 'Vestes tecidas com fios de mana pura', 'armor', v_mage_id, 3, 10, 8, 0, 0, 'common', 10, 'grade_3_aco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g03_gloves', 'Orbes de Aço — Luvas', '🔮', 'Luvas que potencializam feitiços', 'gloves', v_mage_id, 8, 2, 2, 4.9, 0.1, 'common', 10, 'grade_3_aco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g03_boots', 'Orbes de Aço — Botas', '🔮', 'Botas que flutuam entre planos', 'boots', v_mage_id, 3, 3, 6, 2, 0.9, 'common', 10, 'grade_3_aco_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Gatilho de Aço
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g03_weapon', 'Gatilho de Aço — Arma', '🏹', 'Arco que dispara flechas infalíveis', 'weapon', v_archer_id, 14, 1, 1, 2.6, 0, 'common', 10, 'grade_3_aco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g03_helmet', 'Gatilho de Aço — Capacete', '🏹', 'Elmo que aguça a visão do caçador', 'helmet', v_archer_id, 4, 5, 2, 1.3, 0.8, 'common', 10, 'grade_3_aco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g03_armor', 'Gatilho de Aço — Armadura', '🏹', 'Gibão leve que permite movimento rápido', 'armor', v_archer_id, 3, 7, 6, 0, 0, 'common', 10, 'grade_3_aco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g03_gloves', 'Gatilho de Aço — Luvas', '🏹', 'Luvas que estabilizam a mira', 'gloves', v_archer_id, 8, 2, 1, 6.5, 0.8, 'common', 10, 'grade_3_aco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g03_boots', 'Gatilho de Aço — Botas', '🏹', 'Botas silenciosas para mover-se nas sombras', 'boots', v_archer_id, 3, 2, 4, 2.6, 6.2, 'common', 10, 'grade_3_aco_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Cálice de Aço
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g03_weapon', 'Cálice de Aço — Arma', '✨', 'Maça que cura tanto quanto fere', 'weapon', v_cleric_id, 6, 2, 1, 0.4, 0, 'common', 10, 'grade_3_aco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g03_helmet', 'Cálice de Aço — Capacete', '✨', 'Auréola de fé que protege o espírito', 'helmet', v_cleric_id, 2, 10, 9, 0.2, 0.3, 'common', 10, 'grade_3_aco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g03_armor', 'Cálice de Aço — Armadura', '✨', 'Vestes imaculadas de poder divino', 'armor', v_cleric_id, 1, 16, 22, 0, 0, 'common', 10, 'grade_3_aco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g03_gloves', 'Cálice de Aço — Luvas', '✨', 'Luvas que canalizam energia curativa', 'gloves', v_cleric_id, 3, 3, 5, 1, 0.3, 'common', 10, 'grade_3_aco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g03_boots', 'Cálice de Aço — Botas', '✨', 'Sandálias da jornada espiritual', 'boots', v_cleric_id, 1, 5, 14, 0.4, 2.5, 'common', 10, 'grade_3_aco_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 4 — Prata (Níveis 15-20) — UNCOMMON
  -- ========================================================================

    -- Paladino — Justiça Prateada
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g04_weapon', 'Justiça Prateada — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 14, 2, 1, 0.7, 0, 'uncommon', 15, 'grade_4_prata_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g04_helmet', 'Justiça Prateada — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 4, 15, 9, 0.4, 0.2, 'uncommon', 15, 'grade_4_prata_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g04_armor', 'Justiça Prateada — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 3, 21, 23, 0, 0, 'uncommon', 15, 'grade_4_prata_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g04_gloves', 'Justiça Prateada — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 8, 4, 4, 1.8, 0.2, 'uncommon', 15, 'grade_4_prata_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g04_boots', 'Justiça Prateada — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 3, 6, 16, 0.7, 1.7, 'uncommon', 15, 'grade_4_prata_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Garras Prateadas
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g04_weapon', 'Garras Prateadas — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 27, 1, 1, 1.4, 0, 'uncommon', 15, 'grade_4_prata_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g04_helmet', 'Garras Prateadas — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 8, 9, 7, 0.7, 0.1, 'uncommon', 15, 'grade_4_prata_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g04_armor', 'Garras Prateadas — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 5, 12, 18, 0, 0, 'uncommon', 15, 'grade_4_prata_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g04_gloves', 'Garras Prateadas — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 15, 2, 3, 3.5, 0.1, 'uncommon', 15, 'grade_4_prata_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g04_boots', 'Garras Prateadas — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 5, 4, 12, 1.4, 1, 'uncommon', 15, 'grade_4_prata_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Estrelas Prateadas
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g04_weapon', 'Estrelas Prateadas — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 23, 1, 1, 2.1, 0, 'uncommon', 15, 'grade_4_prata_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g04_helmet', 'Estrelas Prateadas — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 7, 10, 5, 1.1, 0.1, 'uncommon', 15, 'grade_4_prata_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g04_armor', 'Estrelas Prateadas — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 4, 14, 12, 0, 0, 'uncommon', 15, 'grade_4_prata_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g04_gloves', 'Estrelas Prateadas — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 13, 3, 2, 5.3, 0.1, 'uncommon', 15, 'grade_4_prata_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g04_boots', 'Estrelas Prateadas — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 4, 4, 9, 2.1, 1, 'uncommon', 15, 'grade_4_prata_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Flechas Prateadas
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g04_weapon', 'Flechas Prateadas — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 21, 1, 1, 2.8, 0, 'uncommon', 15, 'grade_4_prata_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g04_helmet', 'Flechas Prateadas — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 6, 7, 4, 1.4, 0.8, 'uncommon', 15, 'grade_4_prata_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g04_armor', 'Flechas Prateadas — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 4, 11, 9, 0, 0, 'uncommon', 15, 'grade_4_prata_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g04_gloves', 'Flechas Prateadas — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 12, 2, 2, 7, 0.8, 'uncommon', 15, 'grade_4_prata_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g04_boots', 'Flechas Prateadas — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 4, 3, 6, 2.8, 6.7, 'uncommon', 15, 'grade_4_prata_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Bênção Prateada
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g04_weapon', 'Bênção Prateada — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 9, 2, 1, 0.4, 0, 'uncommon', 15, 'grade_4_prata_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g04_helmet', 'Bênção Prateada — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 3, 16, 13, 0.2, 0.3, 'uncommon', 15, 'grade_4_prata_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g04_armor', 'Bênção Prateada — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 2, 23, 32, 0, 0, 'uncommon', 15, 'grade_4_prata_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g04_gloves', 'Bênção Prateada — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 5, 4, 6, 1.1, 0.3, 'uncommon', 15, 'grade_4_prata_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g04_boots', 'Bênção Prateada — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 2, 7, 22, 0.4, 2.7, 'uncommon', 15, 'grade_4_prata_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 5 — Ouro (Níveis 20-25) — UNCOMMON
  -- ========================================================================

    -- Paladino — Coroa Dourada
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g05_weapon', 'Coroa Dourada — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 17, 3, 1, 0.8, 0, 'uncommon', 20, 'grade_5_ouro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g05_helmet', 'Coroa Dourada — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 6, 20, 14, 0.4, 0.2, 'uncommon', 20, 'grade_5_ouro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g05_armor', 'Coroa Dourada — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 4, 25, 27, 0, 0, 'uncommon', 20, 'grade_5_ouro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g05_gloves', 'Coroa Dourada — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 11, 6, 6, 1.9, 0.2, 'uncommon', 20, 'grade_5_ouro_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g05_boots', 'Coroa Dourada — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 4, 9, 21, 0.8, 1.8, 'uncommon', 20, 'grade_5_ouro_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Trono Dourado
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g05_weapon', 'Trono Dourado — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 32, 2, 1, 1.5, 0, 'uncommon', 20, 'grade_5_ouro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g05_helmet', 'Trono Dourado — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 11, 12, 11, 0.8, 0.1, 'uncommon', 20, 'grade_5_ouro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g05_armor', 'Trono Dourado — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 7, 15, 21, 0, 0, 'uncommon', 20, 'grade_5_ouro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g05_gloves', 'Trono Dourado — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 20, 3, 5, 3.8, 0.1, 'uncommon', 20, 'grade_5_ouro_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g05_boots', 'Trono Dourado — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 7, 5, 16, 1.5, 1.1, 'uncommon', 20, 'grade_5_ouro_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Pergaminho Dourado
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g05_weapon', 'Pergaminho Dourado — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 27, 2, 1, 2.3, 0, 'uncommon', 20, 'grade_5_ouro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g05_helmet', 'Pergaminho Dourado — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 10, 13, 7, 1.1, 0.1, 'uncommon', 20, 'grade_5_ouro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g05_armor', 'Pergaminho Dourado — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 6, 17, 15, 0, 0, 'uncommon', 20, 'grade_5_ouro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g05_gloves', 'Pergaminho Dourado — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 18, 4, 3, 5.6, 0.1, 'uncommon', 20, 'grade_5_ouro_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g05_boots', 'Pergaminho Dourado — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 6, 6, 12, 2.3, 1.1, 'uncommon', 20, 'grade_5_ouro_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Mira Dourada
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g05_weapon', 'Mira Dourada — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 25, 1, 1, 3, 0, 'uncommon', 20, 'grade_5_ouro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g05_helmet', 'Mira Dourada — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 9, 10, 5, 1.5, 0.9, 'uncommon', 20, 'grade_5_ouro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g05_armor', 'Mira Dourada — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 6, 13, 11, 0, 0, 'uncommon', 20, 'grade_5_ouro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g05_gloves', 'Mira Dourada — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 16, 3, 2, 7.5, 0.9, 'uncommon', 20, 'grade_5_ouro_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g05_boots', 'Mira Dourada — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 6, 5, 8, 3, 7.2, 'uncommon', 20, 'grade_5_ouro_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Cálice Dourado
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g05_weapon', 'Cálice Dourado — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 11, 3, 1, 0.5, 0, 'uncommon', 20, 'grade_5_ouro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g05_helmet', 'Cálice Dourado — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 4, 21, 19, 0.2, 0.4, 'uncommon', 20, 'grade_5_ouro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g05_armor', 'Cálice Dourado — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 2, 27, 38, 0, 0, 'uncommon', 20, 'grade_5_ouro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g05_gloves', 'Cálice Dourado — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 7, 6, 9, 1.1, 0.4, 'uncommon', 20, 'grade_5_ouro_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g05_boots', 'Cálice Dourado — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 2, 10, 30, 0.5, 2.9, 'uncommon', 20, 'grade_5_ouro_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 6 — Rubi (Níveis 25-30) — UNCOMMON
  -- ========================================================================

    -- Paladino — Cruz Rubi
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g06_weapon', 'Cruz Rubi — Arma', '⚔️', 'Lâmina sagrada que brilha com luz celestial', 'weapon', v_paladin_id, 17, 4, 1, 0.8, 0, 'uncommon', 25, 'grade_6_rubi_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g06_helmet', 'Cruz Rubi — Capacete', '⚔️', 'Elmo que guarda a sabedoria dos antigos cavaleiros', 'helmet', v_paladin_id, 8, 21, 17, 0.4, 0.2, 'uncommon', 25, 'grade_6_rubi_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g06_armor', 'Cruz Rubi — Armadura', '⚔️', 'Armadura imbuída com proteção divina', 'armor', v_paladin_id, 5, 25, 27, 0, 0, 'uncommon', 25, 'grade_6_rubi_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g06_gloves', 'Cruz Rubi — Luvas', '⚔️', 'Luvas que canalizam o poder divino', 'gloves', v_paladin_id, 12, 8, 8, 2, 0.2, 'uncommon', 25, 'grade_6_rubi_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g06_boots', 'Cruz Rubi — Botas', '⚔️', 'Grevas que pisam o caminho da retidão', 'boots', v_paladin_id, 5, 12, 23, 0.8, 1.9, 'uncommon', 25, 'grade_6_rubi_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Fúria Rubi
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g06_weapon', 'Fúria Rubi — Arma', '🗡️', 'Arma brutal forjada em sangue e aço', 'weapon', v_warrior_id, 31, 2, 1, 1.6, 0, 'uncommon', 25, 'grade_6_rubi_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g06_helmet', 'Fúria Rubi — Capacete', '🗡️', 'Elmo marcado por cicatrizes de batalhas', 'helmet', v_warrior_id, 15, 12, 13, 0.8, 0.1, 'uncommon', 25, 'grade_6_rubi_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g06_armor', 'Fúria Rubi — Armadura', '🗡️', 'Armadura que carrega as marcas da guerra', 'armor', v_warrior_id, 10, 15, 21, 0, 0, 'uncommon', 25, 'grade_6_rubi_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g06_gloves', 'Fúria Rubi — Luvas', '🗡️', 'Luvas que esmagam ossos e escudos', 'gloves', v_warrior_id, 23, 5, 6, 4, 0.1, 'uncommon', 25, 'grade_6_rubi_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g06_boots', 'Fúria Rubi — Botas', '🗡️', 'Botas que avançam sem medo na batalha', 'boots', v_warrior_id, 10, 7, 18, 1.6, 1.2, 'uncommon', 25, 'grade_6_rubi_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Chama Rubi
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g06_weapon', 'Chama Rubi — Arma', '🔮', 'Cajado que canaliza energias arcanas', 'weapon', v_mage_id, 27, 3, 1, 2.4, 0, 'uncommon', 25, 'grade_6_rubi_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g06_helmet', 'Chama Rubi — Capacete', '🔮', 'Tiara que amplia o poder da mente', 'helmet', v_mage_id, 13, 14, 9, 1.2, 0.1, 'uncommon', 25, 'grade_6_rubi_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g06_armor', 'Chama Rubi — Armadura', '🔮', 'Vestes tecidas com fios de mana pura', 'armor', v_mage_id, 8, 17, 15, 0, 0, 'uncommon', 25, 'grade_6_rubi_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g06_gloves', 'Chama Rubi — Luvas', '🔮', 'Luvas que potencializam feitiços', 'gloves', v_mage_id, 20, 5, 5, 6, 0.1, 'uncommon', 25, 'grade_6_rubi_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g06_boots', 'Chama Rubi — Botas', '🔮', 'Botas que flutuam entre planos', 'boots', v_mage_id, 8, 8, 12, 2.4, 1.2, 'uncommon', 25, 'grade_6_rubi_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Pontaria Rubi
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g06_weapon', 'Pontaria Rubi — Arma', '🏹', 'Arco que dispara flechas infalíveis', 'weapon', v_archer_id, 25, 2, 1, 3.2, 0, 'uncommon', 25, 'grade_6_rubi_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g06_helmet', 'Pontaria Rubi — Capacete', '🏹', 'Elmo que aguça a visão do caçador', 'helmet', v_archer_id, 12, 11, 6, 1.6, 1, 'uncommon', 25, 'grade_6_rubi_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g06_armor', 'Pontaria Rubi — Armadura', '🏹', 'Gibão leve que permite movimento rápido', 'armor', v_archer_id, 8, 13, 10, 0, 0, 'uncommon', 25, 'grade_6_rubi_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g06_gloves', 'Pontaria Rubi — Luvas', '🏹', 'Luvas que estabilizam a mira', 'gloves', v_archer_id, 19, 4, 3, 8, 1, 'uncommon', 25, 'grade_6_rubi_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g06_boots', 'Pontaria Rubi — Botas', '🏹', 'Botas silenciosas para mover-se nas sombras', 'boots', v_archer_id, 8, 6, 9, 3.2, 7.7, 'uncommon', 25, 'grade_6_rubi_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Sangue Rubi
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g06_weapon', 'Sangue Rubi — Arma', '✨', 'Maça que cura tanto quanto fere', 'weapon', v_cleric_id, 10, 4, 1, 0.5, 0, 'uncommon', 25, 'grade_6_rubi_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g06_helmet', 'Sangue Rubi — Capacete', '✨', 'Auréola de fé que protege o espírito', 'helmet', v_cleric_id, 5, 23, 23, 0.2, 0.4, 'uncommon', 25, 'grade_6_rubi_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g06_armor', 'Sangue Rubi — Armadura', '✨', 'Vestes imaculadas de poder divino', 'armor', v_cleric_id, 3, 27, 38, 0, 0, 'uncommon', 25, 'grade_6_rubi_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g06_gloves', 'Sangue Rubi — Luvas', '✨', 'Luvas que canalizam energia curativa', 'gloves', v_cleric_id, 8, 8, 12, 1.2, 0.4, 'uncommon', 25, 'grade_6_rubi_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g06_boots', 'Sangue Rubi — Botas', '✨', 'Sandálias da jornada espiritual', 'boots', v_cleric_id, 3, 13, 32, 0.5, 3.1, 'uncommon', 25, 'grade_6_rubi_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 7 — Safira (Níveis 30-35) — RARE
  -- ========================================================================

    -- Paladino — Juramento Safira
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g07_weapon', 'Juramento Safira — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 17, 4, 1, 0.9, 0, 'rare', 30, 'grade_7_safira_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g07_helmet', 'Juramento Safira — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 8, 20, 17, 0.4, 0.3, 'rare', 30, 'grade_7_safira_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g07_armor', 'Juramento Safira — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 6, 25, 27, 0, 0, 'rare', 30, 'grade_7_safira_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g07_gloves', 'Juramento Safira — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 12, 9, 9, 2.1, 0.3, 'rare', 30, 'grade_7_safira_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g07_boots', 'Juramento Safira — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 6, 12, 22, 0.9, 2, 'rare', 30, 'grade_7_safira_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Ímpeto Safira
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g07_weapon', 'Ímpeto Safira — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 32, 3, 1, 1.7, 0, 'rare', 30, 'grade_7_safira_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g07_helmet', 'Ímpeto Safira — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 15, 12, 13, 0.9, 0.2, 'rare', 30, 'grade_7_safira_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g07_armor', 'Ímpeto Safira — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 11, 15, 21, 0, 0, 'rare', 30, 'grade_7_safira_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g07_gloves', 'Ímpeto Safira — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 23, 5, 7, 4.3, 0.2, 'rare', 30, 'grade_7_safira_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g07_boots', 'Ímpeto Safira — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 11, 7, 17, 1.7, 1.2, 'rare', 30, 'grade_7_safira_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Visão Safira
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g07_weapon', 'Visão Safira — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 27, 3, 1, 2.6, 0, 'rare', 30, 'grade_7_safira_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g07_helmet', 'Visão Safira — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 13, 14, 9, 1.3, 0.2, 'rare', 30, 'grade_7_safira_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g07_armor', 'Visão Safira — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 9, 17, 15, 0, 0, 'rare', 30, 'grade_7_safira_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g07_gloves', 'Visão Safira — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 20, 6, 5, 6.4, 0.2, 'rare', 30, 'grade_7_safira_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g07_boots', 'Visão Safira — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 9, 8, 12, 2.6, 1.2, 'rare', 30, 'grade_7_safira_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Precisão Safira
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g07_weapon', 'Precisão Safira — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 25, 2, 1, 3.4, 0, 'rare', 30, 'grade_7_safira_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g07_helmet', 'Precisão Safira — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 12, 10, 6, 1.7, 1, 'rare', 30, 'grade_7_safira_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g07_armor', 'Precisão Safira — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 9, 13, 11, 0, 0, 'rare', 30, 'grade_7_safira_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g07_gloves', 'Precisão Safira — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 18, 4, 4, 8.5, 1, 'rare', 30, 'grade_7_safira_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g07_boots', 'Precisão Safira — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 9, 6, 8, 3.4, 8.2, 'rare', 30, 'grade_7_safira_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Cura Safira
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g07_weapon', 'Cura Safira — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 11, 5, 1, 0.5, 0, 'rare', 30, 'grade_7_safira_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g07_helmet', 'Cura Safira — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 5, 22, 23, 0.3, 0.4, 'rare', 30, 'grade_7_safira_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g07_armor', 'Cura Safira — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 4, 27, 38, 0, 0, 'rare', 30, 'grade_7_safira_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g07_gloves', 'Cura Safira — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 8, 9, 13, 1.3, 0.4, 'rare', 30, 'grade_7_safira_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g07_boots', 'Cura Safira — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 4, 13, 31, 0.5, 3.3, 'rare', 30, 'grade_7_safira_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 8 — Jade (Níveis 35-40) — RARE
  -- ========================================================================

    -- Paladino — Equilíbrio de Jade
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g08_weapon', 'Equilíbrio de Jade — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 21, 4, 1, 0.9, 0, 'rare', 35, 'grade_8_jade_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g08_helmet', 'Equilíbrio de Jade — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 8, 22, 16, 0.5, 0.3, 'rare', 35, 'grade_8_jade_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g08_armor', 'Equilíbrio de Jade — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 5, 31, 34, 0, 0, 'rare', 35, 'grade_8_jade_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g08_gloves', 'Equilíbrio de Jade — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 12, 8, 9, 2.3, 0.3, 'rare', 35, 'grade_8_jade_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g08_boots', 'Equilíbrio de Jade — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 5, 11, 23, 0.9, 2.2, 'rare', 35, 'grade_8_jade_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Força de Jade
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g08_weapon', 'Força de Jade — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 39, 3, 1, 1.8, 0, 'rare', 35, 'grade_8_jade_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g08_helmet', 'Força de Jade — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 14, 13, 12, 0.9, 0.2, 'rare', 35, 'grade_8_jade_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g08_armor', 'Força de Jade — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 10, 18, 26, 0, 0, 'rare', 35, 'grade_8_jade_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g08_gloves', 'Força de Jade — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 22, 5, 7, 4.5, 0.2, 'rare', 35, 'grade_8_jade_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g08_boots', 'Força de Jade — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 10, 7, 18, 1.8, 1.3, 'rare', 35, 'grade_8_jade_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Sabedoria de Jade
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g08_weapon', 'Sabedoria de Jade — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 34, 3, 1, 2.7, 0, 'rare', 35, 'grade_8_jade_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g08_helmet', 'Sabedoria de Jade — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 12, 14, 9, 1.4, 0.2, 'rare', 35, 'grade_8_jade_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g08_armor', 'Sabedoria de Jade — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 9, 21, 18, 0, 0, 'rare', 35, 'grade_8_jade_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g08_gloves', 'Sabedoria de Jade — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 19, 5, 5, 6.8, 0.2, 'rare', 35, 'grade_8_jade_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g08_boots', 'Sabedoria de Jade — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 9, 8, 13, 2.7, 1.3, 'rare', 35, 'grade_8_jade_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Leveza de Jade
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g08_weapon', 'Leveza de Jade — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 31, 2, 1, 3.6, 0, 'rare', 35, 'grade_8_jade_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g08_helmet', 'Leveza de Jade — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 11, 11, 6, 1.8, 1.1, 'rare', 35, 'grade_8_jade_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g08_armor', 'Leveza de Jade — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 8, 16, 13, 0, 0, 'rare', 35, 'grade_8_jade_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g08_gloves', 'Leveza de Jade — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 18, 4, 3, 9, 1.1, 'rare', 35, 'grade_8_jade_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g08_boots', 'Leveza de Jade — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 8, 6, 9, 3.6, 8.6, 'rare', 35, 'grade_8_jade_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Paz de Jade
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g08_weapon', 'Paz de Jade — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 13, 5, 1, 0.5, 0, 'rare', 35, 'grade_8_jade_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g08_helmet', 'Paz de Jade — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 5, 23, 22, 0.3, 0.4, 'rare', 35, 'grade_8_jade_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g08_armor', 'Paz de Jade — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 3, 34, 47, 0, 0, 'rare', 35, 'grade_8_jade_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g08_gloves', 'Paz de Jade — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 7, 9, 12, 1.3, 0.4, 'rare', 35, 'grade_8_jade_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g08_boots', 'Paz de Jade — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 3, 12, 32, 0.5, 3.5, 'rare', 35, 'grade_8_jade_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 9 — Obsidiana (Níveis 40-45) — RARE
  -- ========================================================================

    -- Paladino — Julgamento Obsidiano
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g09_weapon', 'Julgamento Obsidiano — Arma', '⚔️', 'Lâmina sagrada que brilha com luz celestial', 'weapon', v_paladin_id, 28, 4, 1, 1, 0, 'rare', 40, 'grade_9_obsidiana_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g09_helmet', 'Julgamento Obsidiano — Capacete', '⚔️', 'Elmo que guarda a sabedoria dos antigos cavaleiros', 'helmet', v_paladin_id, 8, 28, 18, 0.5, 0.3, 'rare', 40, 'grade_9_obsidiana_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g09_armor', 'Julgamento Obsidiano — Armadura', '⚔️', 'Armadura imbuída com proteção divina', 'armor', v_paladin_id, 5, 42, 46, 0, 0, 'rare', 40, 'grade_9_obsidiana_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g09_gloves', 'Julgamento Obsidiano — Luvas', '⚔️', 'Luvas que canalizam o poder divino', 'gloves', v_paladin_id, 15, 8, 9, 2.4, 0.3, 'rare', 40, 'grade_9_obsidiana_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g09_boots', 'Julgamento Obsidiano — Botas', '⚔️', 'Grevas que pisam o caminho da retidão', 'boots', v_paladin_id, 5, 12, 31, 1, 2.3, 'rare', 40, 'grade_9_obsidiana_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Fúria Obsidiana
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g09_weapon', 'Fúria Obsidiana — Arma', '🗡️', 'Arma brutal forjada em sangue e aço', 'weapon', v_warrior_id, 53, 2, 1, 1.9, 0, 'rare', 40, 'grade_9_obsidiana_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g09_helmet', 'Fúria Obsidiana — Capacete', '🗡️', 'Elmo marcado por cicatrizes de batalhas', 'helmet', v_warrior_id, 15, 16, 14, 1, 0.2, 'rare', 40, 'grade_9_obsidiana_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g09_armor', 'Fúria Obsidiana — Armadura', '🗡️', 'Armadura que carrega as marcas da guerra', 'armor', v_warrior_id, 10, 25, 35, 0, 0, 'rare', 40, 'grade_9_obsidiana_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g09_gloves', 'Fúria Obsidiana — Luvas', '🗡️', 'Luvas que esmagam ossos e escudos', 'gloves', v_warrior_id, 28, 5, 7, 4.8, 0.2, 'rare', 40, 'grade_9_obsidiana_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g09_boots', 'Fúria Obsidiana — Botas', '🗡️', 'Botas que avançam sem medo na batalha', 'boots', v_warrior_id, 10, 7, 23, 1.9, 1.4, 'rare', 40, 'grade_9_obsidiana_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Abismo Obsidiano
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g09_weapon', 'Abismo Obsidiano — Arma', '🔮', 'Cajado que canaliza energias arcanas', 'weapon', v_mage_id, 46, 3, 1, 2.9, 0, 'rare', 40, 'grade_9_obsidiana_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g09_helmet', 'Abismo Obsidiano — Capacete', '🔮', 'Tiara que amplia o poder da mente', 'helmet', v_mage_id, 13, 19, 10, 1.4, 0.2, 'rare', 40, 'grade_9_obsidiana_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g09_armor', 'Abismo Obsidiano — Armadura', '🔮', 'Vestes tecidas com fios de mana pura', 'armor', v_mage_id, 9, 28, 25, 0, 0, 'rare', 40, 'grade_9_obsidiana_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g09_gloves', 'Abismo Obsidiano — Luvas', '🔮', 'Luvas que potencializam feitiços', 'gloves', v_mage_id, 24, 5, 5, 7.1, 0.2, 'rare', 40, 'grade_9_obsidiana_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g09_boots', 'Abismo Obsidiano — Botas', '🔮', 'Botas que flutuam entre planos', 'boots', v_mage_id, 9, 8, 16, 2.9, 1.4, 'rare', 40, 'grade_9_obsidiana_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Sombra Obsidiana
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g09_weapon', 'Sombra Obsidiana — Arma', '🏹', 'Arco que dispara flechas infalíveis', 'weapon', v_archer_id, 42, 2, 1, 3.8, 0, 'rare', 40, 'grade_9_obsidiana_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g09_helmet', 'Sombra Obsidiana — Capacete', '🏹', 'Elmo que aguça a visão do caçador', 'helmet', v_archer_id, 12, 14, 7, 1.9, 1.1, 'rare', 40, 'grade_9_obsidiana_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g09_armor', 'Sombra Obsidiana — Armadura', '🏹', 'Gibão leve que permite movimento rápido', 'armor', v_archer_id, 8, 21, 18, 0, 0, 'rare', 40, 'grade_9_obsidiana_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g09_gloves', 'Sombra Obsidiana — Luvas', '🏹', 'Luvas que estabilizam a mira', 'gloves', v_archer_id, 22, 4, 3, 9.5, 1.1, 'rare', 40, 'grade_9_obsidiana_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g09_boots', 'Sombra Obsidiana — Botas', '🏹', 'Botas silenciosas para mover-se nas sombras', 'boots', v_archer_id, 8, 6, 12, 3.8, 9.1, 'rare', 40, 'grade_9_obsidiana_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Luto Obsidiano
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g09_weapon', 'Luto Obsidiano — Arma', '✨', 'Maça que cura tanto quanto fere', 'weapon', v_cleric_id, 18, 4, 1, 0.6, 0, 'rare', 40, 'grade_9_obsidiana_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g09_helmet', 'Luto Obsidiano — Capacete', '✨', 'Auréola de fé que protege o espírito', 'helmet', v_cleric_id, 5, 31, 25, 0.3, 0.5, 'rare', 40, 'grade_9_obsidiana_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g09_armor', 'Luto Obsidiano — Armadura', '✨', 'Vestes imaculadas de poder divino', 'armor', v_cleric_id, 3, 46, 64, 0, 0, 'rare', 40, 'grade_9_obsidiana_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g09_gloves', 'Luto Obsidiano — Luvas', '✨', 'Luvas que canalizam energia curativa', 'gloves', v_cleric_id, 9, 9, 12, 1.4, 0.5, 'rare', 40, 'grade_9_obsidiana_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g09_boots', 'Luto Obsidiano — Botas', '✨', 'Sandálias da jornada espiritual', 'boots', v_cleric_id, 3, 13, 42, 0.6, 3.6, 'rare', 40, 'grade_9_obsidiana_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 10 — Cristal (Níveis 45-50) — EPIC
  -- ========================================================================

    -- Paladino — Luz Cristalina
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g10_weapon', 'Luz Cristalina — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 34, 5, 1, 1, 0, 'epic', 45, 'grade_10_cristal_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g10_helmet', 'Luz Cristalina — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 10, 37, 24, 0.5, 0.3, 'epic', 45, 'grade_10_cristal_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g10_armor', 'Luz Cristalina — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 7, 50, 55, 0, 0, 'epic', 45, 'grade_10_cristal_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g10_gloves', 'Luz Cristalina — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 20, 10, 11, 2.5, 0.3, 'epic', 45, 'grade_10_cristal_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g10_boots', 'Luz Cristalina — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 7, 16, 40, 1, 2.4, 'epic', 45, 'grade_10_cristal_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Golpe Cristalino
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g10_weapon', 'Golpe Cristalino — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 63, 3, 1, 2, 0, 'epic', 45, 'grade_10_cristal_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g10_helmet', 'Golpe Cristalino — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 20, 21, 19, 1, 0.2, 'epic', 45, 'grade_10_cristal_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g10_armor', 'Golpe Cristalino — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 12, 29, 42, 0, 0, 'epic', 45, 'grade_10_cristal_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g10_gloves', 'Golpe Cristalino — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 37, 6, 8, 5, 0.2, 'epic', 45, 'grade_10_cristal_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g10_boots', 'Golpe Cristalino — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 12, 9, 31, 2, 1.4, 'epic', 45, 'grade_10_cristal_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Prisma Cristalino
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g10_weapon', 'Prisma Cristalino — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 55, 3, 1, 3, 0, 'epic', 45, 'grade_10_cristal_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g10_helmet', 'Prisma Cristalino — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 17, 25, 13, 1.5, 0.2, 'epic', 45, 'grade_10_cristal_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g10_armor', 'Prisma Cristalino — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 11, 34, 29, 0, 0, 'epic', 45, 'grade_10_cristal_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g10_gloves', 'Prisma Cristalino — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 32, 7, 6, 7.5, 0.2, 'epic', 45, 'grade_10_cristal_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g10_boots', 'Prisma Cristalino — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 11, 10, 21, 3, 1.4, 'epic', 45, 'grade_10_cristal_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Mira Cristalina
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g10_weapon', 'Mira Cristalina — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 50, 2, 1, 4, 0, 'epic', 45, 'grade_10_cristal_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g10_helmet', 'Mira Cristalina — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 16, 18, 9, 2, 1.2, 'epic', 45, 'grade_10_cristal_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g10_armor', 'Mira Cristalina — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 10, 25, 21, 0, 0, 'epic', 45, 'grade_10_cristal_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g10_gloves', 'Mira Cristalina — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 29, 5, 4, 10, 1.2, 'epic', 45, 'grade_10_cristal_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g10_boots', 'Mira Cristalina — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 10, 8, 15, 4, 9.6, 'epic', 45, 'grade_10_cristal_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Pureza Cristalina
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g10_weapon', 'Pureza Cristalina — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 21, 5, 1, 0.6, 0, 'epic', 45, 'grade_10_cristal_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g10_helmet', 'Pureza Cristalina — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 7, 40, 33, 0.3, 0.5, 'epic', 45, 'grade_10_cristal_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g10_armor', 'Pureza Cristalina — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 4, 55, 76, 0, 0, 'epic', 45, 'grade_10_cristal_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g10_gloves', 'Pureza Cristalina — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 12, 11, 15, 1.5, 0.5, 'epic', 45, 'grade_10_cristal_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g10_boots', 'Pureza Cristalina — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 4, 17, 55, 0.6, 3.8, 'epic', 45, 'grade_10_cristal_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 11 — Ametista (Níveis 50-55) — EPIC
  -- ========================================================================

    -- Paladino — Véu de Ametista
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g11_weapon', 'Véu de Ametista — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 33, 6, 1, 1.1, 0, 'epic', 50, 'grade_11_ametista_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g11_helmet', 'Véu de Ametista — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 13, 41, 30, 0.5, 0.3, 'epic', 50, 'grade_11_ametista_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g11_armor', 'Véu de Ametista — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 9, 50, 54, 0, 0, 'epic', 50, 'grade_11_ametista_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g11_gloves', 'Véu de Ametista — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 23, 13, 14, 2.6, 0.3, 'epic', 50, 'grade_11_ametista_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g11_boots', 'Véu de Ametista — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 9, 20, 44, 1.1, 2.5, 'epic', 50, 'grade_11_ametista_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Fúria de Ametista
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g11_weapon', 'Fúria de Ametista — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 62, 4, 1, 2.1, 0, 'epic', 50, 'grade_11_ametista_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g11_helmet', 'Fúria de Ametista — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 25, 24, 23, 1.1, 0.2, 'epic', 50, 'grade_11_ametista_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g11_armor', 'Fúria de Ametista — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 16, 29, 41, 0, 0, 'epic', 50, 'grade_11_ametista_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g11_gloves', 'Fúria de Ametista — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 43, 8, 11, 5.3, 0.2, 'epic', 50, 'grade_11_ametista_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g11_boots', 'Fúria de Ametista — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 16, 12, 34, 2.1, 1.5, 'epic', 50, 'grade_11_ametista_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Mistério de Ametista
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g11_weapon', 'Mistério de Ametista — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 54, 4, 1, 3.2, 0, 'epic', 50, 'grade_11_ametista_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g11_helmet', 'Mistério de Ametista — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 22, 27, 16, 1.6, 0.2, 'epic', 50, 'grade_11_ametista_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g11_armor', 'Mistério de Ametista — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 14, 33, 29, 0, 0, 'epic', 50, 'grade_11_ametista_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g11_gloves', 'Mistério de Ametista — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 37, 9, 8, 7.9, 0.2, 'epic', 50, 'grade_11_ametista_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g11_boots', 'Mistério de Ametista — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 14, 13, 24, 3.2, 1.5, 'epic', 50, 'grade_11_ametista_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Sombra de Ametista
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g11_weapon', 'Sombra de Ametista — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 50, 3, 1, 4.2, 0, 'epic', 50, 'grade_11_ametista_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g11_helmet', 'Sombra de Ametista — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 20, 20, 11, 2.1, 1.3, 'epic', 50, 'grade_11_ametista_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g11_armor', 'Sombra de Ametista — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 13, 25, 21, 0, 0, 'epic', 50, 'grade_11_ametista_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g11_gloves', 'Sombra de Ametista — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 34, 6, 5, 10.5, 1.3, 'epic', 50, 'grade_11_ametista_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g11_boots', 'Sombra de Ametista — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 13, 10, 17, 4.2, 10.1, 'epic', 50, 'grade_11_ametista_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Fé de Ametista
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g11_weapon', 'Fé de Ametista — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 21, 7, 1, 0.6, 0, 'epic', 50, 'grade_11_ametista_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g11_helmet', 'Fé de Ametista — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 8, 44, 41, 0.3, 0.5, 'epic', 50, 'grade_11_ametista_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g11_armor', 'Fé de Ametista — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 5, 54, 74, 0, 0, 'epic', 50, 'grade_11_ametista_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g11_gloves', 'Fé de Ametista — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 14, 14, 19, 1.6, 0.5, 'epic', 50, 'grade_11_ametista_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g11_boots', 'Fé de Ametista — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 5, 22, 61, 0.6, 4, 'epic', 50, 'grade_11_ametista_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 12 — Diamante (Níveis 55-60) — EPIC
  -- ========================================================================

    -- Paladino — Muralha de Diamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g12_weapon', 'Muralha de Diamante — Arma', '⚔️', 'Lâmina sagrada que brilha com luz celestial', 'weapon', v_paladin_id, 30, 7, 1, 1.1, 0, 'epic', 55, 'grade_12_diamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g12_helmet', 'Muralha de Diamante — Capacete', '⚔️', 'Elmo que guarda a sabedoria dos antigos cavaleiros', 'helmet', v_paladin_id, 15, 38, 31, 0.6, 0.3, 'epic', 55, 'grade_12_diamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g12_armor', 'Muralha de Diamante — Armadura', '⚔️', 'Armadura imbuída com proteção divina', 'armor', v_paladin_id, 10, 44, 48, 0, 0, 'epic', 55, 'grade_12_diamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g12_gloves', 'Muralha de Diamante — Luvas', '⚔️', 'Luvas que canalizam o poder divino', 'gloves', v_paladin_id, 22, 15, 16, 2.8, 0.3, 'epic', 55, 'grade_12_diamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g12_boots', 'Muralha de Diamante — Botas', '⚔️', 'Grevas que pisam o caminho da retidão', 'boots', v_paladin_id, 10, 22, 41, 1.1, 2.6, 'epic', 55, 'grade_12_diamante_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Punho de Diamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g12_weapon', 'Punho de Diamante — Arma', '🗡️', 'Arma brutal forjada em sangue e aço', 'weapon', v_warrior_id, 56, 4, 1, 2.2, 0, 'epic', 55, 'grade_12_diamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g12_helmet', 'Punho de Diamante — Capacete', '🗡️', 'Elmo marcado por cicatrizes de batalhas', 'helmet', v_warrior_id, 27, 22, 24, 1.1, 0.2, 'epic', 55, 'grade_12_diamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g12_armor', 'Punho de Diamante — Armadura', '🗡️', 'Armadura que carrega as marcas da guerra', 'armor', v_warrior_id, 19, 26, 37, 0, 0, 'epic', 55, 'grade_12_diamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g12_gloves', 'Punho de Diamante — Luvas', '🗡️', 'Luvas que esmagam ossos e escudos', 'gloves', v_warrior_id, 42, 9, 12, 5.5, 0.2, 'epic', 55, 'grade_12_diamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g12_boots', 'Punho de Diamante — Botas', '🗡️', 'Botas que avançam sem medo na batalha', 'boots', v_warrior_id, 19, 13, 31, 2.2, 1.6, 'epic', 55, 'grade_12_diamante_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Estilhaços de Diamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g12_weapon', 'Estilhaços de Diamante — Arma', '🔮', 'Cajado que canaliza energias arcanas', 'weapon', v_mage_id, 48, 5, 1, 3.3, 0, 'epic', 55, 'grade_12_diamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g12_helmet', 'Estilhaços de Diamante — Capacete', '🔮', 'Tiara que amplia o poder da mente', 'helmet', v_mage_id, 24, 25, 16, 1.7, 0.2, 'epic', 55, 'grade_12_diamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g12_armor', 'Estilhaços de Diamante — Armadura', '🔮', 'Vestes tecidas com fios de mana pura', 'armor', v_mage_id, 16, 30, 26, 0, 0, 'epic', 55, 'grade_12_diamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g12_gloves', 'Estilhaços de Diamante — Luvas', '🔮', 'Luvas que potencializam feitiços', 'gloves', v_mage_id, 36, 10, 9, 8.3, 0.2, 'epic', 55, 'grade_12_diamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g12_boots', 'Estilhaços de Diamante — Botas', '🔮', 'Botas que flutuam entre planos', 'boots', v_mage_id, 16, 15, 22, 3.3, 1.6, 'epic', 55, 'grade_12_diamante_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Olho de Diamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g12_weapon', 'Olho de Diamante — Arma', '🏹', 'Arco que dispara flechas infalíveis', 'weapon', v_archer_id, 44, 4, 1, 4.4, 0, 'epic', 55, 'grade_12_diamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g12_helmet', 'Olho de Diamante — Capacete', '🏹', 'Elmo que aguça a visão do caçador', 'helmet', v_archer_id, 22, 19, 12, 2.2, 1.3, 'epic', 55, 'grade_12_diamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g12_armor', 'Olho de Diamante — Armadura', '🏹', 'Gibão leve que permite movimento rápido', 'armor', v_archer_id, 15, 22, 19, 0, 0, 'epic', 55, 'grade_12_diamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g12_gloves', 'Olho de Diamante — Luvas', '🏹', 'Luvas que estabilizam a mira', 'gloves', v_archer_id, 33, 7, 6, 11, 1.3, 'epic', 55, 'grade_12_diamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g12_boots', 'Olho de Diamante — Botas', '🏹', 'Botas silenciosas para mover-se nas sombras', 'boots', v_archer_id, 15, 11, 16, 4.4, 10.6, 'epic', 55, 'grade_12_diamante_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Altar de Diamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g12_weapon', 'Altar de Diamante — Arma', '✨', 'Maça que cura tanto quanto fere', 'weapon', v_cleric_id, 19, 8, 1, 0.7, 0, 'epic', 55, 'grade_12_diamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g12_helmet', 'Altar de Diamante — Capacete', '✨', 'Auréola de fé que protege o espírito', 'helmet', v_cleric_id, 9, 41, 42, 0.3, 0.5, 'epic', 55, 'grade_12_diamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g12_armor', 'Altar de Diamante — Armadura', '✨', 'Vestes imaculadas de poder divino', 'armor', v_cleric_id, 6, 48, 67, 0, 0, 'epic', 55, 'grade_12_diamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g12_gloves', 'Altar de Diamante — Luvas', '✨', 'Luvas que canalizam energia curativa', 'gloves', v_cleric_id, 14, 16, 22, 1.7, 0.5, 'epic', 55, 'grade_12_diamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g12_boots', 'Altar de Diamante — Botas', '✨', 'Sandálias da jornada espiritual', 'boots', v_cleric_id, 6, 24, 57, 0.7, 4.2, 'epic', 55, 'grade_12_diamante_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 13 — Mitril (Níveis 60-65) — LEGENDARY
  -- ========================================================================

    -- Paladino — Armadura Mitril
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g13_weapon', 'Armadura Mitril — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 31, 8, 1, 1.2, 0, 'legendary', 60, 'grade_13_mitril_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g13_helmet', 'Armadura Mitril — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 13, 34, 27, 0.6, 0.3, 'legendary', 60, 'grade_13_mitril_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g13_armor', 'Armadura Mitril — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 10, 46, 50, 0, 0, 'legendary', 60, 'grade_13_mitril_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g13_gloves', 'Armadura Mitril — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 20, 14, 16, 2.9, 0.3, 'legendary', 60, 'grade_13_mitril_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g13_boots', 'Armadura Mitril — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 10, 20, 37, 1.2, 2.8, 'legendary', 60, 'grade_13_mitril_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Lâmina Mitril
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g13_weapon', 'Lâmina Mitril — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 58, 4, 1, 2.3, 0, 'legendary', 60, 'grade_13_mitril_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g13_helmet', 'Lâmina Mitril — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 25, 20, 21, 1.2, 0.2, 'legendary', 60, 'grade_13_mitril_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g13_armor', 'Lâmina Mitril — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 18, 27, 38, 0, 0, 'legendary', 60, 'grade_13_mitril_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g13_gloves', 'Lâmina Mitril — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 37, 8, 12, 5.8, 0.2, 'legendary', 60, 'grade_13_mitril_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g13_boots', 'Lâmina Mitril — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 18, 12, 29, 2.3, 1.7, 'legendary', 60, 'grade_13_mitril_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Tecido Mitril
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g13_weapon', 'Tecido Mitril — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 50, 5, 1, 3.5, 0, 'legendary', 60, 'grade_13_mitril_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g13_helmet', 'Tecido Mitril — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 22, 23, 15, 1.7, 0.2, 'legendary', 60, 'grade_13_mitril_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g13_armor', 'Tecido Mitril — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 16, 31, 27, 0, 0, 'legendary', 60, 'grade_13_mitril_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g13_gloves', 'Tecido Mitril — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 32, 10, 8, 8.6, 0.2, 'legendary', 60, 'grade_13_mitril_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g13_boots', 'Tecido Mitril — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 16, 13, 20, 3.5, 1.7, 'legendary', 60, 'grade_13_mitril_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Arco Mitril
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g13_weapon', 'Arco Mitril — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 46, 4, 1, 4.6, 0, 'legendary', 60, 'grade_13_mitril_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g13_helmet', 'Arco Mitril — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 20, 17, 11, 2.3, 1.4, 'legendary', 60, 'grade_13_mitril_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g13_armor', 'Arco Mitril — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 14, 23, 19, 0, 0, 'legendary', 60, 'grade_13_mitril_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g13_gloves', 'Arco Mitril — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 30, 7, 6, 11.5, 1.4, 'legendary', 60, 'grade_13_mitril_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g13_boots', 'Arco Mitril — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 14, 10, 14, 4.6, 11, 'legendary', 60, 'grade_13_mitril_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Cálice Mitril
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g13_weapon', 'Cálice Mitril — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 19, 8, 1, 0.7, 0, 'legendary', 60, 'grade_13_mitril_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g13_helmet', 'Cálice Mitril — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 8, 37, 38, 0.3, 0.6, 'legendary', 60, 'grade_13_mitril_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g13_armor', 'Cálice Mitril — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 6, 50, 69, 0, 0, 'legendary', 60, 'grade_13_mitril_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g13_gloves', 'Cálice Mitril — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 12, 16, 22, 1.7, 0.6, 'legendary', 60, 'grade_13_mitril_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g13_boots', 'Cálice Mitril — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 6, 22, 52, 0.7, 4.4, 'legendary', 60, 'grade_13_mitril_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 14 — Adamante (Níveis 65-70) — LEGENDARY
  -- ========================================================================

    -- Paladino — Escudo Adamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g14_weapon', 'Escudo Adamante — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 39, 7, 1, 1.2, 0, 'legendary', 65, 'grade_14_adamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g14_helmet', 'Escudo Adamante — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 12, 39, 26, 0.6, 0.4, 'legendary', 65, 'grade_14_adamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g14_armor', 'Escudo Adamante — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 9, 59, 63, 0, 0, 'legendary', 65, 'grade_14_adamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g14_gloves', 'Escudo Adamante — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 21, 13, 14, 3, 0.4, 'legendary', 65, 'grade_14_adamante_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g14_boots', 'Escudo Adamante — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 9, 18, 42, 1.2, 2.9, 'legendary', 65, 'grade_14_adamante_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Martelo Adamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g14_weapon', 'Martelo Adamante — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 73, 4, 1, 2.4, 0, 'legendary', 65, 'grade_14_adamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g14_helmet', 'Martelo Adamante — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 23, 23, 20, 1.2, 0.2, 'legendary', 65, 'grade_14_adamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g14_armor', 'Martelo Adamante — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 16, 34, 49, 0, 0, 'legendary', 65, 'grade_14_adamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g14_gloves', 'Martelo Adamante — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 39, 7, 11, 6, 0.2, 'legendary', 65, 'grade_14_adamante_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g14_boots', 'Martelo Adamante — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 16, 11, 32, 2.4, 1.7, 'legendary', 65, 'grade_14_adamante_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Selos Adamantes
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g14_weapon', 'Selos Adamantes — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 63, 4, 1, 3.6, 0, 'legendary', 65, 'grade_14_adamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g14_helmet', 'Selos Adamantes — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 20, 26, 14, 1.8, 0.2, 'legendary', 65, 'grade_14_adamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g14_armor', 'Selos Adamantes — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 14, 39, 34, 0, 0, 'legendary', 65, 'grade_14_adamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g14_gloves', 'Selos Adamantes — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 34, 9, 7, 9, 0.2, 'legendary', 65, 'grade_14_adamante_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g14_boots', 'Selos Adamantes — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 14, 12, 23, 3.6, 1.7, 'legendary', 65, 'grade_14_adamante_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Flecha Adamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g14_weapon', 'Flecha Adamante — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 59, 3, 1, 4.8, 0, 'legendary', 65, 'grade_14_adamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g14_helmet', 'Flecha Adamante — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 18, 19, 10, 2.4, 1.4, 'legendary', 65, 'grade_14_adamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g14_armor', 'Flecha Adamante — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 13, 29, 24, 0, 0, 'legendary', 65, 'grade_14_adamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g14_gloves', 'Flecha Adamante — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 31, 6, 5, 12, 1.4, 'legendary', 65, 'grade_14_adamante_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g14_boots', 'Flecha Adamante — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 13, 9, 16, 4.8, 11.5, 'legendary', 65, 'grade_14_adamante_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Relicário Adamante
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g14_weapon', 'Relicário Adamante — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 24, 7, 1, 0.7, 0, 'legendary', 65, 'grade_14_adamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g14_helmet', 'Relicário Adamante — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 8, 42, 37, 0.4, 0.6, 'legendary', 65, 'grade_14_adamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g14_armor', 'Relicário Adamante — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 5, 63, 88, 0, 0, 'legendary', 65, 'grade_14_adamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g14_gloves', 'Relicário Adamante — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 13, 14, 19, 1.8, 0.6, 'legendary', 65, 'grade_14_adamante_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g14_boots', 'Relicário Adamante — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 5, 20, 58, 0.7, 4.6, 'legendary', 65, 'grade_14_adamante_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 15 — Oricalco (Níveis 70-75) — LEGENDARY
  -- ========================================================================

    -- Paladino — Alma de Oricalco
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g15_weapon', 'Alma de Oricalco — Arma', '⚔️', 'Lâmina sagrada que brilha com luz celestial', 'weapon', v_paladin_id, 49, 7, 1, 1.3, 0, 'legendary', 70, 'grade_15_oricalco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g15_helmet', 'Alma de Oricalco — Capacete', '⚔️', 'Elmo que guarda a sabedoria dos antigos cavaleiros', 'helmet', v_paladin_id, 14, 50, 32, 0.6, 0.4, 'legendary', 70, 'grade_15_oricalco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g15_armor', 'Alma de Oricalco — Armadura', '⚔️', 'Armadura imbuída com proteção divina', 'armor', v_paladin_id, 9, 73, 79, 0, 0, 'legendary', 70, 'grade_15_oricalco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g15_gloves', 'Alma de Oricalco — Luvas', '⚔️', 'Luvas que canalizam o poder divino', 'gloves', v_paladin_id, 26, 13, 14, 3.1, 0.4, 'legendary', 70, 'grade_15_oricalco_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g15_boots', 'Alma de Oricalco — Botas', '⚔️', 'Grevas que pisam o caminho da retidão', 'boots', v_paladin_id, 9, 21, 54, 1.3, 3, 'legendary', 70, 'grade_15_oricalco_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Fúria de Oricalco
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g15_weapon', 'Fúria de Oricalco — Arma', '🗡️', 'Arma brutal forjada em sangue e aço', 'weapon', v_warrior_id, 91, 4, 1, 2.5, 0, 'legendary', 70, 'grade_15_oricalco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g15_helmet', 'Fúria de Oricalco — Capacete', '🗡️', 'Elmo marcado por cicatrizes de batalhas', 'helmet', v_warrior_id, 26, 29, 25, 1.3, 0.2, 'legendary', 70, 'grade_15_oricalco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g15_armor', 'Fúria de Oricalco — Armadura', '🗡️', 'Armadura que carrega as marcas da guerra', 'armor', v_warrior_id, 17, 43, 61, 0, 0, 'legendary', 70, 'grade_15_oricalco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g15_gloves', 'Fúria de Oricalco — Luvas', '🗡️', 'Luvas que esmagam ossos e escudos', 'gloves', v_warrior_id, 49, 8, 11, 6.3, 0.2, 'legendary', 70, 'grade_15_oricalco_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g15_boots', 'Fúria de Oricalco — Botas', '🗡️', 'Botas que avançam sem medo na batalha', 'boots', v_warrior_id, 17, 12, 42, 2.5, 1.8, 'legendary', 70, 'grade_15_oricalco_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Energia de Oricalco
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g15_weapon', 'Energia de Oricalco — Arma', '🔮', 'Cajado que canaliza energias arcanas', 'weapon', v_mage_id, 79, 4, 1, 3.8, 0, 'legendary', 70, 'grade_15_oricalco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g15_helmet', 'Energia de Oricalco — Capacete', '🔮', 'Tiara que amplia o poder da mente', 'helmet', v_mage_id, 23, 34, 17, 1.9, 0.2, 'legendary', 70, 'grade_15_oricalco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g15_armor', 'Energia de Oricalco — Armadura', '🔮', 'Vestes tecidas com fios de mana pura', 'armor', v_mage_id, 14, 49, 43, 0, 0, 'legendary', 70, 'grade_15_oricalco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g15_gloves', 'Energia de Oricalco — Luvas', '🔮', 'Luvas que potencializam feitiços', 'gloves', v_mage_id, 43, 9, 8, 9.4, 0.2, 'legendary', 70, 'grade_15_oricalco_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g15_boots', 'Energia de Oricalco — Botas', '🔮', 'Botas que flutuam entre planos', 'boots', v_mage_id, 14, 14, 29, 3.8, 1.8, 'legendary', 70, 'grade_15_oricalco_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Mira de Oricalco
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g15_weapon', 'Mira de Oricalco — Arma', '🏹', 'Arco que dispara flechas infalíveis', 'weapon', v_archer_id, 73, 3, 1, 5, 0, 'legendary', 70, 'grade_15_oricalco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g15_helmet', 'Mira de Oricalco — Capacete', '🏹', 'Elmo que aguça a visão do caçador', 'helmet', v_archer_id, 21, 25, 12, 2.5, 1.5, 'legendary', 70, 'grade_15_oricalco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g15_armor', 'Mira de Oricalco — Armadura', '🏹', 'Gibão leve que permite movimento rápido', 'armor', v_archer_id, 13, 37, 30, 0, 0, 'legendary', 70, 'grade_15_oricalco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g15_gloves', 'Mira de Oricalco — Luvas', '🏹', 'Luvas que estabilizam a mira', 'gloves', v_archer_id, 39, 7, 6, 12.5, 1.5, 'legendary', 70, 'grade_15_oricalco_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g15_boots', 'Mira de Oricalco — Botas', '🏹', 'Botas silenciosas para mover-se nas sombras', 'boots', v_archer_id, 13, 10, 21, 5, 12, 'legendary', 70, 'grade_15_oricalco_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Sopro de Oricalco
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g15_weapon', 'Sopro de Oricalco — Arma', '✨', 'Maça que cura tanto quanto fere', 'weapon', v_cleric_id, 30, 7, 1, 0.8, 0, 'legendary', 70, 'grade_15_oricalco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g15_helmet', 'Sopro de Oricalco — Capacete', '✨', 'Auréola de fé que protege o espírito', 'helmet', v_cleric_id, 9, 54, 44, 0.4, 0.6, 'legendary', 70, 'grade_15_oricalco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g15_armor', 'Sopro de Oricalco — Armadura', '✨', 'Vestes imaculadas de poder divino', 'armor', v_cleric_id, 6, 79, 110, 0, 0, 'legendary', 70, 'grade_15_oricalco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g15_gloves', 'Sopro de Oricalco — Luvas', '✨', 'Luvas que canalizam energia curativa', 'gloves', v_cleric_id, 16, 14, 20, 1.9, 0.6, 'legendary', 70, 'grade_15_oricalco_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g15_boots', 'Sopro de Oricalco — Botas', '✨', 'Sandálias da jornada espiritual', 'boots', v_cleric_id, 6, 23, 75, 0.8, 4.8, 'legendary', 70, 'grade_15_oricalco_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 16 — Astral (Níveis 75-80) — LEGENDARY
  -- ========================================================================

    -- Paladino — Vigia Astral
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g16_weapon', 'Vigia Astral — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 51, 8, 1, 1.3, 0, 'legendary', 75, 'grade_16_astral_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g16_helmet', 'Vigia Astral — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 18, 59, 41, 0.7, 0.4, 'legendary', 75, 'grade_16_astral_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g16_armor', 'Vigia Astral — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 11, 77, 83, 0, 0, 'legendary', 75, 'grade_16_astral_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g16_gloves', 'Vigia Astral — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 32, 17, 18, 3.3, 0.4, 'legendary', 75, 'grade_16_astral_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g16_boots', 'Vigia Astral — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 11, 27, 64, 1.3, 3.1, 'legendary', 75, 'grade_16_astral_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Fúria Astral
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g16_weapon', 'Fúria Astral — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 96, 5, 1, 2.6, 0, 'legendary', 75, 'grade_16_astral_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g16_helmet', 'Fúria Astral — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 34, 35, 31, 1.3, 0.2, 'legendary', 75, 'grade_16_astral_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g16_armor', 'Fúria Astral — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 21, 45, 64, 0, 0, 'legendary', 75, 'grade_16_astral_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g16_gloves', 'Fúria Astral — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 61, 10, 14, 6.5, 0.2, 'legendary', 75, 'grade_16_astral_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g16_boots', 'Fúria Astral — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 21, 16, 49, 2.6, 1.9, 'legendary', 75, 'grade_16_astral_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Projeção Astral
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g16_weapon', 'Projeção Astral — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 83, 5, 1, 3.9, 0, 'legendary', 75, 'grade_16_astral_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g16_helmet', 'Projeção Astral — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 29, 40, 22, 2, 0.2, 'legendary', 75, 'grade_16_astral_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g16_armor', 'Projeção Astral — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 18, 51, 45, 0, 0, 'legendary', 75, 'grade_16_astral_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g16_gloves', 'Projeção Astral — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 53, 11, 10, 9.8, 0.2, 'legendary', 75, 'grade_16_astral_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g16_boots', 'Projeção Astral — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 18, 18, 35, 3.9, 1.9, 'legendary', 75, 'grade_16_astral_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Cometa Astral
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g16_weapon', 'Cometa Astral — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 77, 4, 1, 5.2, 0, 'legendary', 75, 'grade_16_astral_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g16_helmet', 'Cometa Astral — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 27, 30, 16, 2.6, 1.6, 'legendary', 75, 'grade_16_astral_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g16_armor', 'Cometa Astral — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 17, 38, 32, 0, 0, 'legendary', 75, 'grade_16_astral_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g16_gloves', 'Cometa Astral — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 49, 8, 7, 13, 1.6, 'legendary', 75, 'grade_16_astral_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g16_boots', 'Cometa Astral — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 17, 13, 25, 5.2, 12.5, 'legendary', 75, 'grade_16_astral_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Corpo Astral
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g16_weapon', 'Corpo Astral — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 32, 9, 1, 0.8, 0, 'legendary', 75, 'grade_16_astral_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g16_helmet', 'Corpo Astral — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 11, 64, 57, 0.4, 0.6, 'legendary', 75, 'grade_16_astral_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g16_armor', 'Corpo Astral — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 7, 83, 115, 0, 0, 'legendary', 75, 'grade_16_astral_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g16_gloves', 'Corpo Astral — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 20, 18, 25, 2, 0.6, 'legendary', 75, 'grade_16_astral_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g16_boots', 'Corpo Astral — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 7, 29, 89, 0.8, 5, 'legendary', 75, 'grade_16_astral_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 17 — Eclipse (Níveis 80-85) — LEGENDARY
  -- ========================================================================

    -- Paladino — Luar Eclipse
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g17_weapon', 'Luar Eclipse — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 46, 10, 1, 1.4, 0, 'legendary', 80, 'grade_17_eclipse_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g17_helmet', 'Luar Eclipse — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 21, 58, 45, 0.7, 0.4, 'legendary', 80, 'grade_17_eclipse_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g17_armor', 'Luar Eclipse — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 14, 69, 75, 0, 0, 'legendary', 80, 'grade_17_eclipse_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g17_gloves', 'Luar Eclipse — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 34, 21, 22, 3.4, 0.4, 'legendary', 80, 'grade_17_eclipse_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g17_boots', 'Luar Eclipse — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 14, 31, 63, 1.4, 3.2, 'legendary', 80, 'grade_17_eclipse_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Escuridão Eclipse
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g17_weapon', 'Escuridão Eclipse — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 86, 6, 1, 2.7, 0, 'legendary', 80, 'grade_17_eclipse_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g17_helmet', 'Escuridão Eclipse — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 39, 34, 35, 1.4, 0.2, 'legendary', 80, 'grade_17_eclipse_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g17_armor', 'Escuridão Eclipse — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 26, 40, 57, 0, 0, 'legendary', 80, 'grade_17_eclipse_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g17_gloves', 'Escuridão Eclipse — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 63, 12, 17, 6.8, 0.2, 'legendary', 80, 'grade_17_eclipse_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g17_boots', 'Escuridão Eclipse — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 26, 18, 49, 2.7, 1.9, 'legendary', 80, 'grade_17_eclipse_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Sombras Eclipse
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g17_weapon', 'Sombras Eclipse — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 75, 7, 1, 4.1, 0, 'legendary', 80, 'grade_17_eclipse_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g17_helmet', 'Sombras Eclipse — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 34, 39, 24, 2, 0.2, 'legendary', 80, 'grade_17_eclipse_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g17_armor', 'Sombras Eclipse — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 22, 46, 40, 0, 0, 'legendary', 80, 'grade_17_eclipse_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g17_gloves', 'Sombras Eclipse — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 55, 14, 12, 10.1, 0.2, 'legendary', 80, 'grade_17_eclipse_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g17_boots', 'Sombras Eclipse — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 22, 21, 34, 4.1, 1.9, 'legendary', 80, 'grade_17_eclipse_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Crepúsculo Eclipse
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g17_weapon', 'Crepúsculo Eclipse — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 69, 5, 1, 5.4, 0, 'legendary', 80, 'grade_17_eclipse_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g17_helmet', 'Crepúsculo Eclipse — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 31, 29, 17, 2.7, 1.6, 'legendary', 80, 'grade_17_eclipse_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g17_armor', 'Crepúsculo Eclipse — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 21, 34, 29, 0, 0, 'legendary', 80, 'grade_17_eclipse_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g17_gloves', 'Crepúsculo Eclipse — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 51, 10, 9, 13.5, 1.6, 'legendary', 80, 'grade_17_eclipse_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g17_boots', 'Crepúsculo Eclipse — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 21, 16, 24, 5.4, 13, 'legendary', 80, 'grade_17_eclipse_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Silêncio Eclipse
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g17_weapon', 'Silêncio Eclipse — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 29, 11, 1, 0.8, 0, 'legendary', 80, 'grade_17_eclipse_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g17_helmet', 'Silêncio Eclipse — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 13, 63, 63, 0.4, 0.6, 'legendary', 80, 'grade_17_eclipse_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g17_armor', 'Silêncio Eclipse — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 9, 75, 103, 0, 0, 'legendary', 80, 'grade_17_eclipse_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g17_gloves', 'Silêncio Eclipse — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 21, 22, 31, 2, 0.6, 'legendary', 80, 'grade_17_eclipse_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g17_boots', 'Silêncio Eclipse — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 9, 34, 87, 0.8, 5.2, 'legendary', 80, 'grade_17_eclipse_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 18 — Solar (Níveis 85-90) — LEGENDARY
  -- ========================================================================

    -- Paladino — Coroa Solar
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g18_weapon', 'Coroa Solar — Arma', '⚔️', 'Lâmina sagrada que brilha com luz celestial', 'weapon', v_paladin_id, 42, 11, 1, 1.4, 0, 'legendary', 85, 'grade_18_solar_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g18_helmet', 'Coroa Solar — Capacete', '⚔️', 'Elmo que guarda a sabedoria dos antigos cavaleiros', 'helmet', v_paladin_id, 20, 51, 42, 0.7, 0.4, 'legendary', 85, 'grade_18_solar_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g18_armor', 'Coroa Solar — Armadura', '⚔️', 'Armadura imbuída com proteção divina', 'armor', v_paladin_id, 14, 63, 68, 0, 0, 'legendary', 85, 'grade_18_solar_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g18_gloves', 'Coroa Solar — Luvas', '⚔️', 'Luvas que canalizam o poder divino', 'gloves', v_paladin_id, 30, 21, 23, 3.5, 0.4, 'legendary', 85, 'grade_18_solar_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g18_boots', 'Coroa Solar — Botas', '⚔️', 'Grevas que pisam o caminho da retidão', 'boots', v_paladin_id, 14, 31, 55, 1.4, 3.4, 'legendary', 85, 'grade_18_solar_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Queimadura Solar
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g18_weapon', 'Queimadura Solar — Arma', '🗡️', 'Arma brutal forjada em sangue e aço', 'weapon', v_warrior_id, 78, 6, 1, 2.8, 0, 'legendary', 85, 'grade_18_solar_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g18_helmet', 'Queimadura Solar — Capacete', '🗡️', 'Elmo marcado por cicatrizes de batalhas', 'helmet', v_warrior_id, 38, 30, 32, 1.4, 0.3, 'legendary', 85, 'grade_18_solar_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g18_armor', 'Queimadura Solar — Armadura', '🗡️', 'Armadura que carrega as marcas da guerra', 'armor', v_warrior_id, 27, 36, 52, 0, 0, 'legendary', 85, 'grade_18_solar_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g18_gloves', 'Queimadura Solar — Luvas', '🗡️', 'Luvas que esmagam ossos e escudos', 'gloves', v_warrior_id, 57, 12, 18, 7, 0.3, 'legendary', 85, 'grade_18_solar_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g18_boots', 'Queimadura Solar — Botas', '🗡️', 'Botas que avançam sem medo na batalha', 'boots', v_warrior_id, 27, 18, 42, 2.8, 2, 'legendary', 85, 'grade_18_solar_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Explosão Solar
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g18_weapon', 'Explosão Solar — Arma', '🔮', 'Cajado que canaliza energias arcanas', 'weapon', v_mage_id, 68, 7, 1, 4.2, 0, 'legendary', 85, 'grade_18_solar_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g18_helmet', 'Explosão Solar — Capacete', '🔮', 'Tiara que amplia o poder da mente', 'helmet', v_mage_id, 33, 34, 23, 2.1, 0.3, 'legendary', 85, 'grade_18_solar_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g18_armor', 'Explosão Solar — Armadura', '🔮', 'Vestes tecidas com fios de mana pura', 'armor', v_mage_id, 23, 42, 36, 0, 0, 'legendary', 85, 'grade_18_solar_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g18_gloves', 'Explosão Solar — Luvas', '🔮', 'Luvas que potencializam feitiços', 'gloves', v_mage_id, 49, 14, 12, 10.5, 0.3, 'legendary', 85, 'grade_18_solar_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g18_boots', 'Explosão Solar — Botas', '🔮', 'Botas que flutuam entre planos', 'boots', v_mage_id, 23, 20, 30, 4.2, 2, 'legendary', 85, 'grade_18_solar_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Raio Solar
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g18_weapon', 'Raio Solar — Arma', '🏹', 'Arco que dispara flechas infalíveis', 'weapon', v_archer_id, 63, 5, 1, 5.6, 0, 'legendary', 85, 'grade_18_solar_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g18_helmet', 'Raio Solar — Capacete', '🏹', 'Elmo que aguça a visão do caçador', 'helmet', v_archer_id, 31, 25, 16, 2.8, 1.7, 'legendary', 85, 'grade_18_solar_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g18_armor', 'Raio Solar — Armadura', '🏹', 'Gibão leve que permite movimento rápido', 'armor', v_archer_id, 21, 31, 26, 0, 0, 'legendary', 85, 'grade_18_solar_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g18_gloves', 'Raio Solar — Luvas', '🏹', 'Luvas que estabilizam a mira', 'gloves', v_archer_id, 45, 11, 9, 14, 1.7, 'legendary', 85, 'grade_18_solar_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g18_boots', 'Raio Solar — Botas', '🏹', 'Botas silenciosas para mover-se nas sombras', 'boots', v_archer_id, 21, 15, 21, 5.6, 13.4, 'legendary', 85, 'grade_18_solar_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Bênção Solar
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g18_weapon', 'Bênção Solar — Arma', '✨', 'Maça que cura tanto quanto fere', 'weapon', v_cleric_id, 26, 12, 1, 0.8, 0, 'legendary', 85, 'grade_18_solar_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g18_helmet', 'Bênção Solar — Capacete', '✨', 'Auréola de fé que protege o espírito', 'helmet', v_cleric_id, 13, 55, 58, 0.4, 0.7, 'legendary', 85, 'grade_18_solar_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g18_armor', 'Bênção Solar — Armadura', '✨', 'Vestes imaculadas de poder divino', 'armor', v_cleric_id, 9, 68, 94, 0, 0, 'legendary', 85, 'grade_18_solar_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g18_gloves', 'Bênção Solar — Luvas', '✨', 'Luvas que canalizam energia curativa', 'gloves', v_cleric_id, 19, 23, 32, 2.1, 0.7, 'legendary', 85, 'grade_18_solar_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g18_boots', 'Bênção Solar — Botas', '✨', 'Sandálias da jornada espiritual', 'boots', v_cleric_id, 9, 33, 76, 0.8, 5.4, 'legendary', 85, 'grade_18_solar_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 19 — Cosmico (Níveis 90-95) — LEGENDARY
  -- ========================================================================

    -- Paladino — Guardião Cósmico
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g19_weapon', 'Guardião Cósmico — Arma', '⚔️', 'Espada forjada com bênçãos ancestrais', 'weapon', v_paladin_id, 47, 10, 1, 1.5, 0, 'legendary', 90, 'grade_19_cosmico_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g19_helmet', 'Guardião Cósmico — Capacete', '⚔️', 'Proteção sagrada para a mente do paladino', 'helmet', v_paladin_id, 18, 49, 37, 0.7, 0.4, 'legendary', 90, 'grade_19_cosmico_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g19_armor', 'Guardião Cósmico — Armadura', '⚔️', 'Couraça que reflete a luz da justiça', 'armor', v_paladin_id, 13, 71, 77, 0, 0, 'legendary', 90, 'grade_19_cosmico_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g19_gloves', 'Guardião Cósmico — Luvas', '⚔️', 'Manoplas da justiça que punem os ímpios', 'gloves', v_paladin_id, 27, 19, 21, 3.6, 0.4, 'legendary', 90, 'grade_19_cosmico_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g19_boots', 'Guardião Cósmico — Botas', '⚔️', 'Botas da jornada sagrada do paladino', 'boots', v_paladin_id, 13, 27, 53, 1.5, 3.5, 'legendary', 90, 'grade_19_cosmico_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Caos Cósmico
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g19_weapon', 'Caos Cósmico — Arma', '🗡️', 'Machado que grita por batalha', 'weapon', v_warrior_id, 88, 6, 1, 2.9, 0, 'legendary', 90, 'grade_19_cosmico_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g19_helmet', 'Caos Cósmico — Capacete', '🗡️', 'Proteção feroz para o guerreiro indomável', 'helmet', v_warrior_id, 33, 29, 28, 1.5, 0.3, 'legendary', 90, 'grade_19_cosmico_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g19_armor', 'Caos Cósmico — Armadura', '🗡️', 'Couraça resistente forjada para o combate', 'armor', v_warrior_id, 24, 41, 59, 0, 0, 'legendary', 90, 'grade_19_cosmico_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g19_gloves', 'Caos Cósmico — Luvas', '🗡️', 'Manoplas da força bruta e destruição', 'gloves', v_warrior_id, 51, 11, 16, 7.3, 0.3, 'legendary', 90, 'grade_19_cosmico_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g19_boots', 'Caos Cósmico — Botas', '🗡️', 'Grevas da investida feroz', 'boots', v_warrior_id, 24, 16, 41, 2.9, 2.1, 'legendary', 90, 'grade_19_cosmico_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Tecelão Cósmico
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g19_weapon', 'Tecelão Cósmico — Arma', '🔮', 'Bastão imbuído com magia ancestral', 'weapon', v_mage_id, 77, 7, 1, 4.4, 0, 'legendary', 90, 'grade_19_cosmico_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g19_helmet', 'Tecelão Cósmico — Capacete', '🔮', 'Coroa arcana que protege o intelecto', 'helmet', v_mage_id, 29, 33, 20, 2.2, 0.3, 'legendary', 90, 'grade_19_cosmico_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g19_armor', 'Tecelão Cósmico — Armadura', '🔮', 'Túnica protegida por encantamentos', 'armor', v_mage_id, 21, 47, 41, 0, 0, 'legendary', 90, 'grade_19_cosmico_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g19_gloves', 'Tecelão Cósmico — Luvas', '🔮', 'Manoplas arcanas de canalização mágica', 'gloves', v_mage_id, 45, 13, 11, 10.9, 0.3, 'legendary', 90, 'grade_19_cosmico_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g19_boots', 'Tecelão Cósmico — Botas', '🔮', 'Sandálias aladas de velocidade mágica', 'boots', v_mage_id, 21, 18, 29, 4.4, 2.1, 'legendary', 90, 'grade_19_cosmico_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Estrela Cósmica
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g19_weapon', 'Estrela Cósmica — Arma', '🏹', 'Besta de precisão mortal', 'weapon', v_archer_id, 71, 5, 1, 5.8, 0, 'legendary', 90, 'grade_19_cosmico_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g19_helmet', 'Estrela Cósmica — Capacete', '🏹', 'Gorjal que protege o pescoço do atirador', 'helmet', v_archer_id, 27, 25, 14, 2.9, 1.7, 'legendary', 90, 'grade_19_cosmico_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g19_armor', 'Estrela Cósmica — Armadura', '🏹', 'Colete de couro reforçado para flexibilidade', 'armor', v_archer_id, 19, 35, 29, 0, 0, 'legendary', 90, 'grade_19_cosmico_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g19_gloves', 'Estrela Cósmica — Luvas', '🏹', 'Dedais de pontaria precisa', 'gloves', v_archer_id, 41, 9, 8, 14.5, 1.7, 'legendary', 90, 'grade_19_cosmico_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g19_boots', 'Estrela Cósmica — Botas', '🏹', 'Calçados da agilidade do vento', 'boots', v_archer_id, 19, 13, 21, 5.8, 13.9, 'legendary', 90, 'grade_19_cosmico_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Nexus Cósmico
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g19_weapon', 'Nexus Cósmico — Arma', '✨', 'Martelo da redenção divina', 'weapon', v_cleric_id, 29, 11, 1, 0.9, 0, 'legendary', 90, 'grade_19_cosmico_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g19_helmet', 'Nexus Cósmico — Capacete', '✨', 'Elmo da devoção eterna', 'helmet', v_cleric_id, 11, 53, 51, 0.4, 0.7, 'legendary', 90, 'grade_19_cosmico_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g19_armor', 'Nexus Cósmico — Armadura', '✨', 'Túnica sagrada da cura', 'armor', v_cleric_id, 8, 77, 106, 0, 0, 'legendary', 90, 'grade_19_cosmico_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g19_gloves', 'Nexus Cósmico — Luvas', '✨', 'Manoplas da restauração divina', 'gloves', v_cleric_id, 17, 21, 28, 2.2, 0.7, 'legendary', 90, 'grade_19_cosmico_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g19_boots', 'Nexus Cósmico — Botas', '✨', 'Botas que pisam terras sagradas', 'boots', v_cleric_id, 8, 29, 74, 0.9, 5.6, 'legendary', 90, 'grade_19_cosmico_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- GRADE 20 — Primordial (Níveis 95-100) — LEGENDARY
  -- ========================================================================

    -- Paladino — Forja dos Deuses
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g20_weapon', 'Forja dos Deuses — Arma', '⚔️', 'Arma divina que protege os justos', 'weapon', v_paladin_id, 60, 9, 1, 1.5, 0, 'legendary', 95, 'grade_20_primordial_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g20_helmet', 'Forja dos Deuses — Capacete', '⚔️', 'Coroa da fé que resguarda o espírito', 'helmet', v_paladin_id, 17, 60, 39, 0.8, 0.5, 'legendary', 95, 'grade_20_primordial_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g20_armor', 'Forja dos Deuses — Armadura', '⚔️', 'Vestes de batalha abençoadas pelos céus', 'armor', v_paladin_id, 12, 90, 98, 0, 0, 'legendary', 95, 'grade_20_primordial_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g20_gloves', 'Forja dos Deuses — Luvas', '⚔️', 'Protetores das mãos que empunham a fé', 'gloves', v_paladin_id, 31, 17, 19, 3.8, 0.5, 'legendary', 95, 'grade_20_primordial_paladin', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('paladin_g20_boots', 'Forja dos Deuses — Botas', '⚔️', 'Passos firmes na trilha da justiça', 'boots', v_paladin_id, 12, 26, 65, 1.5, 3.6, 'legendary', 95, 'grade_20_primordial_paladin', 5.0);
    v_item_count := v_item_count + 1;

    -- Guerreiro — Caos Primordial
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g20_weapon', 'Caos Primordial — Arma', '🗡️', 'Arma de guerra que conhece mil campos', 'weapon', v_warrior_id, 113, 5, 1, 3, 0, 'legendary', 95, 'grade_20_primordial_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g20_helmet', 'Caos Primordial — Capacete', '🗡️', 'Capacete de guerra temperado no fogo', 'helmet', v_warrior_id, 32, 35, 30, 1.5, 0.3, 'legendary', 95, 'grade_20_primordial_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g20_armor', 'Caos Primordial — Armadura', '🗡️', 'Proteção total para o campo de batalha', 'armor', v_warrior_id, 22, 53, 75, 0, 0, 'legendary', 95, 'grade_20_primordial_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g20_gloves', 'Caos Primordial — Luvas', '🗡️', 'Protetores dos punhos do guerreiro', 'gloves', v_warrior_id, 59, 10, 14, 7.5, 0.3, 'legendary', 95, 'grade_20_primordial_warrior', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('warrior_g20_boots', 'Caos Primordial — Botas', '🗡️', 'Passos de guerra que tremem o chão', 'boots', v_warrior_id, 22, 15, 50, 3, 2.2, 'legendary', 95, 'grade_20_primordial_warrior', 5.0);
    v_item_count := v_item_count + 1;

    -- Mago — Fonte do Universo
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g20_weapon', 'Fonte do Universo — Arma', '🔮', 'Arcano foco de poder místico', 'weapon', v_mage_id, 98, 6, 1, 4.5, 0, 'legendary', 95, 'grade_20_primordial_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g20_helmet', 'Fonte do Universo — Capacete', '🔮', 'Elmo da sabedoria mística', 'helmet', v_mage_id, 28, 40, 21, 2.3, 0.3, 'legendary', 95, 'grade_20_primordial_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g20_armor', 'Fonte do Universo — Armadura', '🔮', 'Armadura arcana de tecido estelar', 'armor', v_mage_id, 19, 60, 53, 0, 0, 'legendary', 95, 'grade_20_primordial_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g20_gloves', 'Fonte do Universo — Luvas', '🔮', 'Protetores dos dedos do conjurador', 'gloves', v_mage_id, 51, 12, 10, 11.3, 0.3, 'legendary', 95, 'grade_20_primordial_mage', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('mage_g20_boots', 'Fonte do Universo — Botas', '🔮', 'Calçados que pisam o éter', 'boots', v_mage_id, 19, 17, 35, 4.5, 2.2, 'legendary', 95, 'grade_20_primordial_mage', 5.0);
    v_item_count := v_item_count + 1;

    -- Arqueiro — Primeira Flecha
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g20_weapon', 'Primeira Flecha — Arma', '🏹', 'Arco longo de madeira encantada', 'weapon', v_archer_id, 90, 4, 1, 6, 0, 'legendary', 95, 'grade_20_primordial_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g20_helmet', 'Primeira Flecha — Capacete', '🏹', 'Capuz da precisão silenciosa', 'helmet', v_archer_id, 26, 30, 15, 3, 1.8, 'legendary', 95, 'grade_20_primordial_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g20_armor', 'Primeira Flecha — Armadura', '🏹', 'Armadura leve de caçador experiente', 'armor', v_archer_id, 17, 45, 38, 0, 0, 'legendary', 95, 'grade_20_primordial_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g20_gloves', 'Primeira Flecha — Luvas', '🏹', 'Manoplas leves para puxar o arco', 'gloves', v_archer_id, 47, 9, 7, 15, 1.8, 'legendary', 95, 'grade_20_primordial_archer', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('archer_g20_boots', 'Primeira Flecha — Botas', '🏹', 'Passos ligeiros do rastreador', 'boots', v_archer_id, 17, 13, 25, 6, 14.4, 'legendary', 95, 'grade_20_primordial_archer', 5.0);
    v_item_count := v_item_count + 1;

    -- Clérigo — Voz da Criação
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g20_weapon', 'Voz da Criação — Arma', '✨', 'Bastão sagrado de poder celestial', 'weapon', v_cleric_id, 38, 10, 1, 0.9, 0, 'legendary', 95, 'grade_20_primordial_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g20_helmet', 'Voz da Criação — Capacete', '✨', 'Coroa de luz sagrada', 'helmet', v_cleric_id, 11, 65, 53, 0.5, 0.7, 'legendary', 95, 'grade_20_primordial_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g20_armor', 'Voz da Criação — Armadura', '✨', 'Armadura da fé inquebrável', 'armor', v_cleric_id, 7, 98, 135, 0, 0, 'legendary', 95, 'grade_20_primordial_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g20_gloves', 'Voz da Criação — Luvas', '✨', 'Protetores das mãos que abençoam', 'gloves', v_cleric_id, 20, 19, 26, 2.3, 0.7, 'legendary', 95, 'grade_20_primordial_cleric', 5.0);
    v_item_count := v_item_count + 1;
    INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id, set_bonus_percentage)
    VALUES ('cleric_g20_boots', 'Voz da Criação — Botas', '✨', 'Calçados do peregrino da fé', 'boots', v_cleric_id, 7, 28, 90, 0.9, 5.8, 'legendary', 95, 'grade_20_primordial_cleric', 5.0);
    v_item_count := v_item_count + 1;

  -- ========================================================================
  -- SUMMARY
  -- ========================================================================
  RAISE NOTICE 'Created % items across % grades', v_item_count, 20;
END $$;
