
-- =====================================================
-- COLUMN ADDITIONS TO EXISTING TABLES
-- =====================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS is_banned boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS banned_reason text,
  ADD COLUMN IF NOT EXISTS banned_at timestamptz;

ALTER TABLE public.nations
  ADD COLUMN IF NOT EXISTS divine_protection_until timestamptz,
  ADD COLUMN IF NOT EXISTS base_xp_per_hour integer NOT NULL DEFAULT 100,
  ADD COLUMN IF NOT EXISTS base_gold_per_hour integer NOT NULL DEFAULT 50,
  ADD COLUMN IF NOT EXISTS rivalry_score integer NOT NULL DEFAULT 0;

-- character_classes table created below; add FK columns to players after that.
ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS is_vip boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS vip_until timestamptz,
  ADD COLUMN IF NOT EXISTS hp integer NOT NULL DEFAULT 100,
  ADD COLUMN IF NOT EXISTS max_hp integer NOT NULL DEFAULT 100,
  ADD COLUMN IF NOT EXISTS last_death_at timestamptz,
  ADD COLUMN IF NOT EXISTS skill_points integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS current_guild_id uuid;

-- =====================================================
-- CHARACTER CLASSES
-- =====================================================
CREATE TABLE IF NOT EXISTS public.character_classes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  emoji text NOT NULL DEFAULT '⚔️',
  description text NOT NULL DEFAULT '',
  attack_bonus integer NOT NULL DEFAULT 0,
  defense_bonus integer NOT NULL DEFAULT 0,
  hp_bonus integer NOT NULL DEFAULT 0,
  ability text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.character_classes TO anon, authenticated;
GRANT ALL ON public.character_classes TO service_role;
ALTER TABLE public.character_classes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "character_classes_read_all" ON public.character_classes FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "character_classes_admin_write" ON public.character_classes FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_character_classes_updated BEFORE UPDATE ON public.character_classes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Add player class_id FK now that character_classes exists
ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS class_id uuid REFERENCES public.character_classes(id) ON DELETE SET NULL;

-- =====================================================
-- MAPS
-- =====================================================
CREATE TABLE IF NOT EXISTS public.maps (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  description text DEFAULT '',
  min_level integer NOT NULL DEFAULT 1,
  max_level integer NOT NULL DEFAULT 99,
  nation_id uuid REFERENCES public.nations(id) ON DELETE SET NULL,
  monster_name text DEFAULT 'Monstro',
  base_xp_per_hour integer NOT NULL DEFAULT 100,
  base_gold_per_hour integer NOT NULL DEFAULT 50,
  drop_rate numeric NOT NULL DEFAULT 0.05,
  is_safe boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.maps TO anon, authenticated;
GRANT ALL ON public.maps TO service_role;
ALTER TABLE public.maps ENABLE ROW LEVEL SECURITY;
CREATE POLICY "maps_read_all" ON public.maps FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "maps_admin_write" ON public.maps FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_maps_updated BEFORE UPDATE ON public.maps FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS current_map_id uuid REFERENCES public.maps(id) ON DELETE SET NULL;

-- =====================================================
-- SKILLS
-- =====================================================
CREATE TABLE IF NOT EXISTS public.skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  description text NOT NULL DEFAULT '',
  emoji text NOT NULL DEFAULT '✨',
  class_id uuid REFERENCES public.character_classes(id) ON DELETE CASCADE,
  skill_type text NOT NULL DEFAULT 'active',
  rarity text NOT NULL DEFAULT 'common',
  required_level integer NOT NULL DEFAULT 1,
  required_skill_points integer NOT NULL DEFAULT 1,
  cooldown_seconds integer NOT NULL DEFAULT 0,
  energy_cost integer NOT NULL DEFAULT 0,
  attack_multiplier numeric NOT NULL DEFAULT 1,
  defense_multiplier numeric NOT NULL DEFAULT 1,
  hp_multiplier numeric NOT NULL DEFAULT 1,
  attack_bonus integer NOT NULL DEFAULT 0,
  defense_bonus integer NOT NULL DEFAULT 0,
  hp_bonus integer NOT NULL DEFAULT 0,
  crit_chance_bonus numeric NOT NULL DEFAULT 0,
  special_effect text,
  can_miss boolean NOT NULL DEFAULT false,
  can_crit boolean NOT NULL DEFAULT true,
  max_level integer NOT NULL DEFAULT 5,
  scaling_per_level numeric NOT NULL DEFAULT 0.1,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.skills TO anon, authenticated;
GRANT ALL ON public.skills TO service_role;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "skills_read_all" ON public.skills FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "skills_admin_write" ON public.skills FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_skills_updated BEFORE UPDATE ON public.skills FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- PLAYER SKILLS
-- =====================================================
CREATE TABLE IF NOT EXISTS public.player_skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  skill_id uuid NOT NULL REFERENCES public.skills(id) ON DELETE CASCADE,
  skill_level integer NOT NULL DEFAULT 1,
  learned_at timestamptz NOT NULL DEFAULT now(),
  last_used_at timestamptz,
  times_used integer NOT NULL DEFAULT 0,
  UNIQUE (player_id, skill_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.player_skills TO authenticated;
GRANT ALL ON public.player_skills TO service_role;
ALTER TABLE public.player_skills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "player_skills_owner_all" ON public.player_skills FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.id = auth.uid()));

