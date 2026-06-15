import { createFileRoute } from '@tanstack/react-start'
import { useTonConnectUI, TonConnectButton } from '@tonconnect/ui-react'
import { useState } from 'react'

export const Route = createFileRoute('/shop')({
  component: Shop,
})

function Shop() {
  const [tonConnectUI] = useTonConnectUI()
  const [loading, setLoading] = useState(false)

  // Obtém initData do SDK do Telegram
  const initData = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initData : ''

  const handleBuyPack = async (packCode: string) => {
    if (!tonConnectUI.connected) {
      alert('Por favor, conecte sua carteira TON primeiro!')
      return
    }

    setLoading(true)
    try {
      // 1. Iniciar compra no backend para obter o ID de rastreamento
      const response = await fetch('/api/purchases/initiate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ initData, packCode }),
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Falha ao iniciar compra')
      
      const { purchaseId, amount, receiver } = data

      // 2. Solicitar transação via TON Connect
      // Nota: O purchaseId é enviado como 'payload' (comentário) para identificação on-chain
      const transaction = {
        validUntil: Math.floor(Date.now() / 1000) + 600, // 10 minutos
        messages: [
          {
            address: receiver,
            amount: (amount * 1000000000).toString(), // Converter para nanoTON
            // No TON, o comentário é um Cell. O SDK do TON Connect aceita o BOC em base64.
            // Para simplificar a integração inicial, enviamos o ID. 
            // Um worker backend (Fase 4.2) buscará esse ID nos comentários das transações.
            payload: btoa(purchaseId), 
          },
        ],
      }

      await tonConnectUI.sendTransaction(transaction)
      
      alert('Transação enviada! Assim que for confirmada na rede, seus itens aparecerão no inventário.')
    } catch (error: any) {
      console.error(error)
      alert(`Erro: ${error.message}`)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="p-4 bg-slate-900 min-h-screen text-white">
      <header className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold">Loja de Relíquias</h1>
        <TonConnectButton />
      </header>

      <div className="grid gap-6">
        {/* Pack 1 - Exemplo solicitado */}
        <div className="border border-yellow-900/50 p-6 rounded-xl bg-slate-800/50 backdrop-blur-sm shadow-xl">
          <div className="flex justify-between items-start mb-4">
            <div>
              <h2 className="text-xl font-bold text-yellow-500">O Caminho Divino</h2>
              <p className="text-slate-400 text-sm">Pack #1</p>
            </div>
            <span className="bg-yellow-500/10 text-yellow-500 px-2 py-1 rounded text-xs font-mono">CLASSE 17</span>
          </div>
          
          <ul className="text-slate-300 text-sm space-y-2 mb-6">
            <li>✨ 1x Item Aleatório Classe 17 (Divino)</li>
            <li>💰 500 Moedas de Ouro</li>
          </ul>

          <button
            onClick={() => handleBuyPack('PACK_1')}
            disabled={loading}
            className="w-full bg-yellow-600 hover:bg-yellow-500 disabled:opacity-50 py-3 rounded-lg font-bold transition-colors shadow-lg shadow-yellow-900/20"
          >
            {loading ? 'Processando...' : 'Comprar por 1 TON'}
          </button>
        </div>
      </div>
    </div>
  )
}