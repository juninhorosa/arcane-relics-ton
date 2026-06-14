
-- =========================================================
-- ENUMS
-- =========================================================
CREATE TYPE public.app_role AS ENUM ('admin','moderator','leader','player');
CREATE TYPE public.item_slot AS ENUM ('weapon','armor','helmet','boots','accessory','relic');
CREATE TYPE public.pack_status AS ENUM ('pending','confirmed','failed','refunded');

-- =========================================================
-- UPDATED_AT helper
-- =========================================================
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- =========================================================
-- PROFILES
-- =========================================================
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  telegram_id BIGINT UNIQUE,
  username TEXT,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles readable by authenticated" ON public.profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "profiles update own" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles insert own" ON public.profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);
CREATE TRIGGER trg_profiles_updated BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- USER ROLES
-- =========================================================
CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role public.app_role NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, role)
);
GRANT SELECT ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role public.app_role)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role);
$$;

CREATE POLICY "user_roles read own" ON public.user_roles FOR SELECT TO authenticated
  USING (auth.uid() = user_id OR public.has_role(auth.uid(),'admin'));
CREATE POLICY "user_roles admin manage" ON public.user_roles FOR ALL TO authenticated
  USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));

-- =========================================================
-- NATIONS
-- =========================================================
CREATE TABLE public.nations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  color TEXT,
  emblem_url TEXT,
  leader_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.nations TO authenticated, anon;
GRANT ALL ON public.nations TO service_role;
ALTER TABLE public.nations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "nations public read" ON public.nations FOR SELECT USING (true);
CREATE POLICY "nations admin write" ON public.nations FOR ALL TO authenticated
  USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_nations_updated BEFORE UPDATE ON public.nations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- PLAYERS
-- =========================================================
CREATE TABLE public.players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nation_id UUID REFERENCES public.nations(id) ON DELETE SET NULL,
  level INT NOT NULL DEFAULT 1,
  xp BIGINT NOT NULL DEFAULT 0,
  gold BIGINT NOT NULL DEFAULT 0,
  boost_xp_until TIMESTAMPTZ,
  last_farm_at TIMESTAMPTZ,
  total_battles INT NOT NULL DEFAULT 0,
  wins INT NOT NULL DEFAULT 0,
  losses INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE ON public.players TO authenticated;
GRANT ALL ON public.players TO service_role;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
CREATE POLICY "players read all" ON public.players FOR SELECT TO authenticated USING (true);
CREATE POLICY "players insert own" ON public.players FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "players update own or admin" ON public.players FOR UPDATE TO authenticated
  USING (auth.uid() = user_id OR public.has_role(auth.uid(),'admin'))
  WITH CHECK (auth.uid() = user_id OR public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_players_updated BEFORE UPDATE ON public.players FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- ITEM TEMPLATES
-- =========================================================
CREATE TABLE public.item_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  class INT NOT NULL CHECK (class BETWEEN 1 AND 20),
  rank_name TEXT NOT NULL,
  slot public.item_slot NOT NULL,
  attack INT NOT NULL DEFAULT 0,
  defense INT NOT NULL DEFAULT 0,
  hp INT NOT NULL DEFAULT 0,
  special_effect TEXT,
  is_relic BOOLEAN NOT NULL DEFAULT false,
  pack_source TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.item_templates TO authenticated, anon;
GRANT ALL ON public.item_templates TO service_role;
ALTER TABLE public.item_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "templates public read" ON public.item_templates FOR SELECT USING (true);
CREATE POLICY "templates admin write" ON public.item_templates FOR ALL TO authenticated
  USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));

-- =========================================================
-- INVENTORY
-- =========================================================
CREATE TABLE public.inventory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  template_id UUID NOT NULL REFERENCES public.item_templates(id),
  quantity INT NOT NULL DEFAULT 1,
  acquired_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_inventory_player ON public.inventory(player_id);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.inventory TO authenticated;