-- =====================================================
-- ITEMS (full equipment catalog)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  emoji text NOT NULL DEFAULT '⚔️',
  description text DEFAULT '',
  category text NOT NULL DEFAULT 'weapon',
  class_id uuid REFERENCES public.character_classes(id) ON DELETE SET NULL,
  attack_bonus integer NOT NULL DEFAULT 0,
  defense_bonus integer NOT NULL DEFAULT 0,
  hp_bonus integer NOT NULL DEFAULT 0,
  crit_bonus numeric NOT NULL DEFAULT 0,
  dodge_bonus numeric NOT NULL DEFAULT 0,
  rarity text NOT NULL DEFAULT 'common',
  required_level integer NOT NULL DEFAULT 1,
  slot_weight integer NOT NULL DEFAULT 1,
  set_id text,
  set_bonus_percentage numeric NOT NULL DEFAULT 5,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.items TO anon, authenticated;
GRANT ALL ON public.items TO service_role;
ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "items_read_all" ON public.items FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "items_admin_write" ON public.items FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_items_updated BEFORE UPDATE ON public.items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- PLAYER INVENTORY (equipment instances)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.player_inventory (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  item_id uuid NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
  quantity integer NOT NULL DEFAULT 1,
  is_equipped boolean NOT NULL DEFAULT false,
  equipped_slot text,
  durability integer NOT NULL DEFAULT 100,
  uses_count integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_player_inventory_player ON public.player_inventory(player_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_player_inventory_equipped_slot
  ON public.player_inventory(player_id, equipped_slot) WHERE is_equipped = true;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.player_inventory TO authenticated;
GRANT ALL ON public.player_inventory TO service_role;
ALTER TABLE public.player_inventory ENABLE ROW LEVEL SECURITY;
CREATE POLICY "player_inventory_owner_all" ON public.player_inventory FOR ALL TO authenticated
  USING (player_id = auth.uid()) WITH CHECK (player_id = auth.uid());
CREATE TRIGGER trg_player_inventory_updated BEFORE UPDATE ON public.player_inventory FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- ACTIVE INVASIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS public.active_invasions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  attacker_nation_id uuid NOT NULL REFERENCES public.nations(id) ON DELETE CASCADE,
  defender_nation_id uuid NOT NULL REFERENCES public.nations(id) ON DELETE CASCADE,
  status text NOT NULL DEFAULT 'alert',
  alert_started_at timestamptz NOT NULL DEFAULT now(),
  attack_started_at timestamptz,
  ended_at timestamptz,
  winner_nation_id uuid REFERENCES public.nations(id) ON DELETE SET NULL,
  relic_id uuid REFERENCES public.relics(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.active_invasions TO anon, authenticated;
GRANT ALL ON public.active_invasions TO service_role;
ALTER TABLE public.active_invasions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "active_invasions_read_all" ON public.active_invasions FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "active_invasions_admin_write" ON public.active_invasions FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_active_invasions_updated BEFORE UPDATE ON public.active_invasions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.invasion_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invasion_id uuid NOT NULL REFERENCES public.active_invasions(id) ON DELETE CASCADE,
  player_id uuid NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  side text NOT NULL DEFAULT 'attacker',
  damage_dealt bigint NOT NULL DEFAULT 0,
  joined_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (invasion_id, player_id)
);
GRANT SELECT, INSERT, UPDATE ON public.invasion_participants TO authenticated;
GRANT ALL ON public.invasion_participants TO service_role;
ALTER TABLE public.invasion_participants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "invasion_participants_read_all" ON public.invasion_participants FOR SELECT TO authenticated USING (true);
CREATE POLICY "invasion_participants_self_write" ON public.invasion_participants FOR INSERT TO authenticated WITH CHECK (player_id = auth.uid());
CREATE POLICY "invasion_participants_self_update" ON public.invasion_participants FOR UPDATE TO authenticated USING (player_id = auth.uid());

-- =====================================================
-- WORLD BOSSES
-- =====================================================
CREATE TABLE IF NOT EXISTS public.world_bosses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  emoji text DEFAULT '🐉',
  description text DEFAULT '',
  max_hp bigint NOT NULL DEFAULT 1000000,
  current_hp bigint NOT NULL DEFAULT 1000000,
  reward_xp integer NOT NULL DEFAULT 1000,
  reward_gold integer NOT NULL DEFAULT 500,
  reward_item_id uuid REFERENCES public.items(id) ON DELETE SET NULL,
  starts_at timestamptz NOT NULL DEFAULT now(),
  ends_at timestamptz,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.world_bosses TO anon, authenticated;
GRANT ALL ON public.world_bosses TO service_role;
ALTER TABLE public.world_bosses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "world_bosses_read_all" ON public.world_bosses FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "world_bosses_admin_write" ON public.world_bosses FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_world_bosses_updated BEFORE UPDATE ON public.world_bosses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.boss_damage_ranking (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  boss_id uuid NOT NULL REFERENCES public.world_bosses(id) ON DELETE CASCADE,
  player_id uuid NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  damage_dealt bigint NOT NULL DEFAULT 0,
  hits integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (boss_id, player_id)
);
GRANT SELECT, INSERT, UPDATE ON public.boss_damage_ranking TO authenticated;
GRANT ALL ON public.boss_damage_ranking TO service_role;
ALTER TABLE public.boss_damage_ranking ENABLE ROW LEVEL SECURITY;
CREATE POLICY "boss_damage_read_all" ON public.boss_damage_ranking FOR SELECT TO authenticated USING (true);
CREATE POLICY "boss_damage_self_write" ON public.boss_damage_ranking FOR INSERT TO authenticated WITH CHECK (player_id = auth.uid());
CREATE POLICY "boss_damage_self_update" ON public.boss_damage_ranking FOR UPDATE TO authenticated USING (player_id = auth.uid());
CREATE TRIGGER trg_boss_damage_updated BEFORE UPDATE ON public.boss_damage_ranking FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- TERRITORIES & GUILD CHAT
-- =====================================================
CREATE TABLE IF NOT EXISTS public.territories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  nation_id uuid REFERENCES public.nations(id) ON DELETE SET NULL,
  owner_guild_id uuid,
  gold_per_hour integer NOT NULL DEFAULT 100,
  captured_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.territories TO anon, authenticated;
GRANT ALL ON public.territories TO service_role;
ALTER TABLE public.territories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "territories_read_all" ON public.territories FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "territories_admin_write" ON public.territories FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_territories_updated BEFORE UPDATE ON public.territories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.guild_chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  guild_id uuid NOT NULL,
  player_id uuid NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  message text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_guild_chat_guild ON public.guild_chat_messages(guild_id, created_at DESC);
GRANT SELECT, INSERT ON public.guild_chat_messages TO authenticated;
GRANT ALL ON public.guild_chat_messages TO service_role;
ALTER TABLE public.guild_chat_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "guild_chat_read_members" ON public.guild_chat_messages FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = auth.uid() AND p.current_guild_id = guild_id));
CREATE POLICY "guild_chat_self_post" ON public.guild_chat_messages FOR INSERT TO authenticated
  WITH CHECK (player_id = auth.uid() AND EXISTS (SELECT 1 FROM public.players p WHERE p.id = auth.uid() AND p.current_guild_id = guild_id));

