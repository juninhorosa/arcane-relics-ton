export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      battles: {
        Row: {
          attacker_id: string
          attacker_power: number
          created_at: string
          defender_id: string
          defender_power: number
          gold_stolen: number
          id: string
          log: Json | null
          relic_stolen_id: string | null
          winner_id: string | null
          xp_awarded: number
        }
        Insert: {
          attacker_id: string
          attacker_power: number
          created_at?: string
          defender_id: string
          defender_power: number
          gold_stolen?: number
          id?: string
          log?: Json | null
          relic_stolen_id?: string | null
          winner_id?: string | null
          xp_awarded?: number
        }
        Update: {
          attacker_id?: string
          attacker_power?: number
          created_at?: string
          defender_id?: string
          defender_power?: number
          gold_stolen?: number
          id?: string
          log?: Json | null
          relic_stolen_id?: string | null
          winner_id?: string | null
          xp_awarded?: number
        }
        Relationships: [
          {
            foreignKeyName: "battles_attacker_id_fkey"
            columns: ["attacker_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "battles_defender_id_fkey"
            columns: ["defender_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "battles_relic_stolen_id_fkey"
            columns: ["relic_stolen_id"]
            isOneToOne: false
            referencedRelation: "item_templates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "battles_winner_id_fkey"
            columns: ["winner_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      equipment: {
        Row: {
          equipped_at: string
          id: string
          inventory_item_id: string
          player_id: string
          slot: Database["public"]["Enums"]["item_slot"]
        }
        Insert: {
          equipped_at?: string
          id?: string
          inventory_item_id: string
          player_id: string
          slot: Database["public"]["Enums"]["item_slot"]
        }
        Update: {
          equipped_at?: string
          id?: string
          inventory_item_id?: string
          player_id?: string
          slot?: Database["public"]["Enums"]["item_slot"]
        }
        Relationships: [
          {
            foreignKeyName: "equipment_inventory_item_id_fkey"
            columns: ["inventory_item_id"]
            isOneToOne: false
            referencedRelation: "inventory"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "equipment_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      gold_log: {
        Row: {
          amount: number
          created_at: string
          id: string
          player_id: string
          reason: string
          ref_id: string | null
        }
        Insert: {
          amount: number
          created_at?: string
          id?: string
          player_id: string
          reason: string
          ref_id?: string | null
        }
        Update: {
          amount?: number
          created_at?: string
          id?: string
          player_id?: string
          reason?: string
          ref_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "gold_log_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      inventory: {
        Row: {
          acquired_at: string
          id: string
          player_id: string
          quantity: number
          template_id: string
        }
        Insert: {
          acquired_at?: string
          id?: string
          player_id: string
          quantity?: number
          template_id: string
        }
        Update: {
          acquired_at?: string
          id?: string
          player_id?: string
          quantity?: number
          template_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inventory_template_id_fkey"
            columns: ["template_id"]
            isOneToOne: false
            referencedRelation: "item_templates"
            referencedColumns: ["id"]
          },
        ]
      }
      item_templates: {
        Row: {
          attack: number
          class: number
          code: string
          created_at: string
          defense: number
          hp: number
          id: string
          image_url: string | null
          is_relic: boolean
          name: string
          pack_source: string | null
          rank_name: string
          slot: Database["public"]["Enums"]["item_slot"]
          special_effect: string | null
        }
        Insert: {
          attack?: number
          class: number
          code: string
          created_at?: string
          defense?: number
          hp?: number
          id?: string
          image_url?: string | null
          is_relic?: boolean
          name: string
          pack_source?: string | null
          rank_name: string
          slot: Database["public"]["Enums"]["item_slot"]
          special_effect?: string | null
        }
        Update: {
          attack?: number
          class?: number
          code?: string
          created_at?: string
          defense?: number
          hp?: number
          id?: string
          image_url?: string | null
          is_relic?: boolean
          name?: string
          pack_source?: string | null
          rank_name?: string
          slot?: Database["public"]["Enums"]["item_slot"]
          special_effect?: string | null
        }
        Relationships: []
      }
      items: {
        Row: {
          id: string
          code: string
          name: string
          emoji: string
          description: string
          category: Database["public"]["Enums"]["item_category"]
          class_id: string
          attack_bonus: number
          defense_bonus: number
          hp_bonus: number
          crit_bonus: number
          dodge_bonus: number
          rarity: Database["public"]["Enums"]["item_rarity"]
          required_level: number
          slot_weight: number
          set_id: string
          set_bonus_percentage: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          code: string
          name: string
          emoji: string
          description: string
          category: Database["public"]["Enums"]["item_category"]
          class_id: string
          attack_bonus?: number
          defense_bonus?: number
          hp_bonus?: number
          crit_bonus?: number
          dodge_bonus?: number
          rarity?: Database["public"]["Enums"]["item_rarity"]
          required_level?: number
          slot_weight?: number
          set_id: string
          set_bonus_percentage?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          code?: string
          name?: string
          emoji?: string
          description?: string
          category?: Database["public"]["Enums"]["item_category"]
          class_id?: string
          attack_bonus?: number
          defense_bonus?: number
          hp_bonus?: number
          crit_bonus?: number
          dodge_bonus?: number
          rarity?: Database["public"]["Enums"]["item_rarity"]
          required_level?: number
          slot_weight?: number
          set_id?: string
          set_bonus_percentage?: number
          created_at?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "items_class_id_fkey"
            columns: ["class_id"]
            isOneToOne: false
            referencedRelation: "character_classes"
            referencedColumns: ["id"]
          },
        ]
      }
      nation_ranking: {
        Row: {
          created_at: string
          id: string
          nation_id: string
          rank: number | null
          snapshot_date: string
          total_gold: number
          total_players: number
          total_power: number
        }
        Insert: {
          created_at?: string
          id?: string
          nation_id: string
          rank?: number | null
          snapshot_date?: string
          total_gold?: number
          total_players?: number
          total_power?: number
        }
        Update: {
          created_at?: string
          id?: string
          nation_id?: string
          rank?: number | null
          snapshot_date?: string
          total_gold?: number
          total_players?: number
          total_power?: number
        }
        Relationships: [
          {
            foreignKeyName: "nation_ranking_nation_id_fkey"
            columns: ["nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
            referencedColumns: ["id"]
          },
        ]
      }
      nations: {
        Row: {
          code: string
          color: string | null
          created_at: string
          description: string | null
          emblem_url: string | null
          id: string
          leader_user_id: string | null
          name: string
          updated_at: string
        }
        Insert: {
          code: string
          color?: string | null
          created_at?: string
          description?: string | null
          emblem_url?: string | null
          id?: string
          leader_user_id?: string | null
          name: string
          updated_at?: string
        }
        Update: {
          code?: string
          color?: string | null
          created_at?: string
          description?: string | null
          emblem_url?: string | null
          id?: string
          leader_user_id?: string | null
          name?: string
          updated_at?: string
        }
        Relationships: []
      }
      pack_purchases: {
        Row: {
          confirmed_at: string | null
          created_at: string
          from_address: string | null
          id: string
          item_granted_id: string | null
          pack_id: string | null
          player_id: string
          shop_item_id: string | null
          status: Database["public"]["Enums"]["pack_status"]
          ton_amount: number
          tx_hash: string | null
        }
        Insert: {
          confirmed_at?: string | null
          created_at?: string
          from_address?: string | null
          id?: string
          item_granted_id?: string | null
          pack_id?: string | null
          player_id: string
          shop_item_id?: string | null
          status?: Database["public"]["Enums"]["pack_status"]
          ton_amount: number
          tx_hash?: string | null
        }
        Update: {
          confirmed_at?: string | null
          created_at?: string
          from_address?: string | null
          id?: string
          item_granted_id?: string | null
          pack_id?: string | null
          player_id?: string
          shop_item_id?: string | null
          status?: Database["public"]["Enums"]["pack_status"]
          ton_amount?: number
          tx_hash?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "pack_purchases_item_granted_id_fkey"
            columns: ["item_granted_id"]
            isOneToOne: false
            referencedRelation: "inventory"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "pack_purchases_pack_id_fkey"
            columns: ["pack_id"]
            isOneToOne: false
            referencedRelation: "packs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "pack_purchases_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "pack_purchases_shop_item_id_fkey"
            columns: ["shop_item_id"]
            isOneToOne: false
            referencedRelation: "shop_items"
            referencedColumns: ["id"]
          },
        ]
      }
      packs: {
        Row: {
          active: boolean
          boost_xp_hours: number
          code: string
          created_at: string
          description: string | null
          gold_reward: number
          id: string
          item_class: number
          name: string
          ton_price: number
        }
        Insert: {
          active?: boolean
          boost_xp_hours?: number
          code: string
          created_at?: string
          description?: string | null
          gold_reward?: number
          id?: string
          item_class: number
          name: string
          ton_price: number
        }
        Update: {
          active?: boolean
          boost_xp_hours?: number
          code?: string
          created_at?: string
          description?: string | null
          gold_reward?: number
          id?: string
          item_class?: number
          name?: string
          ton_price?: number
        }
        Relationships: [        ]
      }
      player_inventory: {
        Row: {
          id: string
          player_id: string
          item_id: string
          quantity: number
          is_equipped: boolean
          equipped_slot: Database["public"]["Enums"]["item_category"] | null
          durability: number
          uses_count: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          player_id: string
          item_id: string
          quantity?: number
          is_equipped?: boolean
          equipped_slot?: Database["public"]["Enums"]["item_category"] | null
          durability?: number
          uses_count?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          player_id?: string
          item_id?: string
          quantity?: number
          is_equipped?: boolean
          equipped_slot?: Database["public"]["Enums"]["item_category"] | null
          durability?: number
          uses_count?: number
          created_at?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "player_inventory_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "player_inventory_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
      }
      players: {
        Row: {
          boost_xp_until: string | null
          created_at: string
          gold: number
          id: string
          last_farm_at: string | null
          level: number
          losses: number
          nation_id: string | null
          total_battles: number
          updated_at: string
          user_id: string
          wins: number
          xp: number
        }
        Insert: {
          boost_xp_until?: string | null
          created_at?: string
          gold?: number
          id?: string
          last_farm_at?: string | null
          level?: number
          losses?: number
          nation_id?: string | null
          total_battles?: number
          updated_at?: string
          user_id: string
          wins?: number
          xp?: number
        }
        Update: {
          boost_xp_until?: string | null
          created_at?: string
          gold?: number
          id?: string
          last_farm_at?: string | null
          level?: number
          losses?: number
          nation_id?: string | null
          total_battles?: number
          updated_at?: string
          user_id?: string
          wins?: number
          xp?: number
        }
        Relationships: [
          {
            foreignKeyName: "players_nation_id_fkey"
            columns: ["nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          avatar_url: string | null
          created_at: string
          display_name: string | null
          id: string
          telegram_id: number | null
          updated_at: string
          username: string | null
        }
        Insert: {
          avatar_url?: string | null
          created_at?: string
          display_name?: string | null
          id: string
          telegram_id?: number | null
          updated_at?: string
          username?: string | null
        }
        Update: {
          avatar_url?: string | null
          created_at?: string
          display_name?: string | null
          id?: string
          telegram_id?: number | null
          updated_at?: string
          username?: string | null
        }
        Relationships: []
      }
      relics: {
        Row: {
          created_at: string
          current_holder_player_id: string | null
          history: Json
          id: string
          last_transferred_at: string | null
          template_id: string
        }
        Insert: {
          created_at?: string
          current_holder_player_id?: string | null
          history?: Json
          id?: string
          last_transferred_at?: string | null
          template_id: string
        }
        Update: {
          created_at?: string
          current_holder_player_id?: string | null
          history?: Json
          id?: string
          last_transferred_at?: string | null
          template_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "relics_current_holder_player_id_fkey"
            columns: ["current_holder_player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "relics_template_id_fkey"
            columns: ["template_id"]
            isOneToOne: true
            referencedRelation: "item_templates"
            referencedColumns: ["id"]
          },
        ]
      }
      ton_transactions: {
        Row: {
          amount_ton: number
          confirmed_at: string | null
          created_at: string
          from_address: string | null
          id: string
          player_id: string | null
          raw_payload: Json | null
          to_address: string | null
          tx_hash: string
        }
        Insert: {
          amount_ton: number
          confirmed_at?: string | null
          created_at?: string
          from_address?: string | null
          id?: string
          player_id?: string | null
          raw_payload?: Json | null
          to_address?: string | null
          tx_hash: string
        }
        Update: {
          amount_ton?: number
          confirmed_at?: string | null
          created_at?: string
          from_address?: string | null
          id?: string
          player_id?: string | null
          raw_payload?: Json | null
          to_address?: string | null
          tx_hash?: string
        }
        Relationships: [
          {
            foreignKeyName: "ton_transactions_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      user_roles: {
        Row: {
          created_at: string
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
      xp_log: {
        Row: {
          amount: number
          created_at: string
          id: string
          player_id: string
          reason: string
          ref_id: string | null
        }
        Insert: {
          amount: number
          created_at?: string
          id?: string
          player_id: string
          reason: string
          ref_id?: string | null
        }
        Update: {
          amount?: number
          created_at?: string
          id?: string
          player_id?: string
          reason?: string
          ref_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "xp_log_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      shop_items: {
        Row: {
          id: string
          code: string
          name: string
          description: string
          ton_price: number
          item_type: string
          item_template_id: string | null
          duration_days: number
          quantity: number
          active: boolean
          created_at: string
        }
        Insert: {
          id?: string
          code: string
          name: string
          description: string
          ton_price: number
          item_type: string
          item_template_id?: string | null
          duration_days?: number
          quantity?: number
          active?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          code?: string
          name?: string
          description?: string
          ton_price?: number
          item_type?: string
          item_template_id?: string | null
          duration_days?: number
          quantity?: number
          active?: boolean
          created_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "shop_items_item_template_id_fkey"
            columns: ["item_template_id"]
            isOneToOne: false
            referencedRelation: "item_templates"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
      total_xp_for_level: { Args: { _level: number }; Returns: number }
      xp_for_level: { Args: { _level: number }; Returns: number }
    }
    Enums: {
      app_role: "admin" | "moderator" | "leader" | "player"
      item_category: "weapon" | "helmet" | "armor" | "gloves" | "boots"
      item_rarity: "common" | "uncommon" | "rare" | "epic" | "legendary"
      item_slot: "weapon" | "armor" | "helmet" | "boots" | "accessory" | "relic"
      pack_status: "pending" | "confirmed" | "failed" | "refunded"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["admin", "moderator", "leader", "player"],
      item_category: ["weapon", "helmet", "armor", "gloves", "boots"],
      item_rarity: ["common", "uncommon", "rare", "epic", "legendary"],
      item_slot: ["weapon", "armor", "helmet", "boots", "accessory", "relic"],
      pack_status: ["pending", "confirmed", "failed", "refunded"],
    },
  },
} as const
