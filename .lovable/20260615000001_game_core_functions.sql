-- Core Game Functions and Tables (Missing Definitions)

-- Function to update 'updated_at' column automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- RPC to get nation player counts (used for balancing)
CREATE OR REPLACE FUNCTION get_nation_player_counts()
RETURNS TABLE(code TEXT, count BIGINT) AS $$
  SELECT n.code, COUNT(p.id) 
  FROM nations n 
  LEFT JOIN players p ON n.id = p.nation_id 
  GROUP BY n.code;
$$ LANGUAGE sql STABLE;

-- RPC to calculate player power (shared logic)
CREATE OR REPLACE FUNCTION calculate_player_power(p_player_id UUID, p_level INT)
RETURNS INT AS $$
DECLARE
    v_atk INT := 0;
    v_def INT := 0;
    v_hp INT := 0;
BEGIN
    SELECT 
        COALESCE(SUM(it.attack), 0),
        COALESCE(SUM(it.defense), 0),
        COALESCE(SUM(it.hp), 0)
    INTO 
        v_atk, v_def, v_hp
    FROM equipment eq
    JOIN inventory inv ON eq.inventory_item_id = inv.id
    JOIN item_templates it ON inv.template_id = it.id
    WHERE eq.player_id = p_player_id;

    RETURN (p_level * 10) + v_atk + v_def + (v_hp / 10);
END;
$$ LANGUAGE plpgsql;

-- World Bosses Table (Missing Definition)
CREATE TABLE IF NOT EXISTS world_bosses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    level INTEGER NOT NULL DEFAULT 1,
    max_hp BIGINT NOT NULL,
    current_hp BIGINT NOT NULL,
    status TEXT NOT NULL DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'active', 'defeated')),
    rewards JSONB NOT NULL DEFAULT '{}'::jsonb,
    scheduled_at TIMESTAMPTZ,
    defeated_at TIMESTAMPTZ,
    last_hit_player_id UUID REFERENCES players(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trigger for world_bosses updated_at
CREATE TRIGGER update_world_bosses_updated_at
    BEFORE UPDATE ON world_bosses
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Boss Damage Ranking View (Missing Definition)
CREATE OR REPLACE VIEW boss_damage_ranking AS
SELECT 
    bd.boss_id,
    bd.player_id,
    bd.damage,
    prof.display_name,
    prof.username
FROM boss_damage bd
JOIN players play ON bd.player_id = play.id
JOIN profiles prof ON play.user_id = prof.id;

-- Active Invasions Table (Missing Definition)
CREATE TABLE IF NOT EXISTS active_invasions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attacker_player_id UUID REFERENCES players(id) ON DELETE CASCADE,
    target_nation_id UUID REFERENCES nations(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'starting' CHECK (status IN ('starting', 'attacking', 'ended')),
    relic_health BIGINT NOT NULL,
    max_relic_health BIGINT NOT NULL DEFAULT 50000, -- Default HP da relíquia
    preparation_ends_at TIMESTAMPTZ NOT NULL,
    attack_ends_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trigger for active_invasions updated_at
CREATE TRIGGER update_active_invasions_updated_at
    BEFORE UPDATE ON active_invasions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- RLS para active_invasions
ALTER TABLE active_invasions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Invasoes sao visiveis por todos" ON active_invasions FOR SELECT USING (true);

-- RLS para invasion_participants (já criada, mas garantir policy)
ALTER TABLE invasion_participants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Participantes de invasao sao visiveis por todos" ON invasion_participants FOR SELECT USING (true);
CREATE POLICY "Participantes podem se juntar a invasao" ON invasion_participants FOR INSERT TO authenticated WITH CHECK (player_id = (SELECT id FROM players WHERE user_id = auth.uid()));
CREATE POLICY "Participantes podem atualizar seu HP" ON invasion_participants FOR UPDATE TO authenticated USING (player_id = (SELECT id FROM players WHERE user_id = auth.uid()));