GRANT ALL ON public.inventory TO service_role;
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;
CREATE POLICY "inventory owner manage" ON public.inventory FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND (p.user_id = auth.uid() OR public.has_role(auth.uid(),'admin'))))
  WITH CHECK (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND (p.user_id = auth.uid() OR public.has_role(auth.uid(),'admin'))));

-- =========================================================
-- EQUIPMENT
-- =========================================================
CREATE TABLE public.equipment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  slot public.item_slot NOT NULL,
  inventory_item_id UUID NOT NULL REFERENCES public.inventory(id) ON DELETE CASCADE,
  equipped_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(player_id, slot)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.equipment TO authenticated;
GRANT ALL ON public.equipment TO service_role;
ALTER TABLE public.equipment ENABLE ROW LEVEL SECURITY;
CREATE POLICY "equipment owner manage" ON public.equipment FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND (p.user_id = auth.uid() OR public.has_role(auth.uid(),'admin'))))
  WITH CHECK (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND (p.user_id = auth.uid() OR public.has_role(auth.uid(),'admin'))));

-- =========================================================
-- PACKS
-- =========================================================
CREATE TABLE public.packs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  ton_price NUMERIC(20,4) NOT NULL,
  item_class INT NOT NULL,
  gold_reward BIGINT NOT NULL DEFAULT 0,
  boost_xp_hours INT NOT NULL DEFAULT 0,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.packs TO authenticated, anon;
GRANT ALL ON public.packs TO service_role;
ALTER TABLE public.packs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "packs public read" ON public.packs FOR SELECT USING (active = true OR public.has_role(auth.uid(),'admin'));
CREATE POLICY "packs admin write" ON public.packs FOR ALL TO authenticated
  USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));

-- =========================================================
-- PACK PURCHASES
-- =========================================================
CREATE TABLE public.pack_purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  pack_id UUID NOT NULL REFERENCES public.packs(id),
  ton_amount NUMERIC(20,4) NOT NULL,
  status public.pack_status NOT NULL DEFAULT 'pending',
  tx_hash TEXT UNIQUE,
  from_address TEXT,
  item_granted_id UUID REFERENCES public.inventory(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  confirmed_at TIMESTAMPTZ
);
CREATE INDEX idx_pack_purchases_player ON public.pack_purchases(player_id);
GRANT SELECT, INSERT ON public.pack_purchases TO authenticated;
GRANT ALL ON public.pack_purchases TO service_role;
ALTER TABLE public.pack_purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pack_purchases owner read" ON public.pack_purchases FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()) OR public.has_role(auth.uid(),'admin'));
CREATE POLICY "pack_purchases owner insert" ON public.pack_purchases FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()));

-- =========================================================
-- TON TRANSACTIONS
-- =========================================================
CREATE TABLE public.ton_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  tx_hash TEXT UNIQUE NOT NULL,
  amount_ton NUMERIC(20,4) NOT NULL,
  from_address TEXT,
  to_address TEXT,
  confirmed_at TIMESTAMPTZ,
  raw_payload JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.ton_transactions TO authenticated;
GRANT ALL ON public.ton_transactions TO service_role;
ALTER TABLE public.ton_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ton_tx owner read" ON public.ton_transactions FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()) OR public.has_role(auth.uid(),'admin'));

-- =========================================================
-- LOGS
-- =========================================================
CREATE TABLE public.gold_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  amount BIGINT NOT NULL,
  reason TEXT NOT NULL,
  ref_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_gold_log_player ON public.gold_log(player_id);
GRANT SELECT ON public.gold_log TO authenticated;
GRANT ALL ON public.gold_log TO service_role;
ALTER TABLE public.gold_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "gold_log owner read" ON public.gold_log FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()) OR public.has_role(auth.uid(),'admin'));

CREATE TABLE public.xp_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  amount BIGINT NOT NULL,
  reason TEXT NOT NULL,
  ref_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_xp_log_player ON public.xp_log(player_id);
