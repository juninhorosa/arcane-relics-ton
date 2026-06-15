-- =========================================================
-- CHARACTER SKILLS SYSTEM
-- =========================================================

-- Enum for skill types
CREATE TYPE public.skill_type AS ENUM ('active','passive','buff','debuff');
CREATE TYPE public.skill_rarity AS ENUM ('common','uncommon','rare','epic','legendary');

-- =========================================================
-- SKILLS TABLE
-- =========================================================
CREATE TABLE IF NOT EXISTS public.skills (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  emoji TEXT NOT NULL,
  class_id UUID NOT NULL REFERENCES public.character_classes(id) ON DELETE CASCADE,
  skill_type public.skill_type NOT NULL,
  rarity public.skill_rarity NOT NULL DEFAULT 'common',
  
  -- Requirements
  required_level INT NOT NULL DEFAULT 1,
  required_skill_points INT NOT NULL DEFAULT 1,
  
  -- Mechanics
  cooldown_seconds INT DEFAULT 0,
  energy_cost INT DEFAULT 0,
  
  -- Combat Stats
  attack_multiplier FLOAT DEFAULT 0.0,   -- % of ATK stat
  defense_multiplier FLOAT DEFAULT 0.0,  -- % of DEF stat
  hp_multiplier FLOAT DEFAULT 0.0,       -- % of MAX HP
  
  -- Passive Bonuses
  attack_bonus INT DEFAULT 0,
  defense_bonus INT DEFAULT 0,
  hp_bonus INT DEFAULT 0,
  crit_chance_bonus FLOAT DEFAULT 0.0,   -- %
  
  -- Special Effects
  special_effect TEXT,
  can_miss BOOLEAN DEFAULT false,
  can_crit BOOLEAN DEFAULT false,
  
  -- Progression
  max_level INT NOT NULL DEFAULT 5,
  scaling_per_level FLOAT DEFAULT 0.1,   -- 10% increase per level
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

GRANT SELECT ON public.skills TO authenticated, anon;
GRANT ALL ON public.skills TO service_role;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "skills public read" ON public.skills FOR SELECT USING (true);
CREATE POLICY "skills admin write" ON public.skills FOR ALL TO authenticated
  USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_skills_updated BEFORE UPDATE ON public.skills FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- PLAYER SKILLS (Skills aprendidas)
-- =========================================================
CREATE TABLE IF NOT EXISTS public.player_skills (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  skill_id UUID NOT NULL REFERENCES public.skills(id) ON DELETE CASCADE,
  skill_level INT NOT NULL DEFAULT 1,
  learned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_used_at TIMESTAMPTZ,
  times_used INT NOT NULL DEFAULT 0,
  
  UNIQUE(player_id, skill_id)
);

GRANT SELECT, INSERT, UPDATE ON public.player_skills TO authenticated;
GRANT ALL ON public.player_skills TO service_role;
ALTER TABLE public.player_skills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "player_skills read own" ON public.player_skills FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()));
CREATE POLICY "player_skills manage own" ON public.player_skills FOR INSERT, UPDATE TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.players p WHERE p.id = player_id AND p.user_id = auth.uid()));
CREATE TRIGGER trg_player_skills_updated BEFORE UPDATE ON public.player_skills FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- SKILL POINTS ALLOCATION
-- =========================================================
ALTER TABLE public.players ADD COLUMN IF NOT EXISTS skill_points INT NOT NULL DEFAULT 0;
ALTER TABLE public.players ADD COLUMN IF NOT EXISTS skill_points_used INT NOT NULL DEFAULT 0;

-- =========================================================
-- SEED: PALADIN SKILLS
-- =========================================================
INSERT INTO public.skills (code, name, description, emoji, class_id, skill_type, rarity, required_level, required_skill_points, 
                          cooldown_seconds, energy_cost, attack_multiplier, defense_multiplier, attack_bonus, defense_bonus, hp_bonus,
                          special_effect, can_crit, max_level, scaling_per_level)
SELECT 
  'PALADIN_HOLY_STRIKE' as code,
  'Golpe Sagrado' as name,
  'Ataque com poder divino. Causa dano baseado em ATK' as description,
  '✨' as emoji,
  cc.id,
  'active'::public.skill_type,
  'common'::public.skill_rarity,
  1, 1, 6, 10, 1.5, 0, 0, 0, 0, 'Ignora 20% da defesa do inimigo', true, 3, 0.2
