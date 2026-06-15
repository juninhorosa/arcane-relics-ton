import { createHmac } from 'crypto';

/**
 * Valida o initData vindo do Telegram Mini App
 */
export function validateTelegramInitData(initData: string, botToken: string): boolean {
  const urlParams = new URLSearchParams(initData);
  const hash = urlParams.get('hash');
  urlParams.delete('hash');

  const params = Array.from(urlParams.entries())
    .map(([key, value]) => `${key}=${value}`)
    .sort()
    .join('\n');

  // Chave secreta derivada do bot token
  const secretKey = createHmac('sha256', 'WebAppData').update(botToken).digest();
  // Hash calculado localmente
  const calculatedHash = createHmac('sha256', secretKey).update(params).digest('hex');

  return calculatedHash === hash;
}