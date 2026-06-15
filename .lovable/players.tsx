import { createFileRoute } from '@tanstack/react-start'
import { useEffect, useState } from 'react'

export const Route = createFileRoute('/admin/players')({
  component: AdminPlayers,
})

function AdminPlayers() {
  const [players, setPlayers] = useState<any[]>([])
  const [search, setSearch] = useState('')
  const [loading, setLoading] = useState(true)
  const [templates, setTemplates] = useState<any[]>([])
  const [selectedPlayer, setSelectedPlayer] = useState<any>(null)
  const [grantForm, setGrantForm] = useState({ templateId: '', quantity: 1 })

  useEffect(() => {
    fetch('/api/admin/items')
      .then(res => res.json())
      .then(data => setTemplates(Array.isArray(data) ? data : []))
      .catch(err => console.error("Erro ao carregar templates", err))
  }, [])

  const fetchPlayers = async () => {
    setLoading(true)
    const res = await fetch(`/api/admin/players?search=${encodeURIComponent(search)}`)
    const data = await res.json()
    setPlayers(Array.isArray(data) ? data : [])
    setLoading(false)
  }

  useEffect(() => {
    fetchPlayers()
  }, [])

  const handleUpdateGold = async (playerId: string, currentGold: number) => {
    const amount = prompt("Quanto ouro deseja adicionar ou remover? (Use negativos para remover)", "100")
    if (amount === null) return

    const res = await fetch('/api/admin/players', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        playerId,
        updates: { gold: currentGold + parseInt(amount) }
      })
    })

    if (res.ok) fetchPlayers()
    else alert("Erro ao atualizar ouro")
  }

  const handleToggleBan = async (playerId: string, isBanned: boolean) => {
    const confirmMsg = isBanned ? "Deseja desbanir este jogador?" : "Deseja BANIR este jogador? Ele perderá acesso ao Bot e Mini App.";
    if (!confirm(confirmMsg)) return;
    
    const reason = !isBanned ? prompt("Motivo do banimento:") : prompt("Motivo do desbanimento:");
    if (reason === null) return;

    const res = await fetch('/api/admin/players', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        playerId,
        updates: { is_banned: !isBanned },
        reason
      })
    })

    if (res.ok) fetchPlayers()
    else alert("Erro ao atualizar status de banimento")
  }

  const handleGrantItem = async (playerId: string) => {
    if (!grantForm.templateId) return alert("Selecione um item")
    
    const res = await fetch('/api/admin/inventory/grant', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        playerId, 
        templateId: grantForm.templateId, 
        quantity: grantForm.quantity 
      })
    })

    if (res.ok) {
      alert("Item concedido!")
      setSelectedPlayer(null)
    } else alert("Erro ao conceder item")
  }

  return (
    <div className="p-8 bg-white min-h-screen">
      <header className="mb-8 flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold">Gerenciar Heróis</h1>
          <p className="text-slate-500">Busque e edite atributos de jogadores</p>
        </div>
        <div className="flex gap-2">
          <input 
            type="text" 
            placeholder="Nome ou @username" 
            className="border px-4 py-2 rounded-lg"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          <button onClick={fetchPlayers} className="bg-slate-900 text-white px-4 py-2 rounded-lg">Buscar</button>
        </div>
      </header>

      <table className="w-full border-collapse">
        <thead>
          <tr className="bg-slate-50 text-left">
            <th className="p-4 border">Herói</th>
            <th className="p-4 border">Nação</th>
            <th className="p-4 border">Level</th>
            <th className="p-4 border">Status</th>
            <th className="p-4 border">Ouro</th>
            <th className="p-4 border">Ações</th>
          </tr>
        </thead>
        <tbody>
          {players.map(p => (
            <tr key={p.id} className="hover:bg-slate-50">
              <td className="p-4 border font-medium">{(p.profiles as any)?.display_name} <span className="text-slate-400 text-xs">@{(p.profiles as any)?.username}</span></td>
              <td className="p-4 border">{(p.nations as any)?.name}</td>
              <td className="p-4 border">{p.level}</td>
              <td className="p-4 border">
                {p.profiles?.is_banned ? 
                  <span className="text-red-600 font-bold">BANIDO</span> : 
                  <span className="text-green-600 font-bold">ATIVO</span>
                }
              </td>
              <td className="p-4 border font-mono">💰 {p.gold.toLocaleString()}</td>
              <td className="p-4 border">
                <button onClick={() => handleUpdateGold(p.id, p.gold)} className="text-blue-600 hover:underline text-sm font-bold">Editar Ouro</button>
                <button onClick={() => setSelectedPlayer(p)} className="text-emerald-600 hover:underline text-sm font-bold ml-4">Dar Item</button>
                <button onClick={() => handleToggleBan(p.id, p.profiles?.is_banned)} className="text-red-600 hover:underline text-sm font-bold ml-4">
                  {p.profiles?.is_banned ? 'Desbanir' : 'Banir'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {selectedPlayer && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white p-6 rounded-xl max-w-sm w-full shadow-2xl">
            <h2 className="text-xl font-bold mb-4">Dar Item para {selectedPlayer.profiles?.display_name}</h2>
            
            <label className="block text-sm font-medium text-slate-700 mb-1">Selecione o Item</label>
            <select 
              className="w-full border p-2 rounded mb-4 text-sm"
              value={grantForm.templateId}
              onChange={(e) => setGrantForm({ ...grantForm, templateId: e.target.value })}
            >
              <option value="">Selecione um template...</option>
              {templates.map(t => <option key={t.id} value={t.id}>{t.name} (CL {t.class})</option>)}
            </select>

            <label className="block text-sm font-medium text-slate-700 mb-1">Quantidade</label>
            <input 
              type="number" 
              min="1"
              className="w-full border p-2 rounded mb-6" 
              value={grantForm.quantity}
              onChange={(e) => setGrantForm({ ...grantForm, quantity: parseInt(e.target.value) })}
            />

            <div className="flex gap-2">
              <button 
                onClick={() => handleGrantItem(selectedPlayer.id)}
                className="flex-1 bg-emerald-600 text-white py-2 rounded font-bold hover:bg-emerald-700 transition-colors"
              >
                Confirmar
              </button>
              <button 
                onClick={() => setSelectedPlayer(null)}
                className="flex-1 bg-slate-100 py-2 rounded font-bold hover:bg-slate-200 transition-colors"
              >
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}