import { createFileRoute } from '@tanstack/react-start'
import { useEffect, useState } from 'react'

export const Route = createFileRoute('/admin/items')({
  component: AdminItems,
})

function AdminItems() {
  const [items, setItems] = useState<any[]>([])
  const [showForm, setShowForm] = useState(false)
  const [newItem, setNewItem] = useState({
    code: '', name: '', class: 20, rank_name: 'SUPREMO', 
    slot: 'weapon', attack: 1000, defense: 1000, hp: 5000,
    is_relic: true, special_effect: ''
  })

  const fetchItems = async () => {
    const res = await fetch('/api/admin/items')
    const data = await res.json()
    setItems(data)
  }

  useEffect(() => { fetchItems() }, [])

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault()
    const res = await fetch('/api/admin/items', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newItem)
    })
    if (res.ok) {
      alert('Item forjado!')
      setShowForm(false)
      fetchItems()
    } else {
      const err = await res.json()
      alert(`Erro: ${err.error}`)
    }
  }

  return (
    <div className="p-8 bg-white min-h-screen">
      <header className="mb-8 flex justify-between items-center">
        <h1 className="text-2xl font-bold">Forja Arcana (Templates)</h1>
        <button 
          onClick={() => setShowForm(!showForm)}
          className="bg-yellow-600 text-white px-6 py-2 rounded-lg font-bold"
        >
          {showForm ? 'Fechar Forja' : 'Forjar Novo Item'}
        </button>
      </header>

      {showForm && (
        <form onSubmit={handleCreate} className="mb-8 p-6 border rounded-xl bg-slate-50 grid grid-cols-2 gap-4">
          <input placeholder="Código (Ex: RELIC_VOID)" className="p-2 border rounded" value={newItem.code} onChange={e => setNewItem({...newItem, code: e.target.value})} required />
          <input placeholder="Nome do Item" className="p-2 border rounded" value={newItem.name} onChange={e => setNewItem({...newItem, name: e.target.value})} required />
          <select className="p-2 border rounded" value={newItem.slot} onChange={e => setNewItem({...newItem, slot: e.target.value as any})}>
            <option value="weapon">Arma</option><option value="armor">Armadura</option><option value="relic">Relíquia</option>
          </select>
          <input type="number" placeholder="Ataque" className="p-2 border rounded" value={newItem.attack} onChange={e => setNewItem({...newItem, attack: parseInt(e.target.value)})} />
          <input type="number" placeholder="Defesa" className="p-2 border rounded" value={newItem.defense} onChange={e => setNewItem({...newItem, defense: parseInt(e.target.value)})} />
          <textarea placeholder="Efeito Especial" className="p-2 border rounded col-span-2" value={newItem.special_effect} onChange={e => setNewItem({...newItem, special_effect: e.target.value})} />
          <button type="submit" className="bg-slate-900 text-white p-2 rounded col-span-2 font-bold uppercase">Confirmar Criação</button>
        </form>
      )}

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {items.map(item => (
          <div key={item.id} className="border p-4 rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <div className="flex justify-between font-bold mb-2">
              <span>{item.name}</span>
              <span className="text-yellow-600">CL {item.class}</span>
            </div>
            <div className="text-xs text-slate-500 mb-4">{item.code} | {item.slot.toUpperCase()}</div>
            <div className="grid grid-cols-3 text-center gap-2 text-sm bg-slate-50 p-2 rounded">
              <div><span className="block font-bold">{item.attack}</span> ATK</div>
              <div><span className="block font-bold">{item.defense}</span> DEF</div>
              <div><span className="block font-bold">{item.hp}</span> HP</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}