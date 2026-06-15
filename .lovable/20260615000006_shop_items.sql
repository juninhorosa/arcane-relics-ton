-- ============================================================================
-- SHOP ITEMS MIGRATION
-- Creates the shop_items table for VIP and consumable purchases
-- ============================================================================

CREATE TABLE IF NOT EXISTS shop_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  ton_price NUMERIC NOT NULL CHECK (ton_price > 0),
  item_type TEXT NOT NULL CHECK (item_type IN ('vip', 'consumable')),
  item_template_id UUID REFERENCES item_templates(id) ON DELETE SET NULL,
  duration_days INTEGER DEFAULT 0,
  quantity INTEGER DEFAULT 1,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

ALTER TABLE shop_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "shop_items_public_read" ON shop_items
  FOR SELECT USING (active = true);

CREATE POLICY "shop_items_admin_all" ON shop_items
  FOR ALL USING (
    EXISTS (SELECT 1 FROM auth.users WHERE id = auth.uid() AND raw_user_meta_data->>'role' = 'admin')
  );

-- Add shop_item_id to pack_purchases
ALTER TABLE pack_purchases
  ADD COLUMN IF NOT EXISTS shop_item_id UUID REFERENCES shop_items(id) ON DELETE SET NULL,
  ALTER COLUMN pack_id DROP NOT NULL;

CREATE INDEX IF NOT EXISTS idx_shop_items_active ON shop_items(active);
CREATE INDEX IF NOT EXISTS idx_shop_items_type ON shop_items(item_type);
CREATE INDEX IF NOT EXISTS idx_pack_purchases_shop_item ON pack_purchases(shop_item_id);

-- ============================================================================
-- SEED DATA: VIP and consumable products
-- ============================================================================

INSERT INTO shop_items (code, name, description, ton_price, item_type, duration_days, quantity) VALUES
  ('VIP_7_DAYS', 'VIP 7 Dias', 'Acesso VIP por 7 dias com bônus de 30% em XP, Gold e HP', 1.5, 'vip', 7, 1),
  ('VIP_30_DAYS', 'VIP 30 Dias', 'Acesso VIP por 30 dias com bônus de 30% em XP, Gold e HP', 5, 'vip', 30, 1),
  ('VIP_90_DAYS', 'VIP 90 Dias', 'Acesso VIP por 90 dias com bônus de 30% em XP, Gold e HP', 12, 'vip', 90, 1);