-- =====================================================
-- SHOP ITEMS (VIP store)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.shop_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  description text DEFAULT '',
  category text NOT NULL DEFAULT 'vip',
  price_ton numeric NOT NULL DEFAULT 0,
  price_gold integer NOT NULL DEFAULT 0,
  vip_days integer NOT NULL DEFAULT 0,
  reward_xp integer NOT NULL DEFAULT 0,
  reward_gold integer NOT NULL DEFAULT 0,
  reward_item_id uuid REFERENCES public.items(id) ON DELETE SET NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT ON public.shop_items TO anon, authenticated;
GRANT ALL ON public.shop_items TO service_role;
ALTER TABLE public.shop_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "shop_items_read_all" ON public.shop_items FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "shop_items_admin_write" ON public.shop_items FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_shop_items_updated BEFORE UPDATE ON public.shop_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- RPC FUNCTIONS
-- =====================================================
CREATE OR REPLACE FUNCTION public.calculate_player_power(_player_id uuid)
RETURNS bigint LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT COALESCE((p.level * 10)
    + COALESCE((SELECT SUM(i.attack_bonus + i.defense_bonus + (i.hp_bonus / 10))
        FROM public.player_inventory pi JOIN public.items i ON i.id = pi.item_id
        WHERE pi.player_id = p.id AND pi.is_equipped = true), 0)
    + COALESCE((SELECT cc.attack_bonus + cc.defense_bonus + (cc.hp_bonus / 10)
        FROM public.character_classes cc WHERE cc.id = p.class_id), 0)
    , 10)::bigint
  FROM public.players p WHERE p.id = _player_id;
