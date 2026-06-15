-- ============================================================================
-- ITEMS SYSTEM MIGRATION
-- Creates items, inventory, and set bonuses for the equipment system
-- ============================================================================

-- Create enum for item categories
CREATE TYPE item_category AS ENUM (
  'weapon',      -- Arma
  'helmet',      -- Capacete/Cabeça
  'armor',       -- Armadura/Peito
  'gloves',      -- Luvas
  'boots'        -- Botas/Pés
);

-- Create enum for item rarity
CREATE TYPE item_rarity AS ENUM (
  'common',
  'uncommon',
  'rare',
  'epic',
  'legendary'
);

-- ============================================================================
-- ITEMS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  emoji TEXT NOT NULL,
  description TEXT NOT NULL,
  category item_category NOT NULL,
  class_id UUID NOT NULL REFERENCES character_classes(id) ON DELETE CASCADE,
  
  -- Bonuses
  attack_bonus INTEGER DEFAULT 0,
  defense_bonus INTEGER DEFAULT 0,
  hp_bonus INTEGER DEFAULT 0,
  crit_bonus FLOAT DEFAULT 0,
  dodge_bonus FLOAT DEFAULT 0,
  
  -- Item properties
  rarity item_rarity NOT NULL DEFAULT 'common',
  required_level INTEGER DEFAULT 1,
  slot_weight INTEGER DEFAULT 1,
  set_id TEXT NOT NULL,  -- Groups items into sets
  
  -- Set completion bonus (5% all stats when complete)
  set_bonus_percentage FLOAT DEFAULT 5.0,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()),
  
  CONSTRAINT set_bonus_positive CHECK (set_bonus_percentage > 0)
);

-- ============================================================================
-- PLAYER INVENTORY TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS player_inventory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  
  -- Inventory management
  quantity INTEGER NOT NULL DEFAULT 1,
  is_equipped BOOLEAN DEFAULT FALSE,
  equipped_slot item_category,  -- Which slot it's equipped in
  
  -- Item progression
  durability INTEGER DEFAULT 100,  -- 0-100
  uses_count INTEGER DEFAULT 0,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()),
  
  UNIQUE(player_id, item_id, is_equipped),
  CONSTRAINT quantity_positive CHECK (quantity > 0),
  CONSTRAINT durability_range CHECK (durability >= 0 AND durability <= 100)
);

-- ============================================================================
-- RLS POLICIES
-- ============================================================================

-- Items table: Public read, admin write
ALTER TABLE items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "items_public_read" ON items
  FOR SELECT USING (true);

CREATE POLICY "items_admin_write" ON items
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM auth.users WHERE id = auth.uid() AND raw_user_meta_data->>'role' = 'admin')
  );

CREATE POLICY "items_admin_update" ON items
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM auth.users WHERE id = auth.uid() AND raw_user_meta_data->>'role' = 'admin')
  );

-- Player inventory: User can only see their own
ALTER TABLE player_inventory ENABLE ROW LEVEL SECURITY;

CREATE POLICY "inventory_user_read" ON player_inventory
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM players WHERE id = player_id AND telegram_id = auth.uid()::text)
  );

CREATE POLICY "inventory_user_write" ON player_inventory
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM players WHERE id = player_id AND telegram_id = auth.uid()::text)
  );

CREATE POLICY "inventory_user_update" ON player_inventory
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM players WHERE id = player_id AND telegram_id = auth.uid()::text)
  );

CREATE POLICY "inventory_user_delete" ON player_inventory
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM players WHERE id = player_id AND telegram_id = auth.uid()::text)
  );

-- ============================================================================
-- TRIGGERS
-- ============================================================================

CREATE TRIGGER items_updated_at BEFORE UPDATE ON items
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER inventory_updated_at BEFORE UPDATE ON player_inventory
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX idx_items_class_id ON items(class_id);
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_rarity ON items(rarity);
CREATE INDEX idx_items_set_id ON items(set_id);
CREATE INDEX idx_inventory_player_id ON player_inventory(player_id);
CREATE INDEX idx_inventory_item_id ON player_inventory(item_id);
CREATE INDEX idx_inventory_equipped ON player_inventory(is_equipped);