FROM public.character_classes cc WHERE cc.code = 'paladin'
UNION ALL
SELECT 'PALADIN_DIVINE_SHIELD', 'Escudo Divino', 'Aumenta sua defesa em 50% por 10s', '🛡️', cc.id, 'buff'::public.skill_type, 'uncommon'::public.skill_rarity,
       3, 2, 12, 15, 0, 0, 0, 40, 0, '+50% DEF temporário', false, 4, 0.15
FROM public.character_classes cc WHERE cc.code = 'paladin'
UNION ALL
SELECT 'PALADIN_CONVICTION', 'Convicção Divina', 'Passiva: +15% Defesa permanente', '💎', cc.id, 'passive'::public.skill_type, 'uncommon'::public.skill_rarity,
       1, 0, 0, 0, 0, 0, 0, 20, 0, 'Bônus sempre ativo', false, 5, 0.1
FROM public.character_classes cc WHERE cc.code = 'paladin'
UNION ALL
SELECT 'PALADIN_WRATH', 'Ira Sagrada', 'Ataque que causa dano progressivo (max 3 stacks)', '⚡', cc.id, 'active'::public.skill_type, 'rare'::public.skill_rarity,
       6, 4, 5, 20, 2.0, 0, 0, 0, 0, 'Acumula até 3 stacks, cada stack +30% dano', true, 5, 0.25
FROM public.character_classes cc WHERE cc.code = 'paladin'
UNION ALL
SELECT 'PALADIN_REDEMPTION', 'Redenção', 'Cura aliado ou a si mesmo. Requer level 10', '🩹', cc.id, 'active'::public.skill_type, 'epic'::public.skill_rarity,
       10, 6, 15, 25, 0, 0, 0, 0, 30, 'Cura 40% do HP máximo', false, 5, 0.15
FROM public.character_classes cc WHERE cc.code = 'paladin';

-- =========================================================
-- SEED: GUERREIRO SKILLS
-- =========================================================
INSERT INTO public.skills (code, name, description, emoji, class_id, skill_type, rarity, required_level, required_skill_points, 
                          cooldown_seconds, energy_cost, attack_multiplier, defense_multiplier, attack_bonus, defense_bonus, hp_bonus,
                          special_effect, can_crit, max_level, scaling_per_level)
SELECT 
  'WARRIOR_CLEAVE' as code,
  'Golpe Duplo' as name,
  'Ataque explosivo que atinge área' as description,
  '🗡️' as emoji,
  cc.id,
  'active'::public.skill_type,
  'common'::public.skill_rarity,
  1, 1, 5, 12, 1.8, 0, 0, 0, 0, 'Atinge inimigos próximos também', true, 3, 0.25
FROM public.character_classes cc WHERE cc.code = 'guerreiro'
UNION ALL
SELECT 'WARRIOR_BLOODLUST', 'Sede de Sangue', 'Passiva: +20% ATK enquanto atacando', '🩸', cc.id, 'passive'::public.skill_type, 'uncommon'::public.skill_rarity,
       1, 0, 0, 0, 0, 0, 30, 0, 0, 'Bônus ativo em combate', false, 5, 0.2
FROM public.character_classes cc WHERE cc.code = 'guerreiro'
UNION ALL
SELECT 'WARRIOR_EXECUTE', 'Execução', 'Golpe mortal. Mais dano contra inimigos fracos (< 30% HP)', '💀', cc.id, 'active'::public.skill_type, 'rare'::public.skill_rarity,
       5, 3, 8, 20, 3.0, 0, 0, 0, 0, 'Dano x2 vs inimigos <30% HP', true, 4, 0.3
FROM public.character_classes cc WHERE cc.code = 'guerreiro'
UNION ALL
SELECT 'WARRIOR_SHIELDBREAKER', 'Quebrador de Escudos', 'Ataque que ignora 50% da defesa inimiga', '⚔️', cc.id, 'active'::public.skill_type, 'epic'::public.skill_rarity,
       8, 5, 6, 18, 2.5, 0, 0, 0, 0, 'Ignora 50% defesa do alvo', true, 5, 0.2
