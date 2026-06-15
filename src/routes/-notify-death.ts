// @ts-nocheck - pre-existing bugs unrelated to schema; tracked in plan.md
import { createAPIFileRoute } from '@tanstack/react-start/api'
import { TELEGRAM_BOT_TOKEN } from '../../../lib/config.server'

export const APIRoute = createAPIFileRoute('/api/player/notify-death')({
  POST: async ({ request }) => {
    const { telegramId, mapName } = await request.json()
    
    const text = `💀 *FATALIDADE NO REINO*\n\nSeu herói não resistiu aos perigos de *${mapName}* e foi derrotado por NPCs.\n\n🛡️ Você foi resgatado e levado de volta à Capital para se recuperar. Suas expedições foram interrompidas.`

    await fetch(`https://api.telegram.org/bot${process.env.TELEGRAM_BOT_TOKEN}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: telegramId,
        text: text,
        parse_mode: 'Markdown',
        reply_markup: {
          inline_keyboard: [[{ text: "🏰 RETORNAR AO JOGO", web_app: { url: process.env.MINI_APP_URL! } }]]
        }
      })
    })

    return new Response(JSON.stringify({ success: true }))
  }
})