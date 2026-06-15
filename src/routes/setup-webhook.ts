/**
 * Script utilitário para registrar o Webhook no Telegram
 * Execute: node setup-webhook.js
 */
const token = process.env.TELEGRAM_BOT_TOKEN;
const url = process.env.MINI_APP_URL; // Ou a URL base do seu servidor
const secret = process.env.TELEGRAM_SECRET_TOKEN;

async function setup() {
  const webhookUrl = `${url}/api/public/telegram/webhook`;
  const res = await fetch(`https://api.telegram.org/bot${token}/setWebhook?url=${webhookUrl}&secret_token=${secret}`);
  const data = await res.json();
  
  if (data.ok) console.log("✅ Webhook registrado com sucesso!");
  else console.error("❌ Erro ao registrar webhook:", data);
}

setup();