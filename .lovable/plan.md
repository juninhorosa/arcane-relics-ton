# Plano: Bot RPG no Telegram com Mini App, Packs TON e Painel Admin

Vou construir tudo, mas executar **uma tarefa por vez**, confirmando com você antes de prosseguir para a próxima.

---

## Lista de Tarefas (sequencial, confirmo cada uma)

### Fase 0 — Fundação
<<<<<<< HEAD
- [x] **0.1** Ativar Lovable Cloud (banco + auth + secrets)
- [x] **0.2** Configurar Webhook no Telegram e gerar bot via @BotFather (Instruções abaixo)
- [x] **0.3** Configurar Variáveis de Ambiente (.env):
    - `TELEGRAM_BOT_TOKEN`: Token do BotFather.
    - `TELEGRAM_SECRET_TOKEN`: Para validar chamadas do Webhook.
    - `TON_RECEIVER_WALLET`: Endereço para receber pagamentos.
    - `TON_API_KEY`: Para consultar transações (Toncenter/TonAPI).
    - `SUPABASE_SERVICE_ROLE_KEY`: Para operações administrativas.
    - `MINI_APP_URL`: URL do frontend implantado.

### Fase 1 — Banco de dados (schema completo) ✅
- [x] **1.1** Tabelas core: `profiles`, `user_roles`, `nations`, `players`
- [x] **1.2** Tabelas de itens: `item_templates`, `inventory`, `equipment`
- [x] **1.3** Tabelas econômicas: `packs`, `pack_purchases`, `ton_transactions`, `gold_log`, `xp_log`
- [x] **1.4** Tabelas de combate/ranking: `battles`, `relics`, `nation_ranking`
- [x] **1.5** Seed de itens (classes 1-20) e packs configurados
- [x] **1.6** RLS, triggers de `updated_at` e fórmulas de XP implementadas

### Fase 2 — Webhook do bot Telegram
- [x] **2.1** Endpoint `/api/public/telegram/webhook` (recebe updates)
- [x] **2.2** Comando `/start` → check `profiles`. Se novo, `insert` e prompt de botões para escolher `nations`. 
    - *Nota:* O trigger `handle_new_user` no SQL já cria o profile básico.
- [x] **2.3** Menu principal inline: Perfil • Inventário • Loja • Combate • Ranking
- [x] **2.4** Comandos texto: `/perfil`, `/farm` (ganhar XP), `/atacar @user`
- [x] **2.5** Lógica de Combate (Service Layer):
    - *Atributos:* Buscar `equipment` -> `item_templates`.
    - *Fórmula de Poder:* `P = (Nível * 10) + Atk_Arma + Def_Set + HP_Set/10`.
    - *RNG Combat:* `Power * (0.8 + random(0.4))`. Se `random < 0.05` (Crítico x2).
    - *Resultado:* Vencedor ganha 10% do ouro do perdedor e XP fixo por nível.
- [x] **2.6** Roubo de relíquias ao vencer combate de elite
    - Se o defensor possui um item em `relics`, há 5% de chance de transferência automática no banco.

### Fase 3 — Mini App (Web App dentro do Telegram)
- [x] **3.1** Layout do Mini App (tema dark RPG, integrado ao Telegram WebApp SDK)
- [x] **3.2** Tela de Inventário com filtros por classe/raridade
- [x] **3.3** Tela de Equipamento (slots: arma, armadura, amuleto)
- [x] **3.4** Loja de Packs (Pack 1 / 2 / 3) com botão "Pagar com TON"
- [x] **3.5** Tela de Ranking de Nações + ranking individual
- [x] **3.6** Segurança: Implementar `validateTelegramInitData` no backend.
    - Validar `hash` usando `HMAC-SHA256` com `bot_token`.
    - Retornar JWT para sessões curtas do Mini App.