$$;

CREATE OR REPLACE FUNCTION public.get_player_max_hp(_player_id uuid)
RETURNS integer LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT GREATEST(100, COALESCE((100 + (p.level * 10)
    + COALESCE((SELECT SUM(i.hp_bonus) FROM public.player_inventory pi JOIN public.items i ON i.id = pi.item_id
        WHERE pi.player_id = p.id AND pi.is_equipped = true), 0)
    + COALESCE((SELECT cc.hp_bonus FROM public.character_classes cc WHERE cc.id = p.class_id), 0)
    ) * (CASE WHEN p.is_vip AND p.vip_until > now() THEN 1.3 ELSE 1 END), 100))::integer
  FROM public.players p WHERE p.id = _player_id;
$$;

CREATE OR REPLACE FUNCTION public.get_nation_player_counts()
RETURNS TABLE(nation_id uuid, total bigint) LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT nation_id, COUNT(*)::bigint FROM public.players WHERE nation_id IS NOT NULL GROUP BY nation_id;
$$;

CREATE OR REPLACE FUNCTION public.sync_offline_farm(_player_id uuid)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  p public.players%ROWTYPE;
  hours numeric; max_hours numeric; xp_gain int; gold_gain int;
  m public.maps%ROWTYPE; died boolean := false;