GRANT SELECT ON public.xp_log TO authenticated;
GRANT ALL ON public.xp_log TO service_role;
ALTER TABLE public.xp_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "xp_log owner read" ON public.xp_log FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()) OR public.has_role(auth.uid(),'admin'));

-- =========================================================
-- BATTLES
-- =========================================================
CREATE TABLE public.battles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attacker_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  defender_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  winner_id UUID REFERENCES public.players(id),
  attacker_power INT NOT NULL,
  defender_power INT NOT NULL,
  gold_stolen BIGINT NOT NULL DEFAULT 0,
  xp_awarded BIGINT NOT NULL DEFAULT 0,
  relic_stolen_id UUID REFERENCES public.item_templates(id),
  log JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_battles_attacker ON public.battles(attacker_id);
CREATE INDEX idx_battles_defender ON public.battles(defender_id);
GRANT SELECT ON public.battles TO authenticated;
GRANT ALL ON public.battles TO service_role;
ALTER TABLE public.battles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "battles participants read" ON public.battles FOR SELECT TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.players p WHERE p.id IN (attacker_id, defender_id) AND p.user_id = auth.uid())
    OR public.has_role(auth.uid(),'admin')
  );

-- =========================================================
-- RELICS
-- =========================================================
CREATE TABLE public.relics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID UNIQUE NOT NULL REFERENCES public.item_templates(id),
  current_holder_player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  last_transferred_at TIMESTAMPTZ,
  history JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.relics TO authenticated, anon;
GRANT ALL ON public.relics TO service_role;
ALTER TABLE public.relics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "relics public read" ON public.relics FOR SELECT USING (true);

-- =========================================================
-- NATION RANKING (snapshots)
-- =========================================================
CREATE TABLE public.nation_ranking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nation_id UUID NOT NULL REFERENCES public.nations(id) ON DELETE CASCADE,
  total_power BIGINT NOT NULL DEFAULT 0,
  total_players INT NOT NULL DEFAULT 0,
  total_gold BIGINT NOT NULL DEFAULT 0,
  rank INT,
  snapshot_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(nation_id, snapshot_date)
);
GRANT SELECT ON public.nation_ranking TO authenticated, anon;
GRANT ALL ON public.nation_ranking TO service_role;
ALTER TABLE public.nation_ranking ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ranking public read" ON public.nation_ranking FOR SELECT USING (true);

-- =========================================================
-- XP FORMULA: floor(100 * level^2.05)
-- =========================================================
CREATE OR REPLACE FUNCTION public.xp_for_level(_level INT)
RETURNS BIGINT LANGUAGE sql IMMUTABLE SET search_path = public AS $$
  SELECT FLOOR(100 * POWER(_level::numeric, 2.05))::bigint;
$$;

CREATE OR REPLACE FUNCTION public.total_xp_for_level(_level INT)
RETURNS BIGINT LANGUAGE sql IMMUTABLE SET search_path = public AS $$
  SELECT COALESCE(SUM(public.xp_for_level(g)),0)::bigint
  FROM generate_series(1, GREATEST(_level-1,0)) g;
$$;

-- =========================================================
-- AUTO-CREATE PROFILE ON SIGNUP
-- =========================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name, username)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'display_name', NEW.raw_user_meta_data->>'username')
  ON CONFLICT (id) DO NOTHING;
  INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'player')
  ON CONFLICT DO NOTHING;
  RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =========================================================
-- SEED: NATIONS
-- =========================================================
INSERT INTO public.nations (code,name,description,color) VALUES
  ('IRON','Império de Ferro','Forjadores inabaláveis, mestres da defesa.','#9CA3AF'),
  ('BLOOD','Clã do Sangue','Guerreiros sanguinários movidos pela fúria.','#DC2626'),
  ('SHADOW','Ordem da Sombra','Assassinos silenciosos das trevas.','#6B21A8'),
  ('LIGHT','Reino da Luz','Paladinos sagrados da justiça eterna.','#FBBF24'),
  ('CHAOS','Horda do Caos','Bárbaros caóticos que destroem tudo.','#F97316');