### Fase 4 — Pagamentos TON
- [x] **4.1** Integração TON Connect no Mini App (carteira do jogador assina tx)
- [x] **4.2** Serviço de Indexação: Monitorar `ton_transactions` via API externa.
- [x] **4.3** Processamento de Compra:
    - Validar `tx_hash` e `amount_ton`.
    - Match com `payment_comment` (Payload da transação).
    - Executar `grant_pack_contents` (Trigger ou RPC): `insert` no `inventory` + update `players.gold`.
- [x] **4.4** Painel admin manual como fallback (confirmar pagamento)

### Fase 5 — Painel Admin Web
- [x] **5.1** Login (email/senha + Google) com role `admin`
- [x] **5.2** Dashboard: métricas (jogadores ativos, TON arrecadado, packs vendidos)
- [x] **5.3** Gerenciar jogadores (banir, dar ouro, dar item, mudar nação) - *Avançado: Sistema de concessão de itens e banimento*
- [x] **5.4** Editor de itens classe 20 (forjar relíquia para líder)
- [x] **5.5** Logs de transações TON + reembolso manual
- [x] **5.6** Ferramenta de Anúncio Global (Push para todos os usuários via Bot)
- [x] **5.7** Logs de Auditoria (Registro de banimentos e ações administrativas)

### Fase 7 — Manutenção e Escala
- [x] **7.1** Backup automático do Postgres (diário) — *Gerenciado via Lovable/Supabase Cloud*
- [x] **7.2** Implementar Cache (Snapshots) para o Ranking de Nações
- [x] **7.3** Sistema de notificações push via Bot (ex: "Sua nação foi atacada!")
- [x] **7.4** Rate limiting no comando `/farm` e `/atacar` para evitar scripts.

### Fase 6 — Lançamento
- [x] **6.1** Registrar webhook do bot em produção
- [x] **6.2** Testes E2E (registro → compra pack → combate → ranking)
- [x] **6.3** Publicar app — *Pronto para deploy*

### Fase 8 — Expansão Phase 2: Guildas e Social
- [x] **8.1** Tabela `guilds`: `name`, `leader_id`, `level`, `xp`, `nation_id`.
- [x] **8.2** Sistema de chat interno de guilda via Mini App.
- [x] **8.3** Guerra de Guildas: Disputas por territórios que geram Gold passivo.
- [x] **8.4** Sistema de Balanceamento de Nações: Bônus de XP/Gold para nações minoritárias.

### Fase 9 — Expansão Phase 2: Eventos de Mundo
- [x] **9.1** Tabela `world_bosses`: Configuração de HP, recompensas e horários.
- [x] **9.2** Endpoint de ataque ao Boss: Lógica de dano cumulativo.
- [x] **9.3** UI de Evento: Barra de progresso global em tempo real no Mini App.
- [x] **9.4** Distribuição automática de recompensas via `xp_log` e `inventory` após a morte do boss.
- [x] **9.5** Sistema de Invasão: Placar global de conquistas entre nações e Proteção Divina.

### Fase 10 — Identidade Visual e Experiência (UX/UI) ✅
- [x] **10.1** Padronização de Design System: Definir tokens de cores (Arcane Gold, Void Slate, Blood Red) e tipografia gótica/fantasia.
- [x] **10.2** Ativos de Nações: Criar brasões em SVG heráldico para as 5 nações.
- [x] **10.3** Iconografia de Itens: Substituir emojis por ícones customizados para classes 1 a 20 e Relíquias.
- [x] **10.4** Feedback de Combate: Implementar animações de *Shake* de tela, partículas de impacto e transições suaves entre menus.
- [x] **10.5** Efeitos de Relíquias: Adicionar brilhos (glow) e auras animadas na UI para itens de raridade Suprema.

### Fase 11 — Sistema de Classes ✅
- [x] **11.1** Criar 5 arquétipos: Paladino, Guerreiro, Mago, Arqueiro, Clérigo
- [x] **11.2** Tabela `character_classes` com bônus de ATK/DEF/HP
- [x] **11.3** Componente `<ClassSelector />` para seleção visual
- [x] **11.4** Página `/select-class` com integração Telegram
- [x] **11.5** Hooks `usePlayerClass()` e `useCharacterClasses()` para gerenciamento
- [x] **11.6** Documentação completa com exemplos

