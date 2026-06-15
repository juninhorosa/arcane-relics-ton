# Deploy no Render

O projeto já está configurado para Render (Nitro preset `render-com`).

## Passo a passo

1. **Push para o GitHub** (já está em `juninhorosa/arcane-relics-ton`).
2. No Render → **New +** → **Blueprint** → conecte o repositório.
   O Render lê o `render.yaml` e cria o Web Service automaticamente.
   - Alternativa manual: **New + → Web Service**
     - Runtime: **Node**
     - Build: `bun install && bun run build`
     - Start: `node .output/server/index.mjs`
     - Health Check: `/`
3. **Variáveis de ambiente** (Settings → Environment): copie os valores do seu `.env` local:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_PUBLISHABLE_KEY`
   - `VITE_SUPABASE_ANON_KEY`
   - `VITE_SUPABASE_PROJECT_ID`
   - `SUPABASE_URL`
   - `SUPABASE_PUBLISHABLE_KEY`
   - `SUPABASE_PROJECT_ID`
   - `SUPABASE_SERVICE_ROLE_KEY` *(pegue no painel Supabase — não fica no .env do Lovable)*
   - `TELEGRAM_BOT_TOKEN`, `TELEGRAM_WEBHOOK_SECRET`, `TON_RECEIVER_WALLET` *(quando tiver)*
4. **Deploy**. A URL fica tipo `https://arcane-relics-ton.onrender.com`.
5. **Webhook do Telegram** (depois do deploy):
   ```
   curl "https://api.telegram.org/bot<TOKEN>/setWebhook?url=https://arcane-relics-ton.onrender.com/api/public/telegram/webhook&secret_token=<TELEGRAM_WEBHOOK_SECRET>"
   ```

## Observações

- Plano **Free** dorme após 15min sem tráfego (cold start ~30s). Para o bot Telegram ficar responsivo, use **Starter** ($7/mês) ou um ping externo.
- O Render usa Node, não Cloudflare Workers — então pacotes Node nativos funcionam normalmente.
- Se quiser usar **bun** como runtime nativo do Render: Runtime → **Docker** com `oven/bun` base image.
