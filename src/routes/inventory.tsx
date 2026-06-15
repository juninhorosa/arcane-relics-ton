import { createFileRoute } from '@tanstack/react-start'
import { useState, useCallback } from 'react'
import { InventoryGrid } from '../components/ItemCard'
import { usePlayerInventory, useEquippedItems, useSetBonus } from '../hooks/use-items'
import { CATEGORY_LABELS, type ItemCategory } from '../lib/items-system'
import { calculatePower, calculateMaxHp } from '../lib/power-calculation'

export const Route = createFileRoute('/inventory')({
  component: Inventory,
})

const FILTERS: (ItemCategory | 'all')[] = ['all', 'weapon', 'helmet', 'armor', 'gloves', 'boots']

function Inventory() {
  const [filter, setFilter] = useState<ItemCategory | 'all'>('all')
  const [tab, setTab] = useState<'inventory' | 'equipment'>('inventory')

  const { inventory, loading, refresh, equipItem, unequipItem } = usePlayerInventory()
  const { equipped } = useEquippedItems()
  const { setInfo } = useSetBonus(equipped)

  const equippedIds = new Set(
    inventory.filter(i => i.is_equipped).map(i => i.id)
  )

  const equippedItemsList = Object.values(equipped).filter(i => i !== null)
  const power = calculatePower(1, { attack: 0, defense: 0, hp: 100 }, equippedItemsList, setInfo?.bonusPercent || 0)
  const maxHp = calculateMaxHp(100, equippedItemsList, setInfo?.bonusPercent || 0)

  const handleUse = useCallback(async (inventoryId: string) => {
    try {
      const res = await fetch('/api/inventory/use', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          initData: (window as any).Telegram?.WebApp?.initData || '',
          inventoryItemId: inventoryId
        })
      })
      if (res.ok) {
        refresh()
      } else {
        const data = await res.json()
        alert(data.error || 'Erro ao usar item')
      }
    } catch (e) {
      console.error(e)
    }
  }, [refresh])

  return (
    <div className="min-h-screen bg-void-slate text-white pb-24">
      <div className="border-b border-arcane-gold/20 px-4 py-6 sticky top-0 z-10 bg-void-slate">
        <h1 className="text-3xl font-black font-cinzel text-arcane-gold uppercase tracking-tighter mb-4">
          🎒 Inventário
        </h1>

        <div className="flex gap-2 mb-4">
          {[
            { id: 'inventory', label: '🎒 Itens' },
            { id: 'equipment', label: '⚔️ Equipamento' }
          ].map(t => (
            <button
              key={t.id}
              onClick={() => setTab(t.id as any)}
              className={`px-4 py-2 rounded font-bold text-sm transition-colors ${
                tab === t.id
                  ? 'bg-arcane-gold text-void-slate'
                  : 'bg-slate-900 text-slate-300 hover:bg-slate-800'
              }`}
            >
              {t.label}
            </button>
          ))}
        </div>

        {setInfo && (
          <div className={`p-3 rounded-lg text-xs mb-4 ${setInfo.isComplete ? 'bg-arcane-gold/20 border border-arcane-gold/50' : 'bg-slate-900 border border-slate-700'}`}>
            <p className="font-bold text-arcane-gold mb-1">
              🏆 {setInfo.setName}
            </p>
            <p className="text-slate-300">
              {setInfo.equippedCount}/{setInfo.totalNeeded} equipados
              {setInfo.isComplete && ' ✅ Bônus completo!'}
              {!setInfo.isComplete && ` — Faltam ${setInfo.totalNeeded - setInfo.equippedCount}`}
            </p>
            {setInfo.isComplete && (
              <p className="text-emerald-400 font-bold mt-1">+{setInfo.bonusPercent}% em todos os atributos</p>
            )}
          </div>
        )}

        <div className="grid grid-cols-3 gap-2 text-xs">
          <div className="bg-slate-900 border border-slate-700 p-2 rounded text-center">
            <p className="text-slate-400">Poder</p>
            <p className="font-bold text-arcane-gold">{power}</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded text-center">
            <p className="text-slate-400">HP Máx</p>
            <p className="font-bold text-green-400">{maxHp}</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded text-center">
            <p className="text-slate-400">Itens</p>
            <p className="font-bold text-blue-400">{inventory.length}</p>
          </div>
        </div>
      </div>

      {tab === 'inventory' && (
        <div className="p-4">
          <div className="flex gap-2 overflow-x-auto pb-3 mb-4">
            {FILTERS.map(f => (
              <button
                key={f}
                onClick={() => setFilter(f)}
                className={`px-3 py-1.5 rounded-full text-xs font-bold whitespace-nowrap transition-colors ${
                  filter === f
                    ? 'bg-arcane-gold text-void-slate'
                    : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
                }`}
              >
                {f === 'all' ? 'Todos' : CATEGORY_LABELS[f]}
              </button>
            ))}
          </div>

          {loading ? (
            <div className="text-center py-10 text-slate-400 italic">Carregando itens...</div>
          ) : (
            <InventoryGrid
              items={inventory}
              equippedIds={equippedIds}
              onEquip={equipItem}
              onUnequip={unequipItem}
              onUse={handleUse}
              filter={filter}
            />
          )}
        </div>
      )}

      {tab === 'equipment' && (
        <div className="p-4">
          <h2 className="text-lg font-bold text-arcane-gold mb-4">⚔️ Equipamento Atual</h2>
          <div className="grid grid-cols-2 gap-3">
            {Object.entries(equipped).map(([slot, item]) => {
              const slotNames: Record<string, string> = {
                weapon: 'Arma', helmet: 'Capacete', armor: 'Armadura', gloves: 'Luvas', boots: 'Botas'
              }
              const slotIcons: Record<string, string> = {
                weapon: '⚔️', helmet: '🪖', armor: '🛡️', gloves: '🧤', boots: '👢'
              }
              return (
                <div
                  key={slot}
                  className="relative overflow-hidden bg-slate-800 border border-slate-700 rounded-xl p-3 flex flex-col items-center text-center"
                >
                  <span className="text-2xl mb-1">{slotIcons[slot] || '📦'}</span>
                  {item ? (
                    <>
                      <p className="text-xs font-bold text-yellow-500 line-clamp-1">{item.name}</p>
                      <p className="text-[10px] text-slate-400 uppercase">{item.rarity}</p>
                      <p className="text-[9px] text-slate-500 mt-1">
                        ATK+{item.attack_bonus} DEF+{item.defense_bonus} HP+{item.hp_bonus}
                      </p>
                      <button
                        onClick={() => unequipItem(item.inventory_id)}
                        className="mt-2 text-[10px] bg-red-600/50 hover:bg-red-600 px-3 py-1 rounded transition-colors"
                      >
                        Desequipar
                      </button>
                    </>
                  ) : (
                    <>
                      <p className="text-xs text-slate-600">{slotNames[slot]}</p>
                      <p className="text-[10px] text-slate-700">Vazio</p>
                    </>
                  )}
                </div>
              )
            })}
          </div>
        </div>
      )}
    </div>
  )
}