### Fase 12 — Sistema de Skills ✅
- [x] **12.1** Criar 25 skills (5 por classe): Passivas, Ativas, Buffs, Debuffs
- [x] **12.2** Tabela `skills` com requisitos de nível, escalamento e raridades
- [x] **12.3** Tabela `player_skills` para rastrear skills aprendidas e evoluções
- [x] **12.4** Sistema de `skill_points` que aumentam ao ganhar nível
- [x] **12.5** Componentes `<SkillCard />`, `<SkillTree />`, `<SkillGrid />`
- [x] **12.6** Página `/skills` com 3 abas: Árvore | Aprendidas | Disponíveis
- [x] **12.7** Hooks `usePlayerSkills()`, `useClassSkills()`, `useAvailableSkills()`
- [x] **12.8** Documentação completa com fórmulas de escalamento

### Fase 13 — Sistema de Itens/Equipamentos ✅
- [x] **13.1** Criar 25 itens (5 por classe × 5 categorias): Arma, Capacete, Armadura, Luvas, Botas
- [x] **13.2** Tabela `items` com bônus de ATK/DEF/HP/CRÍTICO/ESQUIVA
- [x] **13.3** Tabela `player_inventory` para gerenciar equipamento e durabilidade
- [x] **13.4** Sistema de Sets: Cada classe tem 1 set completo com bonus +5% de todos os stats
- [x] **13.5** Raridades: Common, Uncommon, Rare, Epic, Legendary
- [x] **13.6** Componentes `<ItemCard />`, `<InventoryGrid />`, `<EquipmentSlots />` em `src/components/ItemCard.tsx`
- [x] **13.7** Páginas `/inventory` e `/equipment` com gerenciador completo
- [x] **13.8** Hooks `usePlayerInventory()`, `useEquippedItems()`, `useSetBonus()` em `src/hooks/use-items.tsx`
- [x] **13.9** Integração com cálculo de poder em `src/lib/power-calculation.ts`
- [x] **13.10** Biblioteca `src/lib/items-system.ts` com tipos, cores e utilitários

### Fase 11 — Gameplay Avançado e Invasões
- [x] **11.1** Mapa Inicial: Lógica de monstros para níveis 1-4 (sem nação).
- [x] **11.2** Sistema de Invasão: Timer de 2min (alerta) + 5min (ataque à relíquia).
- [x] **11.3** Notificações de Guerra: Alertas globais para nações atacantes e defensoras com botões de ação.
- [x] **11.4** Entrada 3D: Splash screen interativa com Three.js ao abrir o app.
- [x] **11.5** Monitor de Buffs: Exibir bônus de relíquias da nação e timer de proteção na Home.
- [x] **11.6** Feedback Sonoro: Efeito de 'Campânula Sagrada' global para Proteção Divina.
- [x] **11.7** Lógica de Invasão Completa: SQL para `active_invasions`, `invasion_participants`, RPCs de dano e finalização.
- [x] **11.8** Redirecionamento Inteligente: Usuários novos (Lv < 5) para tutorial, Lv 5 sem nação para seleção.
- [x] **11.9** Shared Power Calc: Função `calculatePower` centralizada.
- [x] **12.1** Sistema de Mapas: Tabela `maps` com níveis, monstros e taxas de drop.
- [x] **12.1.1** API para Viagem entre Mapas: Endpoint `/api/player/travel`.
- [x] **12.1.2** UI de Seleção de Mapas: Nova rota `/map-selection` com visual 3D.
- [x] **12.1.3** Integração na Home: Adicionar link para `/map-selection`.
- [x] **12.1.4** Atualizar Farm no Bot: Usar `current_map_id` para XP/Gold.
- [x] **12.2** Farm Offline: Lógica para calcular XP/Gold baseado no tempo de ausência (Max 5h/8h).
- [x] **12.3** Sistema VIP: Colunas `is_vip`, `vip_until` e bônus de 30% (XP/Gold/HP).
- [x] **12.4** Ciclo de Morte: Verificação de derrota contra NPC e retorno à capital.

