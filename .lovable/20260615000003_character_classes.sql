-- =========================================================
-- CHARACTER CLASSES (Paladin, Guerreiro, Mago, Archer, Clérigo)
-- =========================================================

-- Create Enum for Classes
CREATE TYPE public.character_class AS ENUM ('paladin','guerreiro','mago','archer','clerigo');

-- Add class_id to players table
ALTER TABLE public.players ADD COLUMN class_id UUID REFERENCES public.character_classes(id) ON DELETE SET NULL;

-- Create character_classes table
CREATE TABLE IF NOT EXISTS public.character_classes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code character_class NOT NULL UNIQUE,
  name TEXT NOT NULL,
  emoji TEXT NOT NULL,
  description TEXT,
  attack_bonus INT NOT NULL DEFAULT 0,
  defense_bonus INT NOT NULL DEFAULT 0,
  hp_bonus INT NOT NULL DEFAULT 0,
  ability TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

GRANT SELECT ON public.character_classes TO authenticated, anon;
GRANT ALL ON public.character_classes TO service_role;
ALTER TABLE public.character_classes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "classes public read" ON public.character_classes FOR SELECT USING (true);
CREATE POLICY "classes admin write" ON public.character_classes FOR ALL TO authenticated
  USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin'));
CREATE TRIGGER trg_character_classes_updated BEFORE UPDATE ON public.character_classes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- SEED: CHARACTER CLASSES
-- =========================================================
INSERT INTO public.character_classes (code, name, emoji, description, attack_bonus, defense_bonus, hp_bonus, ability)
VALUES
  ('paladin', 'Paladino', '⚔️', 'Guerreiro sagrado que equilibra força e defesa', 8, 15, 20, 'Proteção Divina: +30% de defesa em combates contra classes sombrias'),
  ('guerreiro', 'Guerreiro', '🗡️', 'Mestre da luta corpo a corpo com poder devastador', 20, 5, 15, 'Grito de Guerra: +25% de ataque contra inimigos únicos'),
  ('mago', 'Mago', '🔮', 'Manipulador de magia arcana com poderes místicos', 15, 8, 10, 'Explosão Arcana: Pode fazer dano splash (20% do dano a inimigos próximos)'),
  ('archer', 'Arqueiro', '🏹', 'Atirador preciso que evita confrontos diretos', 12, 10, 8, 'Tiro Crítico: 15% de chance de acerto crítico (dano x2)'),
  ('clerigo', 'Clérigo', '✨', 'Curador e suporte que oferece bênçãos divinas', 5, 12, 25, 'Bênção Curadora: Recupera 10% de HP ao vencer combate');