-- ============================================================================
-- SEED DATA: 25 ITEMS (5 PER CLASS × 5 CATEGORIES)
-- ============================================================================

-- Get class IDs for seeding
DO $$
DECLARE
  v_paladin_id UUID;
  v_warrior_id UUID;
  v_mage_id UUID;
  v_archer_id UUID;
  v_cleric_id UUID;
BEGIN
  SELECT id INTO v_paladin_id FROM character_classes WHERE code = 'paladin';
  SELECT id INTO v_warrior_id FROM character_classes WHERE code = 'warrior';
  SELECT id INTO v_mage_id FROM character_classes WHERE code = 'mage';
  SELECT id INTO v_archer_id FROM character_classes WHERE code = 'archer';
  SELECT id INTO v_cleric_id FROM character_classes WHERE code = 'cleric';

  -- ========================================================================
  -- PALADINO (5 items - 1 per category)
  -- ========================================================================
  
  INSERT INTO items (code, name, emoji, description, category, class_id, attack_bonus, defense_bonus, hp_bonus, crit_bonus, dodge_bonus, rarity, required_level, set_id)
  VALUES
    -- Weapon
    ('paladin_sword_sanctum', 'Espada da Santidade', '⚔️', 'Uma lâmina abençoada que canaliza poder divino', 'weapon', v_paladin_id, 25, 5, 0, 0, 0, 'rare', 1, 'paladin_sanctity_set'),
    -- Helmet
    ('paladin_helm_devotion', 'Elmo da Devoção', '🛡️', 'Proteção divina na forma de um elmo reluzente', 'helmet', v_paladin_id, 5, 20, 10, 0, 5, 'rare', 1, 'paladin_sanctity_set'),
    -- Armor
    ('paladin_armor_blessed', 'Armadura Abençoada', '🦾', 'Vestes sagradas que desviam ataques maléficos', 'armor', v_paladin_id, 8, 28, 15, 0, 0, 'rare', 1, 'paladin_sanctity_set'),
    -- Gloves
    ('paladin_gloves_wrath', 'Luvas da Ira Divina', '🧤', 'Aumentam a força do golpe sagrado', 'gloves', v_paladin_id, 12, 8, 5, 5, 0, 'rare', 1, 'paladin_sanctity_set'),
    -- Boots
    ('paladin_boots_conviction', 'Botas da Convicção', '👢', 'Permitem andar com confiança em qualquer terreno', 'boots', v_paladin_id, 3, 10, 8, 0, 10, 'rare', 1, 'paladin_sanctity_set'),

  -- ========================================================================
  -- GUERREIRO (5 items - 1 per category)
  -- ========================================================================
  
    -- Weapon
    ('warrior_axe_bloodlust', 'Machado da Sede de Sangue', '🪓', 'Uma arma feroz que grita por batalha', 'weapon', v_warrior_id, 35, 0, 5, 8, 0, 'epic', 1, 'warrior_onslaught_set'),
    -- Helmet
    ('warrior_helm_iron', 'Elmo de Ferro Forjado', '⚒️', 'Forjado no coração de uma montanha', 'helmet', v_warrior_id, 3, 25, 20, 0, 0, 'epic', 1, 'warrior_onslaught_set'),
    -- Armor
    ('warrior_armor_plates', 'Armadura de Placas de Guerra', '🛡️', 'Placas de metal que desviam golpes letais', 'armor', v_warrior_id, 5, 32, 25, 0, 0, 'epic', 1, 'warrior_onslaught_set'),
    -- Gloves
    ('warrior_gloves_crushing', 'Luvas do Esmagamento', '👊', 'Amplificam o poder do punho', 'gloves', v_warrior_id, 15, 5, 10, 10, 0, 'epic', 1, 'warrior_onslaught_set'),
    -- Boots
    ('warrior_boots_charge', 'Botas da Investida', '⚡', 'Permitem carregar com força aumentada', 'boots', v_warrior_id, 8, 8, 15, 0, 5, 'epic', 1, 'warrior_onslaught_set'),

  -- ========================================================================
  -- MAGO (5 items - 1 per category)
  -- ========================================================================
  
    -- Weapon
    ('mage_staff_arcane', 'Cajado Arcano', '🎆', 'Canaliza a magia do universo', 'weapon', v_mage_id, 28, 2, 0, 0, 0, 'epic', 1, 'mage_mystique_set'),
    -- Helmet
    ('mage_helm_mind', 'Tiara Mental', '👑', 'Amplifica o poder psíquico do portador', 'helmet', v_mage_id, 8, 12, 5, 0, 5, 'epic', 1, 'mage_mystique_set'),
    -- Armor
    ('mage_robe_starlight', 'Veste da Luz Estelar', '✨', 'Tecida com fios de luz de estrelas antigas', 'armor', v_mage_id, 10, 18, 10, 5, 0, 'epic', 1, 'mage_mystique_set'),
    -- Gloves
    ('mage_gloves_spell', 'Luvas do Feitiço', '🌟', 'Potencializam a magia nas mãos', 'gloves', v_mage_id, 18, 5, 5, 12, 0, 'epic', 1, 'mage_mystique_set'),
    -- Boots
    ('mage_boots_float', 'Botas da Flutuação', '💨', 'Levitam o usuário ligeiramente', 'boots', v_mage_id, 5, 8, 8, 0, 15, 'epic', 1, 'mage_mystique_set'),

  -- ========================================================================
  -- ARQUEIRO (5 items - 1 per category)
  -- ========================================================================
  
    -- Weapon
    ('archer_bow_true', 'Arco da Verdade', '🏹', 'Dispara flechas que nunca erram', 'weapon', v_archer_id, 30, 0, 0, 15, 0, 'legendary', 1, 'archer_precision_set'),
    -- Helmet
    ('archer_helm_sight', 'Elmo da Visão Aguçada', '🦅', 'Amplia o campo de visão e precisão', 'helmet', v_archer_id, 5, 10, 5, 10, 8, 'legendary', 1, 'archer_precision_set'),
    -- Armor
    ('archer_vest_shadow', 'Colete Sombrio', '🕶️', 'Permite se mover nas sombras', 'armor', v_archer_id, 8, 15, 8, 8, 10, 'legendary', 1, 'archer_precision_set'),
    -- Gloves
    ('archer_gloves_steady', 'Luvas da Mão Firme', '✋', 'Mão nunca treme, flecha sempre acerta', 'gloves', v_archer_id, 12, 3, 3, 18, 0, 'legendary', 1, 'archer_precision_set'),
    -- Boots
    ('archer_boots_swift', 'Botas da Agilidade Lendária', '🏃', 'Movimento extremamente rápido', 'boots', v_archer_id, 5, 5, 5, 0, 20, 'legendary', 1, 'archer_precision_set'),

  -- ========================================================================
  -- CLÉRIGO (5 items - 1 per category)
  -- ========================================================================
  
    -- Weapon
    ('cleric_mace_grace', 'Maça da Graça', '🔱', 'Uma arma que cura tanto quanto fere', 'weapon', v_cleric_id, 20, 8, 30, 0, 0, 'legendary', 1, 'cleric_salvation_set'),
    -- Helmet
    ('cleric_helm_halo', 'Elmo com Halo Sagrado', '✨', 'Uma aura sagrada envolve o portador', 'helmet', v_cleric_id, 3, 15, 20, 0, 8, 'legendary', 1, 'cleric_salvation_set'),
    -- Armor
    ('cleric_robes_holy', 'Vestes Sagradas Imaculadas', '👗', 'Vestes de um santo guardião', 'armor', v_cleric_id, 5, 20, 35, 0, 0, 'legendary', 1, 'cleric_salvation_set'),
    -- Gloves
    ('cleric_gloves_mend', 'Luvas da Restauração', '🙏', 'Curam feridas com um toque', 'gloves', v_cleric_id, 8, 8, 25, 0, 0, 'legendary', 1, 'cleric_salvation_set'),
    -- Boots
    ('cleric_boots_journey', 'Botas da Jornada Sagrada', '🚶', 'Concedem proteção contra o caminho', 'boots', v_cleric_id, 3, 12, 20, 0, 12, 'legendary', 1, 'cleric_salvation_set');

  COMMIT;
END $$;

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total items created: 25 (5 per class × 5 categories)
-- Categories: weapon, helmet, armor, gloves, boots
-- Set bonus: +5% all stats when complete (all 5 items equipped)
-- ============================================================================