BEGIN
  SELECT * INTO p FROM public.players WHERE id = _player_id;
  IF NOT FOUND THEN RETURN jsonb_build_object('error','player_not_found'); END IF;
  SELECT * INTO m FROM public.maps WHERE id = p.current_map_id;
  hours := EXTRACT(EPOCH FROM (now() - COALESCE(p.last_farm_at, now()))) / 3600.0;
  max_hours := CASE WHEN p.is_vip AND p.vip_until > now() THEN 8 ELSE 5 END;
  hours := LEAST(hours, max_hours);
  xp_gain := FLOOR(hours * COALESCE(m.base_xp_per_hour, 100));
  gold_gain := FLOOR(hours * COALESCE(m.base_gold_per_hour, 50));
  IF m.id IS NOT NULL AND NOT m.is_safe AND random() < 0.1 THEN
    died := true; xp_gain := FLOOR(xp_gain * 0.5); gold_gain := 0;
    UPDATE public.players SET last_death_at = now(), hp = 1 WHERE id = _player_id;
  END IF;
  UPDATE public.players SET xp = xp + xp_gain, gold = gold + gold_gain, last_farm_at = now() WHERE id = _player_id;
  RETURN jsonb_build_object('hours', hours, 'xp_gained', xp_gain, 'gold_gained', gold_gain, 'died', died);
END; $$;

CREATE OR REPLACE FUNCTION public.update_nation_rivalry(_attacker uuid, _defender uuid, _delta int)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  UPDATE public.nations SET rivalry_score = rivalry_score + _delta WHERE id IN (_attacker, _defender);
  UPDATE public.nations SET divine_protection_until = now() + interval '30 minutes'
    WHERE id = _defender AND rivalry_score >= 100;
END; $$;

-- =====================================================
-- SEED DATA
-- =====================================================
INSERT INTO public.character_classes (code,name,emoji,description,attack_bonus,defense_bonus,hp_bonus,ability) VALUES
  ('paladin','Paladino','⚔️','Guerreiro sagrado que equilibra força e defesa',8,15,20,'Proteção Divina: +30% de defesa contra classes sombrias'),
  ('guerreiro','Guerreiro','🗡️','Mestre da luta corpo a corpo',20,5,15,'Grito de Guerra: +25% de ataque'),
  ('mago','Mago','🔮','Manipulador de magia arcana',15,8,10,'Explosão Arcana: dano splash 20%'),
  ('archer','Arqueiro','🏹','Atirador preciso',12,10,8,'Tiro Crítico: 15% de chance x2'),
  ('clerigo','Clérigo','✨','Curador e suporte',5,12,25,'Bênção Curadora: +10% HP ao vencer')
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.maps (code,name,description,min_level,max_level,monster_name,base_xp_per_hour,base_gold_per_hour,drop_rate,is_safe) VALUES
  ('plains','Planícies Iniciais','Mapa neutro para iniciantes',1,4,'Lobo Cinzento',80,40,0.03,true),
  ('forest','Floresta Sombria','Mapa de farm intermediário',5,9,'Orc Selvagem',150,80,0.05,false),
  ('desert','Deserto Escaldante','Para aventureiros experientes',10,14,'Escorpião Gigante',250,140,0.07,false),
  ('volcano','Vulcão Ardente','Apenas para os mais fortes',15,18,'Demônio Ígneo',400,220,0.09,false),
  ('void','Vazio Primordial','Reino dos lendários',19,20,'Sentinela do Vazio',600,350,0.12,false)
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.shop_items (code,name,description,category,price_ton,vip_days,reward_xp,reward_gold) VALUES
  ('vip_7','VIP 7 dias','Bônus de 30% em XP/Gold/HP por 7 dias','vip',1.5,7,0,0),
  ('vip_30','VIP 30 dias','Bônus de 30% em XP/Gold/HP por 30 dias','vip',5.0,30,0,0),
  ('vip_90','VIP 90 dias','Bônus de 30% em XP/Gold/HP por 90 dias','vip',12.0,90,0,0),
  ('potion_xp','Poção de XP','Recebe 5000 XP instantâneo','consumable',0.5,0,5000,0),
  ('potion_gold','Poção de Ouro','Recebe 2500 Gold instantâneo','consumable',0.5,0,0,2500)
ON CONFLICT (code) DO NOTHING;