### Fase 14 — Loja VIP e Consumíveis ✅
- [x] **14.1** Tabela `shop_items` com seed de produtos VIP (7, 30, 90 dias).
- [x] **14.2** API de Iniciação de Compra: Endpoint `/api/purchases/initiate-shop-item`.
- [x] **14.3** API de Verificação de Compra: Estendida em `/api/purchases/verify` para VIP/Consumíveis.
- [x] **14.4** UI da Loja VIP: Rota `/vip-shop` com integração TON Connect.
- [x] **14.5** Consumíveis: Botão "Usar" em poções no inventário.

---

## 🚀 Detalhes Técnicos Adicionais

**🎨 Design Tokens (Fase 10.1):**
- **Void Slate:** `#020617` (Fundo principal)
- **Arcane Gold:** `#D4AF37` (Primária/Destaque)
- **Blood Red:** `#7F1D1D` (Combate/Alerta)
- **Tipografia:** `Cinzel` (Gótica/Serifada para títulos)

**Stack:** TanStack Start + Lovable Cloud (Postgres + Auth) + Telegram Bot API (connector) + TON Connect SDK + Tailwind/shadcn.

**🛡️ Fluxo de Pagamento Seguro:**
1. Usuário clica em comprar -> Backend gera `pack_purchase` com status `pending` e um `payment_comment` único.
2. Mini App chama TON Connect enviando o `payment_comment` no payload da transação.
3. Um Edge Function ou Cron Job monitora a wallet receptora. 
4. Ao detectar o `payment_comment` correto e o valor em TON, marca como `confirmed`.

**🔐 Validação Mini App:**
1. Cliente envia `window.Telegram.WebApp.initData`.
2. Servidor calcula `secret_key = HMAC-SHA256("WebAppData", bot_token)`.
3. Servidor calcula `hash` dos campos ordenados e compara.

**⚔️ Detalhes do Farm:**
- Comando `/farm` disponível a cada 1 hora.
- Gera `random(50, 150) * nível` de XP e `random(10, 50) * nível` de Gold.
- Se `boost_xp_until > now()`, XP é multiplicado por 2x.
- **Bônus de Nação:** Jogadores em nações com menos de 15% da população global recebem +25% de Gold no farm.

**🛡️ Mecânica de Invasão:**
- Ataques contra membros da mesma nação são penalizados (não ganha ouro).
- Ataques contra nações inimigas contribuem para o `nation_ranking`.
- Se uma nação perder 50 batalhas seguidas para outra, entra em modo "Proteção Divina" por 2h.

**💰 Economia e Transações:**
- A tabela `ton_transactions` deve ser populada por um worker que consome a Toncenter API.
- O status do pack só muda para `confirmed` após a confirmação on-chain (mínimo 1 confirmação).
- Ouro e Itens são vinculados ao `player_id` e auditáveis via `gold_log` e `xp_log`.

**Fórmula de Nível:** Nível atual é calculado comparando o `xp` total com a tabela gerada pela função `total_xp_for_level`.

**Fórmula XP:** `xp_para_nivel(N) = floor(100 * N^2.05)` → total ~5.1M XP para level 50.
=======
- [ ] **0.1** Ativar Lovable Cloud (banco + auth + secrets)
- [ ] **0.2** Conectar Telegram (connector) e gerar bot via @BotFather
- [ ] **0.3** Definir endereço de wallet TON receptora (você me passa)

