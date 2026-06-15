// @ts-nocheck - pending schema migration
import { createFileRoute } from '@tanstack/react-router'
import { useTonConnectUI, TonConnectButton } from '@tonconnect/ui-react'
import { useState, useEffect } from 'react'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../integrations/supabase/types'
import { ItemIcon } from '../components/ItemIcon'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/vip-shop')({
  component: VipShop,
})

function VipShop() {
  const [tonConnectUI] = useTonConnectUI()
  const [loading, setLoading] = useState(false)
  const [shopItems, setShopItems] = useState<any[]>([])

  const initData = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initData : ''

  useEffect(() => {
    const fetchShopItems = async () => {
      const { data } = await supabase.from('shop_items').select('*').order('ton_price', { ascending: true })
      setShopItems(data || [])
    }
    fetchShopItems()
  }, [])

  const handleBuyItem = async (itemCode: string) => {
    if (!tonConnectUI.connected) {
      alert('Por favor, conecte sua carteira TON primeiro!')
      return
    }

    setLoading(true)
    try {
      const response = await fetch('/api/purchases/initiate-shop-item', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ initData, itemCode }),
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Falha ao iniciar compra')
      
      const { purchaseId, amount, receiver } = data

      const transaction = {
        validUntil: Math.floor(Date.now() / 1000) + 600, // 10 minutos
        messages: [
          {
            address: receiver,
            amount: (amount * 1000000000).toString(), // Converter para nanoTON
            payload: btoa(purchaseId), 
          },
        ],
      }

      await tonConnectUI.sendTransaction(transaction)
      
      alert('TransaÃ§Ã£o enviada! Assim que for confirmada na rede, seus benefÃ­cios/itens aparecerÃ£o.')
    } catch (error: any) {
      console.error(error)
      alert(`Erro: ${error.message}`)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="p-4 bg-void-slate min-h-screen text-white">
      <header className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold font-cinzel text-arcane-gold">Loja dos Antigos</h1>
        <TonConnectButton />
      </header>

      <div className="grid gap-6">
        {shopItems.map(item => (
          <div key={item.id} className="border border-arcane-gold/30 p-6 rounded-xl bg-slate-800/50 backdrop-blur-sm shadow-xl relative overflow-hidden">
            {item.item_type === 'vip' && <div className="mythic-aura-bg opacity-20 scale-150" />}
            
            <div className="flex justify-between items-start mb-4 relative z-10">
              <div>
                <h2 className="text-xl font-bold text-arcane-gold font-cinzel">{item.name}</h2>
                <p className="text-slate-400 text-sm">{item.description}</p>
              </div>
              <span className="bg-arcane-gold/10 text-arcane-gold px-2 py-1 rounded text-xs font-mono">
                {item.item_type.toUpperCase()}
              </span>
            </div>
            
            {item.item_type === 'consumable' && item.item_template_id && (
              <div className="flex justify-center mb-4 relative z-10">
                <ItemIcon slot="armor" itemClass={10} size={64} /> {/* Ãcone genÃ©rico para consumÃ­vel */}
              </div>
            )}

            <button
              onClick={() => handleBuyItem(item.code)}
              disabled={loading}
              className="w-full bg-arcane-gold hover:bg-yellow-700 disabled:opacity-50 py-3 rounded-lg font-bold transition-colors shadow-lg shadow-arcane-gold/20 relative z-10"
            >
              {loading ? 'Processando...' : `Comprar por ${item.ton_price} TON`}
            </button>
          </div>
        ))}
      </div>
    </div>
  )
}