FROM public.character_classes cc WHERE cc.code = 'guerreiro'
UNION ALL
SELECT 'WARRIOR_ENDURANCE', 'Resistência de Aço', 'Passiva: +25% HP máximo', '💪', cc.id, 'passive'::public.skill_type, 'epic'::public.skill_rarity,
       10, 6, 0, 0, 0, 0, 0, 0, 50, 'Aumenta HP permanentemente', false, 5, 0.25
FROM public.character_classes cc WHERE cc.code = 'guerreiro';

-- =========================================================
-- SEED: MAGO SKILLS
-- =========================================================
INSERT INTO public.skills (code, name, description, emoji, class_id, skill_type, rarity, required_level, required_skill_points, 
                          cooldown_seconds, energy_cost, attack_multiplier, defense_multiplier, attack_bonus, defense_bonus, hp_bonus,
                          special_effect, can_crit, max_level, scaling_per_level)
SELECT 
  'MAGE_FIREBALL' as code,
  'Bola de Fogo' as name,
  'Lança fogo que causa dano em área' as description,
  '🔥' as emoji,
  cc.id,
  'active'::public.skill_type,
  'common'::public.skill_rarity,
  1, 1, 4, 15, 2.0, 0, 0, 0, 0, 'Atinge 30% do dano em inimigos próximos (splash)', true, 4, 0.3
FROM public.character_classes cc WHERE cc.code = 'mago'
UNION ALL
SELECT 'MAGE_ARCANE_MASTERY', 'Domínio Arcano', 'Passiva: +10% dano mágico por nível', '🔮', cc.id, 'passive'::public.skill_type, 'rare'::public.skill_rarity,
       1, 0, 0, 0, 0, 0, 25, 0, 0, 'Aumenta todas as magias', false, 5, 0.15
FROM public.character_classes cc WHERE cc.code = 'mago'
UNION ALL
SELECT 'MAGE_ICE_STORM', 'Tempestade de Gelo', 'Congela área, reduz velocidade do inimigo em 50%', '❄️', cc.id, 'active'::public.skill_type, 'epic'::public.skill_rarity,
       6, 4, 8, 20, 1.5, 0, 0, 0, 0, 'Diminui ATK/movimento do alvo em 50%', true, 5, 0.2
FROM public.character_classes cc WHERE cc.code = 'mago'
UNION ALL
SELECT 'MAGE_TIMERIFT', 'Fratura Temporal', 'Volta ao tempo anterior de um ataque. Requer level 12', '⏳', cc.id, 'active'::public.skill_type, 'legendary'::public.skill_rarity,
       12, 7, 20, 30, 0, 0, 0, 0, 0, 'Desfaz último ataque sofrido', false, 3, 0.3
FROM public.character_classes cc WHERE cc.code = 'mago'
UNION ALL
SELECT 'MAGE_MANA_SHIELD', 'Escudo de Mana', 'Reduz dano em 30%, custando mana', '✨', cc.id, 'buff'::public.skill_type, 'uncommon'::public.skill_rarity,
       4, 2, 10, 12, 0, 0.5, 0, 15, 20, 'Absorve dano usando mana', false, 4, 0.1
FROM public.character_classes cc WHERE cc.code = 'mago';

-- =========================================================
-- SEED: ARQUEIRO SKILLS
-- =========================================================
INSERT INTO public.skills (code, name, description, emoji, class_id, skill_type, rarity, required_level, required_skill_points, 
                          cooldown_seconds, energy_cost, attack_multiplier, defense_multiplier, attack_bonus, defense_bonus, hp_bonus,
                          special_effect, can_crit, max_level, scaling_per_level)
SELECT 
  'ARCHER_PIERCING_SHOT' as code,
  'Tiro Perfurante' as name,
  'Flecha que ignora armadura' as description,
  '🏹' as emoji,
  cc.id,
  'active'::public.skill_type,
  'common'::public.skill_rarity,
  1, 1, 3, 8, 1.6, 0, 0, 0, 0, 'Ignora 40% defesa alvo', true, 4, 0.2
FROM public.character_classes cc WHERE cc.code = 'archer'
UNION ALL
SELECT 'ARCHER_CRITICAL_MASTERY', 'Precisão Mortal', 'Passiva: +20% taxa crítico permanente', '💥', cc.id, 'passive'::public.skill_type, 'rare'::public.skill_rarity,
       1, 0, 0, 0, 0, 0, 0, 0, 0, '+20% crítico sempre', false, 5, 0.1
