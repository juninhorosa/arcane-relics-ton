# Plano: Bot RPG no Telegram com Mini App, Packs TON e Painel Admin

Vou construir tudo, mas executar **uma tarefa por vez**, confirmando com você antes de prosseguir para a próxima.

---

## Lista de Tarefas (sequencial, confirmo cada uma)

### Fase 0 — Fundação
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