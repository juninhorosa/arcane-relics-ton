import { createFileRoute } from '@tanstack/react-start'
import { useEffect, useState } from 'react'

export const Route = createFileRoute('/admin/transactions')({
  component: AdminTransactions,
})

function AdminTransactions() {
  const [txs, setTxs] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  const fetchTxs = async () => {
    setLoading(true)
    const res = await fetch('/api/admin/transactions')
    const data = await res.json()
    setTxs(Array.isArray(data) ? data : [])
    setLoading(false)
  }

  useEffect(() => { fetchTxs() }, [])

  const handleManualConfirm = async (id: string) => {
    if (!confirm('Deseja confirmar manualmente este pagamento? Itens serão creditados imediatamente.')) return
    
    const res = await fetch('/api/admin/transactions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ purchaseId: id })
    })

    if (res.ok) {
      alert('Pagamento confirmado com sucesso!')
      fetchTxs()
    } else {
      alert('Erro ao confirmar transação.')
    }
  }

  return (
    <div className="p-8 bg-white min-h-screen">
      <header className="mb-8">
        <h1 className="text-2xl font-bold text-slate-900 font-mono">📜 Auditoria de Transações TON</h1>
        <p className="text-slate-500">Monitore pagamentos pendentes e confirme ordens manuais.</p>
      </header>

      <div className="overflow-x-auto">
        <table className="w-full border-collapse">
          <thead>
            <tr className="bg-slate-100 text-left text-xs uppercase text-slate-600">
              <th className="p-4 border">Data</th>
              <th className="p-4 border">Herói</th>
              <th className="p-4 border">Pack</th>
              <th className="p-4 border">Valor</th>
              <th className="p-4 border">Status</th>
              <th className="p-4 border">Ações</th>
            </tr>
          </thead>
          <tbody className="text-sm">
            {txs.map(tx => (
              <tr key={tx.id} className="hover:bg-slate-50">
                <td className="p-4 border text-slate-500">{new Date(tx.created_at).toLocaleString()}</td>
                <td className="p-4 border font-bold">{tx.profiles?.profiles?.display_name}</td>
                <td className="p-4 border">{tx.packs?.name}</td>
                <td className="p-4 border font-mono font-bold text-blue-600">{tx.ton_amount} TON</td>
                <td className="p-4 border">
                  <span className={`px-2 py-1 rounded text-[10px] font-bold ${tx.status === 'confirmed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>{tx.status.toUpperCase()}</span>
                </td>
                <td className="p-4 border">
                  {tx.status === 'pending' && (
                    <button onClick={() => handleManualConfirm(tx.id)} className="text-xs bg-slate-900 text-white px-3 py-1 rounded hover:bg-slate-800">Liberar Pack</button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}