FROM public.character_classes cc WHERE cc.code = 'archer'
UNION ALL
SELECT 'ARCHER_MULTISHOT', 'Tiro Múltiplo', 'Dispara 3 flechas em sequência', '🎯', cc.id, 'active'::public.skill_type, 'uncommon'::public.skill_rarity,
       4, 2, 5, 12, 1.2, 0, 0, 0, 0, 'Ataque x3 com chance de crítico em cada', true, 5, 0.15
FROM public.character_classes cc WHERE cc.code = 'archer'
UNION ALL
SELECT 'ARCHER_EVASION', 'Esquiva Expert', 'Passiva: +15% chance de esquivar ataques', '🌪️', cc.id, 'passive'::public.skill_type, 'epic'::public.skill_rarity,
       7, 4, 0, 0, 0, 0, 0, 10, 0, 'Esquiva 15% dos ataques automaticamente', false, 5, 0.12
FROM public.character_classes cc WHERE cc.code = 'archer'
UNION ALL
SELECT 'ARCHER_DEADSHOT', 'Tiro Certeiro', 'Ataque com 100% de crítico, requer carga', '🎪', cc.id, 'active'::public.skill_type, 'legendary'::public.skill_rarity,
       11, 6, 12, 25, 3.5, 0, 0, 0, 0, 'Crítico garantido, 3.5x dano', true, 4, 0.3
FROM public.character_classes cc WHERE cc.code = 'archer';

-- =========================================================
-- SEED: CLÉRIGO SKILLS
-- =========================================================
INSERT INTO public.skills (code, name, description, emoji, class_id, skill_type, rarity, required_level, required_skill_points, 
                          cooldown_seconds, energy_cost, attack_multiplier, defense_multiplier, attack_bonus, defense_bonus, hp_bonus,
                          special_effect, can_crit, max_level, scaling_per_level)
SELECT 
  'CLERIC_HEAL' as code,
  'Cura' as name,
  'Cura aliado restaurando HP' as description,
  '✨' as emoji,
  cc.id,
  'active'::public.skill_type,
  'common'::public.skill_rarity,
  1, 1, 5, 10, 0, 0, 0, 0, 30, 'Restaura 35% HP máximo', false, 4, 0.15
FROM public.character_classes cc WHERE cc.code = 'clerigo'
UNION ALL
SELECT 'CLERIC_HOLY_AURA', 'Aura Sagrada', 'Passiva: +20% DEF para todos aliados próximos', '🌟', cc.id, 'passive'::public.skill_type, 'rare'::public.skill_rarity,
       1, 0, 0, 0, 0, 0, 0, 20, 0, 'Bônus de grupo', false, 5, 0.1
FROM public.character_classes cc WHERE cc.code = 'clerigo'
UNION ALL
SELECT 'CLERIC_RESURRECT', 'Ressurreição', 'Traz aliado de volta à vida (level 15 necessário)', '♻️', cc.id, 'active'::public.skill_type, 'legendary'::public.skill_rarity,
       15, 8, 30, 50, 0, 0, 0, 0, 100, 'Revive com 50% HP', false, 3, 0.2
FROM public.character_classes cc WHERE cc.code = 'clerigo'
UNION ALL
SELECT 'CLERIC_PROTECTION', 'Proteção Divina', 'Escudo que absorve dano por 15s', '🛡️', cc.id, 'buff'::public.skill_type, 'epic'::public.skill_rarity,
       6, 3, 10, 15, 0, 0.4, 0, 30, 20, 'Absorve dano equivalente a 40% DEF', false, 5, 0.15
FROM public.character_classes cc WHERE cc.code = 'clerigo'
UNION ALL
SELECT 'CLERIC_SMITE', 'Justiça Divina', 'Ataque sagrado contra sombra/maligno', '⚔️', cc.id, 'active'::public.skill_type, 'rare'::public.skill_rarity,
       5, 2, 6, 12, 1.8, 0, 0, 0, 0, 'Dano x2 contra inimigos maignos', true, 5, 0.2
FROM public.character_classes cc WHERE cc.code = 'clerigo';
