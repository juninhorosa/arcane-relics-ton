# Migração de Schema Pendente

Vários arquivos referenciam tabelas/colunas/funções que ainda não existem no banco (por isso estão com `@ts-nocheck`). Esta migração cria tudo de uma vez e remove os `@ts-nocheck`.

## Tabelas novas (13)

| Tabela | Para que serve |
|---|---|
| `character_classes` | Arquétipos (Paladino, Guerreiro, Mago, Arqueiro, Clérigo) com bônus base de ATK/DEF/HP |
| `skills` | 25 habilidades (5 por classe), com tipo, raridade, nível requerido e escalamento |
| `player_skills` | Skills aprendidas por jogador (nível da skill, evolução) |
| `items` | Catálogo de equipamentos por classe/slot (separado de `item_templates`) |
| `player_inventory` | Inventário de equipamentos com durabilidade, slot equipado |
| `maps` | Mapas de farm (níveis, monstros, XP/h, gold/h, drop rate) |
| `active_invasions` | Invasões em curso entre nações (timers de alerta + ataque) |
| `invasion_participants` | Jogadores em cada lado de uma invasão |
| `world_bosses` | Boss global (HP, recompensas, janela ativa) |
| `boss_damage_ranking` | Dano cumulativo por jogador em cada boss |
| `territories` | Territórios de guilda que geram gold passivo |
| `guild_chat_messages` | Chat interno de guildas |
| `shop_items` | Produtos da loja VIP (passes 7/30/90 dias, consumíveis) |

## Colunas novas em tabelas existentes

- **`profiles`**: `is_banned bool`, `banned_reason text`, `banned_at timestamptz`
- **`nations`**: `divine_protection_until timestamptz`, `base_xp_per_hour int`, `base_gold_per_hour int`, `rivalry_score int`
- **`players`**: `class_id`, `current_map_id`, `is_vip`, `vip_until`, `hp`, `max_hp`, `last_death_at`, `skill_points`, `current_guild_id`

## Funções RPC novas

- `calculate_player_power(player_id)` → bigint (Nível×10 + atk_arma + def_set + hp_set/10 + bônus de skills/classe)
- `get_player_max_hp(player_id)` → int (base + bônus de classe + sets + VIP)
- `get_nation_player_counts()` → tabela (nation_id, total) para balanceamento
- `sync_offline_farm(player_id)` → jsonb `{ hours, xp_gained, gold_gained, died }` (máx 5h/8h VIP, checa morte por NPC)
- `update_nation_rivalry(attacker_nation, defender_nation, delta)` → void (atualiza score, ativa Proteção Divina se ≥ threshold)

## RLS e GRANTs

Cada tabela nova segue o padrão obrigatório:
1. `CREATE TABLE`
2. `GRANT` (authenticated + service_role; anon apenas em `maps`, `shop_items`, `character_classes`, `skills`, `world_bosses` que são públicos)
3. `ENABLE RLS`
4. `CREATE POLICY` (leitura pública nos catálogos; escrita restrita a service_role/admin; dados do jogador via `auth.uid()`)

## Seed inicial

- 5 classes (Paladino, Guerreiro, Mago, Arqueiro, Clérigo)
- 25 skills (5 por classe)
- 25 items (5 por classe × 5 slots) com raridades Common→Legendary
- 5 maps iniciais (Lv 1–4 neutro, depois mapas por nação)
- 5 shop_items (VIP 7d, 30d, 90d, poção XP, poção gold)

## Limpeza pós-migration

- Remover `// @ts-nocheck` dos 17 arquivos (3 hooks + 14 routes/lib)
- `bun run build` para validar tipos
- Atualizar `plan.md` marcando as fases que ficam realmente completas

## Atualização do plan.md

Adicionar uma **Fase 1.bis — Schema Avançado** documentando que as fases 11/12/13/14 do plano dependiam dessas tabelas e que só agora estão de fato funcionais no banco.

## Tamanho

Migração SQL grande (~500 linhas) + seed (~150 linhas) em um único arquivo de migration. Aprove para eu executar.
