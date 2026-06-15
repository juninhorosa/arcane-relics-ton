import { cn } from '../lib/utils'
import { ItemIcon } from './ItemIcon'
import {
  RARITY_COLORS, RARITY_BG, RARITY_BORDER,
  CATEGORY_LABELS,
  type Item, type PlayerInventoryItem, type ItemCategory
} from '../lib/items-system'

interface ItemCardProps {
  item: Item
  quantity?: number
  isEquipped?: boolean
  onEquip?: () => void
  onUnequip?: () => void
  onUse?: () => void
  compact?: boolean
}

export function ItemCard({
  item,
  quantity = 1,
  isEquipped = false,
  onEquip,
  onUnequip,
  onUse,
  compact = false
}: ItemCardProps) {
  if (compact) {
    return (
      <div className={cn(
        'p-2 rounded border flex items-center gap-2',
        isEquipped
          ? `border-arcane-gold ${RARITY_BG[item.rarity]}`
          : RARITY_BORDER[item.rarity]
      )}>
        <ItemIcon slot={item.category} itemClass={0} size={24} />
        <div className="flex-1 min-w-0">
          <p className="font-bold text-xs truncate">{item.name}</p>
          <p className={cn('text-[10px]', RARITY_COLORS[item.rarity])}>{item.rarity.toUpperCase()}</p>
        </div>
        {quantity > 1 && (
          <span className="text-xs text-slate-400 font-mono">x{quantity}</span>
        )}
        {isEquipped && (
          <span className="text-[10px] font-bold text-arcane-gold">EQUIPADO</span>
        )}
      </div>
    )
  }

  return (
    <div className={cn(
      'rounded-lg border-2 p-4 transition-all',
      isEquipped
        ? `border-arcane-gold ${RARITY_BG[item.rarity]} shadow-lg shadow-arcane-gold/20`
        : `${RARITY_BORDER[item.rarity]} bg-slate-900 hover:border-slate-600`
    )}>
      <div className="flex items-start justify-between mb-2">
        <div className="flex items-center gap-2">
          <ItemIcon slot={item.category} itemClass={0} size={32} />
          <div>
            <h3 className="font-bold text-sm">{item.name}</h3>
            <p className={cn('text-xs font-bold', RARITY_COLORS[item.rarity])}>
              {item.rarity.toUpperCase()} • {CATEGORY_LABELS[item.category]}
            </p>
          </div>
        </div>
        {quantity > 1 && (
          <span className="text-xs font-mono text-slate-400">x{quantity}</span>
        )}
      </div>

      <p className="text-xs text-slate-300 mb-3">{item.description}</p>

      <div className="grid grid-cols-3 gap-2 mb-3">
        {item.attack_bonus > 0 && (
          <div className="bg-slate-800/50 p-2 rounded text-xs text-center">
            <p className="text-red-400 font-bold">{item.attack_bonus}</p>
            <p className="text-[10px] text-slate-400">ATK</p>
          </div>
        )}
        {item.defense_bonus > 0 && (
          <div className="bg-slate-800/50 p-2 rounded text-xs text-center">
            <p className="text-blue-400 font-bold">{item.defense_bonus}</p>
            <p className="text-[10px] text-slate-400">DEF</p>
          </div>
        )}
        {item.hp_bonus > 0 && (
          <div className="bg-slate-800/50 p-2 rounded text-xs text-center">
            <p className="text-green-400 font-bold">{item.hp_bonus}</p>
            <p className="text-[10px] text-slate-400">HP</p>
          </div>
        )}
      </div>

      {item.crit_bonus > 0 && (
        <p className="text-xs text-amber-400 mb-1">💥 Crítico: +{item.crit_bonus}%</p>
      )}
      {item.dodge_bonus > 0 && (
        <p className="text-xs text-cyan-400 mb-2">💨 Esquiva: +{item.dodge_bonus}%</p>
      )}

      <div className="flex gap-2 mt-3">
        {!isEquipped && onEquip && (
          <button
            onClick={onEquip}
            className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold py-2 rounded transition-colors"
          >
            Equipar
          </button>
        )}
        {isEquipped && onUnequip && (
          <button
            onClick={onUnequip}
            className="flex-1 bg-red-600/50 hover:bg-red-600 text-white text-xs font-bold py-2 rounded transition-colors border border-red-500/50"
          >
            Desequipar
          </button>
        )}
        {onUse && (
          <button
            onClick={onUse}
            className="flex-1 bg-amber-600 hover:bg-amber-700 text-white text-xs font-bold py-2 rounded transition-colors"
          >
            Usar
          </button>
        )}
      </div>
    </div>
  )
}

