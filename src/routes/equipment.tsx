import { createFileRoute } from '@tanstack/react-router'
import { useEquippedItems, usePlayerInventory, useSetBonus } from '../hooks/use-items'
import { EquipmentSlots } from '../components/ItemCard'
import { calculatePower, calculateMaxHp } from '../lib/power-calculation'

export const Route = createFileRoute('/equipment')({
  component: Equipment,
})

function Equipment() {
  const { equipped, loading } = useEquippedItems()
  const { unequipItem } = usePlayerInventory()
  const { setInfo } = useSetBonus(equipped)

  const equippedList = Object.values(equipped).filter(i => i !== null)
  const power = calculatePower(1, { attack: 0, defense: 0, hp: 100 }, equippedList, setInfo?.bonusPercent || 0)
  const maxHp = calculateMaxHp(100, equippedList, setInfo?.bonusPercent || 0)

  const totalAtk = equippedList.reduce((sum, i) => sum + i.attack_bonus, 0)
  const totalDef = equippedList.reduce((sum, i) => sum + i.defense_bonus, 0)
  const totalHp = equippedList.reduce((sum, i) => sum + i.hp_bonus, 0)
  const totalCrit = equippedList.reduce((sum, i) => sum + i.crit_bonus, 0)
  const totalDodge = equippedList.reduce((sum, i) => sum + i.dodge_bonus, 0)

  if (loading) {
    return (
      <div className="min-h-screen bg-void-slate text-white flex items-center justify-center">
        <p className="text-arcane-gold italic">Carregando equipamentos...</p>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-void-slate text-white pb-24">
      <div className="border-b border-arcane-gold/20 px-4 py-6">
        <h1 className="text-3xl font-black font-cinzel text-arcane-gold uppercase tracking-tighter mb-2">
          ⚔️ Herói
        </h1>
        <p className="text-slate-400 text-sm italic">Equipamento atual do seu herói</p>
      </div>

      <div className="p-4">
        <div className="grid grid-cols-2 gap-3 mb-6">
          <div className="bg-slate-900 border border-slate-700 p-3 rounded-lg text-center">
            <p className="text-[10px] text-slate-400 uppercase">Poder</p>
            <p className="text-xl font-black text-arcane-gold">{power}</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-3 rounded-lg text-center">
            <p className="text-[10px] text-slate-400 uppercase">HP Máximo</p>
            <p className="text-xl font-black text-green-400">{maxHp}</p>
          </div>
        </div>

        <div className="grid grid-cols-5 gap-1 mb-6 text-center text-[10px]">
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-red-400 font-bold">+{totalAtk}</p>
            <p className="text-slate-400">ATK</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-blue-400 font-bold">+{totalDef}</p>
            <p className="text-slate-400">DEF</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-green-400 font-bold">+{totalHp}</p>
            <p className="text-slate-400">HP</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-amber-400 font-bold">+{totalCrit}%</p>
            <p className="text-slate-400">CRIT</p>
          </div>
          <div className="bg-slate-900 border border-slate-700 p-2 rounded">
            <p className="text-cyan-400 font-bold">+{totalDodge}%</p>
            <p className="text-slate-400">ESQ</p>
          </div>
        </div>

        {setInfo && (
          <div className={`p-4 rounded-xl mb-6 text-sm ${setInfo.isComplete ? 'bg-arcane-gold/20 border border-arcane-gold/50' : 'bg-slate-900 border border-slate-700'}`}>
            <p className="font-bold text-arcane-gold mb-1">🏆 {setInfo.setName}</p>
            <p className="text-slate-300">
              {setInfo.equippedCount}/{setInfo.totalNeeded} peças
              {setInfo.isComplete && ' — Bônus ativo! ✅'}
            </p>
            {setInfo.isComplete && (
              <p className="text-emerald-400 font-bold mt-1">+{setInfo.bonusPercent}% em todos os atributos</p>
            )}
          </div>
        )}

        <EquipmentSlots
          equipped={Object.fromEntries(
            Object.entries(equipped).map(([k, v]) => [k, v ? { inventory_id: v.inventory_id, name: v.name, rarity: v.rarity, category: v.category } : null])
          )}
          onUnequip={unequipItem}
        />
      </div>
    </div>
  )
}