-- =========================================================
-- SEED: PACKS
-- =========================================================
INSERT INTO public.packs (code,name,description,ton_price,item_class,gold_reward,boost_xp_hours) VALUES
  ('PACK_1','O Caminho Divino','1 Item Classe 17 (Divino) + 500 Ouro',1,17,500,0),
  ('PACK_2','A Forja Lendária','1 Item Classe 15 (Lendário) + 1500 Ouro',3,15,1500,0),
  ('PACK_3','O Despertar Místico','1 Item Classe 12 (Místico) + 5000 Ouro + Boost XP 24h',7,12,5000,24);

-- =========================================================
-- SEED: ITEM TEMPLATES
-- Rank names by class (1-20)
-- =========================================================
DO $seed$
DECLARE
  rank_name_for INT[] := ARRAY[1];
  ranks TEXT[] := ARRAY[
    'Comum','Enferrujado','Desgastado','Funcional','Reforçado',
    'Veterano','Soldado','Capitão','Elite','Guardião',
    'Heroico','Místico','Arcano','Épico','Lendário',
    'Etéreo','Divino','Soberano','Titã','SUPREMO'
  ];
  slots TEXT[] := ARRAY['weapon','armor','helmet','boots','accessory'];
  c INT;
  s TEXT;
  base_atk INT; base_def INT; base_hp INT;
BEGIN
  FOR c IN 1..20 LOOP
    FOREACH s IN ARRAY slots LOOP
      base_atk := CASE WHEN s IN ('weapon','accessory') THEN c*c*3 ELSE c*c END;
      base_def := CASE WHEN s IN ('armor','helmet','boots') THEN c*c*3 ELSE c*c END;
      base_hp  := c*c*5;
      INSERT INTO public.item_templates (code,name,class,rank_name,slot,attack,defense,hp,special_effect,is_relic,pack_source)
      VALUES (
        'C'||c||'_'||upper(s),
        ranks[c]||' '||CASE s
          WHEN 'weapon' THEN 'Espada'
          WHEN 'armor' THEN 'Armadura'
          WHEN 'helmet' THEN 'Elmo'
          WHEN 'boots' THEN 'Botas'
          WHEN 'accessory' THEN 'Amuleto'
        END,
        c, ranks[c], s::public.item_slot,
        base_atk, base_def, base_hp,
        CASE WHEN c >= 15 THEN 'Bônus de '||(c*2)||'% em batalhas' ELSE NULL END,
        c = 20,
        CASE c WHEN 17 THEN 'PACK_1' WHEN 15 THEN 'PACK_2' WHEN 12 THEN 'PACK_3' ELSE NULL END
      );
    END LOOP;
  END LOOP;
END $seed$;

-- Relíquias específicas (classe 20, slot relic) para cada nação
INSERT INTO public.item_templates (code,name,class,rank_name,slot,attack,defense,hp,special_effect,is_relic)
VALUES
  ('RELIC_IRON','Coração de Ferro Eterno',20,'SUPREMO','relic',500,1500,5000,'+30% defesa para toda a nação',true),
  ('RELIC_BLOOD','Lâmina de Sangue Imortal',20,'SUPREMO','relic',1500,500,5000,'+30% ataque para toda a nação',true),
  ('RELIC_SHADOW','Manto da Sombra Suprema',20,'SUPREMO','relic',1000,1000,5000,'+25% chance de roubo crítico',true),
  ('RELIC_LIGHT','Coroa da Luz Divina',20,'SUPREMO','relic',1000,1000,7000,'+50% cura entre batalhas',true),
  ('RELIC_CHAOS','Estandarte do Caos Primordial',20,'SUPREMO','relic',2000,800,3000,'+40% ouro roubado',true);

INSERT INTO public.relics (template_id)
SELECT id FROM public.item_templates WHERE code LIKE 'RELIC_%';
