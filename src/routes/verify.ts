import { createAPIFileRoute } from '@tanstack/react-start/api'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../../integrations/supabase/types'

const SUPABASE_URL = process.env.SUPABASE_URL!
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

export const APIRoute = createAPIFileRoute('/api/purchases/verify')({
  POST: async ({ request }) => {
    try {
      // Em produção, este body viria de um Webhook de indexação da TON
      const { purchaseId, txHash, amountReceived } = await request.json()

      // 1. Buscar a compra pendente
      const { data: purchase, error: pError } = await supabase
        .from('pack_purchases')
        .select('*, packs(*), shop_items(*), players(*)') // Incluir shop_items
        .eq('id', purchaseId)
        .eq('status', 'pending')
        .single()

      if (pError || !purchase) {
        return new Response(JSON.stringify({ error: 'Compra não encontrada ou já processada' }), { status: 404 })
      }

      // 2. Validar valor (Segurança básica)
      if (Number(amountReceived) < Number(purchase.ton_amount)) {
        return new Response(JSON.stringify({ error: 'Valor insuficiente' }), { status: 400 })
      }

      const player = purchase.players as any

      const updates = []
      let rewardMessage = '';

      if (purchase.pack_id) { // É uma compra de Pack (lógica existente)
        const pack = purchase.packs as any;
        // A. Sortear item da classe do pack
        const { data: templates } = await supabase
          .from('item_templates')
          .select('id')
          .eq('class', pack.item_class);
        
        const randomTemplate = templates ? templates[Math.floor(Math.random() * templates.length)] : null;

        // B. Adicionar Item ao Inventário
        if (randomTemplate) {
          updates.push(
            supabase.from('inventory').insert({
              player_id: player.id,
              template_id: randomTemplate.id,
              quantity: 1
            }).select().single()
          );
        }

        // Adicionar Ouro e Boost de XP
        const newGold = Number(player.gold) + Number(pack.gold_reward);
        let boostUntil = player.boost_xp_until ? new Date(player.boost_xp_until) : new Date();
        if (pack.boost_xp_hours > 0) {
          boostUntil = new Date(boostUntil.getTime() + (pack.boost_xp_hours * 60 * 60 * 1000));
        }

        updates.push(
          supabase.from('players').update({
            gold: newGold,
            boost_xp_until: pack.boost_xp_hours > 0 ? boostUntil.toISOString() : player.boost_xp_until
          }).eq('id', player.id)
        );

        // C. Registrar Logs
        updates.push(
          supabase.from('gold_log').insert({
            player_id: player.id,
            amount: pack.gold_reward,
            reason: `Compra de Pack: ${pack.name}`,
            ref_id: purchaseId
          })
        );
        rewardMessage = `Pack ${pack.name} entregue!`;

      } else if (purchase.shop_item_id) { // É uma compra de Item da Loja (VIP/Consumível)
        const shopItem = purchase.shop_items as any;
        if (shopItem.item_type === 'vip') {
          let vipUntil = player.vip_until && new Date(player.vip_until) > new Date() ? new Date(player.vip_until) : new Date();
          vipUntil = new Date(vipUntil.getTime() + (shopItem.duration_days * 24 * 60 * 60 * 1000));
          updates.push(
            supabase.from('players').update({
              is_vip: true,
              vip_until: vipUntil.toISOString()
            }).eq('id', player.id)
          );
          rewardMessage = `Status VIP ativado por ${shopItem.duration_days} dias!`;
        } else if (shopItem.item_type === 'consumable' && shopItem.item_template_id) {
          updates.push(
            supabase.from('inventory').insert({
              player_id: player.id,
              template_id: shopItem.item_template_id,
              quantity: shopItem.quantity
            }).select().single()
          );
          rewardMessage = `${shopItem.quantity}x ${shopItem.name} adicionado ao seu inventário!`;
        }
      }

      // Finalizar a Compra
      updates.push(
        supabase.from('pack_purchases').update({
          status: 'confirmed',
          tx_hash: txHash,
          confirmed_at: new Date().toISOString(),
          item_granted_id: null // Poderia vincular o ID do item gerado aqui
        }).eq('id', purchaseId)
      )

      await Promise.all(updates)

      return new Response(JSON.stringify({ 
        success: true,
        message: rewardMessage
      }), { status: 200 })

    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 })
    }
  }
})