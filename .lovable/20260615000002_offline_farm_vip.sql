-- Fase 12: Economia Offline e Sistema VIP

-- 1. Extender Tabela de Jogadores para VIP e Offline
ALTER TABLE public.players 
ADD COLUMN IF NOT EXISTS is_vip BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS vip_until TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS current_map_id UUID,
ADD COLUMN IF NOT EXISTS last_sync_at TIMESTAMPTZ DEFAULT now();

-- 2. Tabela de Mapas/Regiões
CREATE TABLE IF NOT EXISTS public.maps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    min_level INT DEFAULT 1,
    base_xp_per_hour INT NOT NULL,
    base_gold_per_hour INT NOT NULL,
    danger_level FLOAT DEFAULT 0.1, -- Chance de morte por hora (0.1 = 10%)
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Seed de Mapas Iniciais
INSERT INTO public.maps (name, min_level, base_xp_per_hour, base_gold_per_hour, danger_level) VALUES
('Campos de Treinamento', 1, 100, 50, 0.0), -- Seguro
('Floresta dos Lobos', 5, 500, 250, 0.05),
('Caverna de Cristal', 10, 1200, 800, 0.15);

-- 4. RPC para Sincronizar Farm Offline
CREATE OR REPLACE FUNCTION public.sync_offline_farm(p_player_id UUID)
RETURNS JSONB LANGUAGE plpgsql AS $$
DECLARE
    v_last_sync TIMESTAMPTZ;
    v_is_vip BOOLEAN;
    v_hours_diff FLOAT;
    v_max_hours INT;
    v_xp_gain BIGINT;
    v_gold_gain BIGINT;
    v_map_xp INT;
    v_map_gold INT;
    v_danger_level FLOAT;
    v_survival_chance FLOAT;
    v_died BOOLEAN := FALSE;
    v_safe_map_id UUID;
BEGIN
    SELECT last_sync_at, is_vip, m.base_xp_per_hour, m.base_gold_per_hour, m.danger_level
    INTO v_last_sync, v_is_vip, v_map_xp, v_map_gold, v_danger_level
    FROM players p
    JOIN maps m ON p.current_map_id = m.id
    WHERE p.id = p_player_id;

    SELECT id INTO v_safe_map_id FROM maps WHERE danger_level = 0 LIMIT 1;

    v_max_hours := CASE WHEN v_is_vip THEN 8 ELSE 5 END;
    v_hours_diff := LEAST(v_max_hours, EXTRACT(EPOCH FROM (now() - v_last_sync)) / 3600);
    
    -- Lógica de Sobrevivência (Fase 12.4)
    -- Probabilidade de sobreviver T horas = (1 - perigo)^T
    v_survival_chance := POWER(1.0 - v_danger_level, v_hours_diff);
    
    IF random() > v_survival_chance AND v_danger_level > 0 THEN
        v_died := TRUE;
        -- Se morreu, sobreviveu em média metade do tempo ou um fator aleatório
        v_hours_diff := v_hours_diff * (random() * 0.5);
    END IF;

    v_xp_gain := (v_map_xp * v_hours_diff) * (CASE WHEN v_is_vip THEN 1.3 ELSE 1.0 END);
    v_gold_gain := (v_map_gold * v_hours_diff) * (CASE WHEN v_is_vip THEN 1.3 ELSE 1.0 END);

    IF v_died THEN
        -- Penalidade de 5% de Adena e retorno à capital
        UPDATE players SET 
            xp = xp + v_xp_gain,
            gold = (gold + v_gold_gain) * 0.95,
            current_map_id = v_safe_map_id,
            last_sync_at = now()
        WHERE id = p_player_id;
    ELSE
        UPDATE players SET 
            xp = xp + v_xp_gain, 
            gold = gold + v_gold_gain,
            last_sync_at = now()
        WHERE id = p_player_id;
    END IF;

    RETURN jsonb_build_object(
        'xp', v_xp_gain, 
        'gold', v_gold_gain, 
        'hours', v_hours_diff, 
        'died', v_died,
        'penalty', CASE WHEN v_died THEN '5% Adena lost' ELSE 'none' END
    );
END;
$$;