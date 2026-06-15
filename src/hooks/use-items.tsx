import { useEffect, useState, useCallback } from 'react'
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../integrations/supabase/types'
import type { Item, PlayerInventoryItem, EquippedItems, ItemCategory, SetBonus } from '../lib/items-system'
import { calculateSetBonus, CATEGORY_ORDER, SET_NAMES } from '../lib/items-system'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)

function getTgUserId(): number | null {
  return (window as any).Telegram?.WebApp?.initDataUnsafe?.user?.id ?? null
}

async function getPlayerId(): Promise<string | null> {
  const tgId = getTgUserId()
  if (!tgId) return null

  const { data: profile } = await supabase
    .from('profiles')
    .select('players(id)')
    .eq('telegram_id', tgId)
    .single()

  return (profile as any)?.players?.[0]?.id ?? null
}

export function usePlayerInventory() {
  const [inventory, setInventory] = useState<PlayerInventoryItem[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const loadInventory = useCallback(async () => {
    try {
      setLoading(true)
      const playerId = await getPlayerId()
      if (!playerId) {
        setInventory([])
        return
      }

      const { data, error: err } = await supabase
        .from('player_inventory')
        .select('*, items(*)')
        .eq('player_id', playerId)
        .order('created_at', { ascending: false })

      if (err) throw err
      setInventory((data || []) as PlayerInventoryItem[])
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Erro ao carregar inventário')
    } finally {
      setLoading(false)
    }
  }, [])

  const equipItem = async (inventoryId: string, item: Item) => {
    try {
      const playerId = await getPlayerId()
      if (!playerId) return false

      const { error: err } = await supabase
        .from('player_inventory')
        .update({ is_equipped: true, equipped_slot: item.category })
        .eq('id', inventoryId)
        .eq('player_id', playerId)

      if (err) throw err
      await loadInventory()
      return true
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Erro ao equipar item')
      return false
    }
  }

  const unequipItem = async (inventoryId: string) => {
    try {
      const playerId = await getPlayerId()
      if (!playerId) return false

      const { error: err } = await supabase
        .from('player_inventory')
        .update({ is_equipped: false, equipped_slot: null })
        .eq('id', inventoryId)
        .eq('player_id', playerId)

      if (err) throw err
      await loadInventory()
      return true
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Erro ao desequipar item')
      return false
    }
  }

  useEffect(() => {
    loadInventory()
  }, [loadInventory])

  return { inventory, loading, error, refresh: loadInventory, equipItem, unequipItem }
}

export function useEquippedItems() {
  const [equipped, setEquipped] = useState<EquippedItems>({
    weapon: null, helmet: null, armor: null, gloves: null, boots: null
  })
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const loadEquipped = async () => {
      try {
        const playerId = await getPlayerId()
        if (!playerId) {
          setLoading(false)
          return
        }

        const { data, error: err } = await supabase
          .from('player_inventory')
          .select('id, items(*)')
          .eq('player_id', playerId)
          .eq('is_equipped', true)

        if (err) throw err

        const equippedMap: EquippedItems = {
          weapon: null, helmet: null, armor: null, gloves: null, boots: null
        }

        ;(data || []).forEach((entry: any) => {
          const item = entry.items as Item
          if (item && CATEGORY_ORDER.includes(item.category as ItemCategory)) {
            equippedMap[item.category as keyof EquippedItems] = { ...item, inventory_id: entry.id }
          }
        })

        setEquipped(equippedMap)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erro ao carregar equipamentos')
      } finally {
        setLoading(false)
      }
    }

    loadEquipped()
  }, [])

  return { equipped, loading, error }
}

export function useSetBonus(equippedItems: EquippedItems) {
  const [setInfo, setSetInfo] = useState<SetBonus | null>(null)

  useEffect(() => {
    const items = Object.values(equippedItems).filter((i): i is NonNullable<typeof equippedItems[keyof typeof equippedItems]> => i !== null)

    if (items.length === 0) {
      setSetInfo(null)
      return
    }

    const allSameSet = items.every(i => i.set_id === items[0].set_id)
    if (!allSameSet) {
      setSetInfo(null)
      return
    }

    const setId = items[0].set_id
    const bonusPercent = items[0].set_bonus_percentage

    setSetInfo({
      setId,
      setName: SET_NAMES[setId] || setId,
      equippedCount: items.length,
      totalNeeded: 5,
      bonusPercent: items.length === 5 ? bonusPercent : 0,
      isComplete: items.length === 5
    })
  }, [equippedItems])

  return { setInfo }
}