interface InventoryGridProps {
  items: PlayerInventoryItem[]
  equippedIds: Set<string>
  onEquip: (inventoryId: string, item: Item) => void
  onUnequip: (inventoryId: string) => void
  onUse?: (inventoryId: string) => void
  compact?: boolean
  filter?: ItemCategory | 'all'
}

export function InventoryGrid({
  items,
  equippedIds,
  onEquip,
  onUnequip,
  onUse,
  compact = false,
  filter = 'all'
}: InventoryGridProps) {
  const filtered = filter === 'all'
    ? items
    : items.filter(pi => pi.items?.category === filter)

  if (filtered.length === 0) {
    return (
      <div className="text-center py-8 text-slate-400">
        <p className="text-lg mb-1">🎒</p>
        <p className="text-sm">Nenhum item encontrado</p>
      </div>
    )
  }

  return (
    <div className={cn('grid gap-3', compact ? 'grid-cols-2' : 'grid-cols-1')}>
      {filtered.map((entry) => {
        if (!entry.items) return null
        const isEquipped = equippedIds.has(entry.id)

        return (
          <ItemCard
            key={entry.id}
            item={entry.items}
            quantity={entry.quantity}
            isEquipped={isEquipped}
            onEquip={isEquipped ? undefined : () => onEquip(entry.id, entry.items!)}
            onUnequip={isEquipped ? () => onUnequip(entry.id) : undefined}
            onUse={onUse ? () => onUse(entry.id) : undefined}
            compact={compact}
          />
        )
      })}
    </div>
  )
}

interface EquipmentSlotsProps {
  equipped: Record<string, { inventory_id: string; name: string; rarity: string; category: string } | null>
  onUnequip: (inventoryId: string) => void
  onSlotClick?: (slot: string) => void
}

export function EquipmentSlots({ equipped, onUnequip, onSlotClick }: EquipmentSlotsProps) {
  const slots: { key: string; label: string; icon: string }[] = [
    { key: 'weapon', label: 'Arma', icon: '⚔️' },
    { key: 'helmet', label: 'Capacete', icon: '🪖' },
    { key: 'armor', label: 'Armadura', icon: '🛡️' },
    { key: 'gloves', label: 'Luvas', icon: '🧤' },
    { key: 'boots', label: 'Botas', icon: '👢' },
  ]

  return (
    <div className="grid grid-cols-2 gap-3">
      {slots.map((slot) => {
        const item = equipped[slot.key]
        return (
          <div
            key={slot.key}
            className={cn(
              'relative overflow-hidden aspect-square bg-slate-800 border-2 rounded-xl flex flex-col items-center justify-center p-2 transition-all',
              item
                ? 'border-arcane-gold/50 hover:border-arcane-gold cursor-pointer'
                : 'border-slate-700 border-dashed hover:border-slate-600'
            )}
            onClick={() => onSlotClick?.(slot.key)}
          >
            {item ? (
              <>
                <ItemIcon slot={slot.key} itemClass={0} size={36} />
                <p className="text-[10px] font-bold text-center text-yellow-500 mt-1 line-clamp-1">
                  {item.name}
                </p>
                <p className="text-[8px] text-slate-400 uppercase">{item.rarity}</p>
                <button
                  onClick={(e) => { e.stopPropagation(); onUnequip(item.inventory_id) }}
                  className="absolute top-1 right-1 bg-red-600/80 text-white text-[8px] w-4 h-4 rounded-full flex items-center justify-center hover:bg-red-500"
                >
                  ✕
                </button>
              </>
            ) : (
              <>
                <span className="text-2xl opacity-30">{slot.icon}</span>
                <p className="text-[10px] text-slate-600 mt-1">{slot.label}</p>
                <p className="text-[8px] text-slate-700">Vazio</p>
              </>
            )}
          </div>
        )
      })}
    </div>
  )
}