### Fase 1 — Banco de dados (schema completo)
- [ ] **1.1** Tabelas core: `profiles`, `user_roles`, `nations`, `players`
- [ ] **1.2** Tabelas de itens: `item_templates` (catálogo classes 1-20), `inventory`, `equipment`
- [ ] **1.3** Tabelas econômicas: `packs`, `pack_purchases`, `ton_transactions`, `gold_log`, `xp_log`
- [ ] **1.4** Tabelas de combate/ranking: `battles`, `relics`, `nation_ranking`, `leaders`
- [ ] **1.5** Seed de itens (todas as classes 1-20) e packs (Pack 1/2/3)
- [ ] **1.6** RLS, GRANTs, função `has_role`, fórmula XP `floor(100*N^2.05)`

### Fase 2 — Webhook do bot Telegram
- [ ] **2.1** Endpoint `/api/public/telegram/webhook` (recebe updates)
- [ ] **2.2** Comando `/start` → registro automático + escolha de nação
- [ ] **2.3** Menu principal inline: Perfil • Inventário • Loja • Combate • Ranking
- [ ] **2.4** Comandos texto: `/perfil`, `/farm` (ganhar XP), `/atacar @user`
- [ ] **2.5** Sistema de combate (Ataque vs Defesa + classe da arma + RNG)
- [ ] **2.6** Roubo de relíquias ao vencer combate de elite

### Fase 3 — Mini App (Web App dentro do Telegram)
- [ ] **3.1** Layout do Mini App (tema dark RPG, integrado ao Telegram WebApp SDK)
- [ ] **3.2** Tela de Inventário com filtros por classe/raridade
- [ ] **3.3** Tela de Equipamento (slots: arma, armadura, amuleto)
- [ ] **3.4** Loja de Packs (Pack 1 / 2 / 3) com botão "Pagar com TON"
- [ ] **3.5** Tela de Ranking de Nações + ranking individual
- [ ] **3.6** Autenticação via `initData` do Telegram (HMAC validation)

### Fase 4 — Pagamentos TON
- [ ] **4.1** Integração TON Connect no Mini App (carteira do jogador assina tx)
- [ ] **4.2** Webhook/poll para confirmar transação on-chain
- [ ] **4.3** Crédito automático do pack (item + ouro + boost XP no Pack 3)
- [ ] **4.4** Painel admin manual como fallback (confirmar pagamento)

### Fase 5 — Painel Admin Web
- [ ] **5.1** Login (email/senha + Google) com role `admin`
- [ ] **5.2** Dashboard: métricas (jogadores ativos, TON arrecadado, packs vendidos)
- [ ] **5.3** Gerenciar jogadores (banir, dar ouro, dar item, mudar nação)
- [ ] **5.4** Editor de itens classe 20 (forjar relíquia para líder)
- [ ] **5.5** Logs de transações TON + reembolso manual

### Fase 6 — Lançamento
- [ ] **6.1** Registrar webhook do bot em produção
- [ ] **6.2** Testes E2E (registro → compra pack → combate → ranking)
- [ ] **6.3** Publicar app

---

## Detalhes Técnicos

**Stack:** TanStack Start + Lovable Cloud (Postgres + Auth) + Telegram Bot API (connector) + TON Connect SDK + Tailwind/shadcn.

**Fórmula XP (já validada):** `xp_para_nivel(N) = floor(100 * N^2.05)` → total ~5.1M XP para level 50 em ~8 meses com boost full (3.000 XP/dia).
>>>>>>> a2e1774a9127f25d643aa8bc9aae7ee03b556dfb

**Segurança:**
- Bot token armazenado como secret via connector Telegram
- Webhook valida `X-Telegram-Bot-Api-Secret-Token`
- Mini App valida `initData` HMAC com bot token no servidor
- RLS em todas as tabelas de jogador
- Roles em tabela separada (`user_roles`) — nunca em `profiles`

**Próximos passos depois do plano aprovado:**
1. Confirmo cada tarefa concluída com ✅
2. Você responde "ok" ou pede ajuste → sigo para a próxima
3. Em pontos que precisam de input seu (token do bot, wallet TON, criar admin) eu paro e peço

---

**Posso começar pela Tarefa 0.1 (ativar Lovable Cloud)?**