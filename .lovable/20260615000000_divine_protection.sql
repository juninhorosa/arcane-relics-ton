-- Fase 9.5: Proteção Divina e Rivalidade entre Nações

-- Adicionar coluna de proteção divina na tabela de nações
ALTER TABLE public.nations ADD COLUMN divine_protection_until TIMESTAMPTZ;

-- Tabela para rastrear vitórias consecutivas de uma nação sobre outra
CREATE TABLE public.nation_consecutive_wins (
    winner_nation_id UUID REFERENCES public.nations(id) ON DELETE CASCADE,
    loser_nation_id UUID REFERENCES public.nations(id) ON DELETE CASCADE,
    count INT NOT NULL DEFAULT 0,
    PRIMARY KEY (winner_nation_id, loser_nation_id)
);

ALTER TABLE public.nation_consecutive_wins ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública de rivalidades" ON public.nation_consecutive_wins FOR SELECT USING (true);

-- RPC para atualização atômica da rivalidade
CREATE OR REPLACE FUNCTION public.update_nation_rivalry(p_winner_id UUID, p_loser_id UUID)
RETURNS INT LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_count INT;
BEGIN
    -- Incrementar vitórias seguidas do vencedor sobre o perdedor
    INSERT INTO public.nation_consecutive_wins (winner_nation_id, loser_nation_id, count)
    VALUES (p_winner_id, p_loser_id, 1)
    ON CONFLICT (winner_nation_id, loser_nation_id)
    DO UPDATE SET count = public.nation_consecutive_wins.count + 1
    RETURNING count INTO v_count;

    -- Resetar vitórias seguidas do perdedor sobre o vencedor (streak quebrada)
    INSERT INTO public.nation_consecutive_wins (winner_nation_id, loser_nation_id, count)
    VALUES (p_loser_id, p_winner_id, 0)
    ON CONFLICT (winner_nation_id, loser_nation_id)
    DO UPDATE SET count = 0;

    RETURN v_count;
END;
$$;