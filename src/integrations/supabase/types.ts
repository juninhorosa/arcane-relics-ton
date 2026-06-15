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
      active_invasions: {
        Row: {
          alert_started_at: string
          attack_started_at: string | null
          attacker_nation_id: string
          created_at: string
          defender_nation_id: string
          ended_at: string | null
          id: string
          relic_id: string | null
          status: string
          updated_at: string
          winner_nation_id: string | null
        }
        Insert: {
          alert_started_at?: string
          attack_started_at?: string | null
          attacker_nation_id: string
          created_at?: string
          defender_nation_id: string
          ended_at?: string | null
          id?: string
          relic_id?: string | null
          status?: string
          updated_at?: string
          winner_nation_id?: string | null
        }
        Update: {
          alert_started_at?: string
          attack_started_at?: string | null
          attacker_nation_id?: string
          created_at?: string
          defender_nation_id?: string
          ended_at?: string | null
          id?: string
          relic_id?: string | null
          status?: string
          updated_at?: string
          winner_nation_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "active_invasions_attacker_nation_id_fkey"
            columns: ["attacker_nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "active_invasions_defender_nation_id_fkey"
            columns: ["defender_nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "active_invasions_relic_id_fkey"
            columns: ["relic_id"]
            isOneToOne: false
            referencedRelation: "relics"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "active_invasions_winner_nation_id_fkey"
            columns: ["winner_nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
            referencedColumns: ["id"]
          },
        ]
      }
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
      boss_damage_ranking: {
        Row: {
          boss_id: string
          created_at: string
          damage_dealt: number
          hits: number
          id: string
          player_id: string
          updated_at: string
        }
        Insert: {
          boss_id: string
          created_at?: string
          damage_dealt?: number
          hits?: number
          id?: string
          player_id: string
          updated_at?: string
        }
        Update: {
          boss_id?: string
          created_at?: string
          damage_dealt?: number
          hits?: number
          id?: string
          player_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "boss_damage_ranking_boss_id_fkey"
            columns: ["boss_id"]
            isOneToOne: false
            referencedRelation: "world_bosses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "boss_damage_ranking_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      character_classes: {
        Row: {
          ability: string
          attack_bonus: number
          code: string
          created_at: string
          defense_bonus: number
          description: string
          emoji: string
          hp_bonus: number
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          ability?: string
          attack_bonus?: number
          code: string
          created_at?: string
          defense_bonus?: number
          description?: string
          emoji?: string
          hp_bonus?: number
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          ability?: string
          attack_bonus?: number
          code?: string
          created_at?: string
          defense_bonus?: number
          description?: string
          emoji?: string
          hp_bonus?: number
          id?: string
          name?: string
          updated_at?: string
        }
        Relationships: []
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
      guild_chat_messages: {
        Row: {
          created_at: string
          guild_id: string
          id: string
          message: string
          player_id: string
        }
        Insert: {
          created_at?: string
          guild_id: string
          id?: string
          message: string
          player_id: string
        }
        Update: {
          created_at?: string
          guild_id?: string
          id?: string
          message?: string
          player_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "guild_chat_messages_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      invasion_participants: {
        Row: {
          damage_dealt: number
          id: string
          invasion_id: string
          joined_at: string
          player_id: string
          side: string
        }
        Insert: {
          damage_dealt?: number
          id?: string
          invasion_id: string
          joined_at?: string
          player_id: string
          side?: string
        }
        Update: {
          damage_dealt?: number
          id?: string
          invasion_id?: string
          joined_at?: string
          player_id?: string
          side?: string
        }
        Relationships: [
          {
            foreignKeyName: "invasion_participants_invasion_id_fkey"
            columns: ["invasion_id"]
            isOneToOne: false
            referencedRelation: "active_invasions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "invasion_participants_player_id_fkey"
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
          attack_bonus: number
          category: string
          class_id: string | null
          code: string
          created_at: string
          crit_bonus: number
          defense_bonus: number
          description: string | null
          dodge_bonus: number
          emoji: string
          hp_bonus: number
          id: string
          name: string
          rarity: string
          required_level: number
          set_bonus_percentage: number
          set_id: string | null
          slot_weight: number
          updated_at: string
        }
        Insert: {
          attack_bonus?: number
          category?: string
          class_id?: string | null
          code: string
          created_at?: string
          crit_bonus?: number
          defense_bonus?: number
          description?: string | null
          dodge_bonus?: number
          emoji?: string
          hp_bonus?: number
          id?: string
          name: string
          rarity?: string
          required_level?: number
          set_bonus_percentage?: number
          set_id?: string | null
          slot_weight?: number
          updated_at?: string
        }
        Update: {
          attack_bonus?: number
          category?: string
          class_id?: string | null
          code?: string
          created_at?: string
          crit_bonus?: number
          defense_bonus?: number
          description?: string | null
          dodge_bonus?: number
          emoji?: string
          hp_bonus?: number
          id?: string
          name?: string
          rarity?: string
          required_level?: number
          set_bonus_percentage?: number
          set_id?: string | null
          slot_weight?: number
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
      maps: {
        Row: {
          base_gold_per_hour: number
          base_xp_per_hour: number
          code: string
          created_at: string
          description: string | null
          drop_rate: number
          id: string
          is_safe: boolean
          max_level: number
          min_level: number
          monster_name: string | null
          name: string
          nation_id: string | null
          updated_at: string
        }
        Insert: {
          base_gold_per_hour?: number
          base_xp_per_hour?: number
          code: string
          created_at?: string
          description?: string | null
          drop_rate?: number
          id?: string
          is_safe?: boolean
          max_level?: number
          min_level?: number
          monster_name?: string | null
          name: string
          nation_id?: string | null
          updated_at?: string
        }
        Update: {
          base_gold_per_hour?: number
          base_xp_per_hour?: number
          code?: string
          created_at?: string
          description?: string | null
          drop_rate?: number
          id?: string
          is_safe?: boolean
          max_level?: number
          min_level?: number
          monster_name?: string | null
          name?: string
          nation_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "maps_nation_id_fkey"
            columns: ["nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
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
          base_gold_per_hour: number
          base_xp_per_hour: number
          code: string
          color: string | null
          created_at: string
          description: string | null
          divine_protection_until: string | null
          emblem_url: string | null
          id: string
          leader_user_id: string | null
          name: string
          rivalry_score: number
          updated_at: string
        }
        Insert: {
          base_gold_per_hour?: number
          base_xp_per_hour?: number
          code: string
          color?: string | null
          created_at?: string
          description?: string | null
          divine_protection_until?: string | null
          emblem_url?: string | null
          id?: string
          leader_user_id?: string | null
          name: string
          rivalry_score?: number
          updated_at?: string
        }
        Update: {
          base_gold_per_hour?: number
          base_xp_per_hour?: number
          code?: string
          color?: string | null
          created_at?: string
          description?: string | null
          divine_protection_until?: string | null
          emblem_url?: string | null
          id?: string
          leader_user_id?: string | null
          name?: string
          rivalry_score?: number
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
          pack_id: string
          player_id: string
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
          pack_id: string
          player_id: string
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
          pack_id?: string
          player_id?: string
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
        Relationships: []
      }
      player_inventory: {
        Row: {
          created_at: string
          durability: number
          equipped_slot: string | null
          id: string
          is_equipped: boolean
          item_id: string
          player_id: string
          quantity: number
          updated_at: string
          uses_count: number
        }
        Insert: {
          created_at?: string
          durability?: number
          equipped_slot?: string | null
          id?: string
          is_equipped?: boolean
          item_id: string
          player_id: string
          quantity?: number
          updated_at?: string
          uses_count?: number
        }
        Update: {
          created_at?: string
          durability?: number
          equipped_slot?: string | null
          id?: string
          is_equipped?: boolean
          item_id?: string
          player_id?: string
          quantity?: number
          updated_at?: string
          uses_count?: number
        }
        Relationships: [
          {
            foreignKeyName: "player_inventory_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "player_inventory_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      player_skills: {
        Row: {
          id: string
          last_used_at: string | null
          learned_at: string
          player_id: string
          skill_id: string
          skill_level: number
          times_used: number
        }
        Insert: {
          id?: string
          last_used_at?: string | null
          learned_at?: string
          player_id: string
          skill_id: string
          skill_level?: number
          times_used?: number
        }
        Update: {
          id?: string
          last_used_at?: string | null
          learned_at?: string
          player_id?: string
          skill_id?: string
          skill_level?: number
          times_used?: number
        }
        Relationships: [
          {
            foreignKeyName: "player_skills_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "player_skills_skill_id_fkey"
            columns: ["skill_id"]
            isOneToOne: false
            referencedRelation: "skills"
            referencedColumns: ["id"]
          },
        ]
      }
      players: {
        Row: {
          boost_xp_until: string | null
          class_id: string | null
          created_at: string
          current_guild_id: string | null
          current_map_id: string | null
          gold: number
          hp: number
          id: string
          is_vip: boolean
          last_death_at: string | null
          last_farm_at: string | null
          level: number
          losses: number
          max_hp: number
          nation_id: string | null
          skill_points: number
          total_battles: number
          updated_at: string
          user_id: string
          vip_until: string | null
          wins: number
          xp: number
        }
        Insert: {
          boost_xp_until?: string | null
          class_id?: string | null
          created_at?: string
          current_guild_id?: string | null
          current_map_id?: string | null
          gold?: number
          hp?: number
          id?: string
          is_vip?: boolean
          last_death_at?: string | null
          last_farm_at?: string | null
          level?: number
          losses?: number
          max_hp?: number
          nation_id?: string | null
          skill_points?: number
          total_battles?: number
          updated_at?: string
          user_id: string
          vip_until?: string | null
          wins?: number
          xp?: number
        }
        Update: {
          boost_xp_until?: string | null
          class_id?: string | null
          created_at?: string
          current_guild_id?: string | null
          current_map_id?: string | null
          gold?: number
          hp?: number
          id?: string
          is_vip?: boolean
          last_death_at?: string | null
          last_farm_at?: string | null
          level?: number
          losses?: number
          max_hp?: number
          nation_id?: string | null
          skill_points?: number
          total_battles?: number
          updated_at?: string
          user_id?: string
          vip_until?: string | null
          wins?: number
          xp?: number
        }
        Relationships: [
          {
            foreignKeyName: "players_class_id_fkey"
            columns: ["class_id"]
            isOneToOne: false
            referencedRelation: "character_classes"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "players_current_map_id_fkey"
            columns: ["current_map_id"]
            isOneToOne: false
            referencedRelation: "maps"
            referencedColumns: ["id"]
          },
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
          banned_at: string | null
          banned_reason: string | null
          created_at: string
          display_name: string | null
          id: string
          is_banned: boolean
          telegram_id: number | null
          updated_at: string
          username: string | null
        }
        Insert: {
          avatar_url?: string | null
          banned_at?: string | null
          banned_reason?: string | null
          created_at?: string
          display_name?: string | null
          id: string
          is_banned?: boolean
          telegram_id?: number | null
          updated_at?: string
          username?: string | null
        }
        Update: {
          avatar_url?: string | null
          banned_at?: string | null
          banned_reason?: string | null
          created_at?: string
          display_name?: string | null
          id?: string
          is_banned?: boolean
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
      shop_items: {
        Row: {
          category: string
          code: string
          created_at: string
          description: string | null
          id: string
          is_active: boolean
          name: string
          price_gold: number
          price_ton: number
          reward_gold: number
          reward_item_id: string | null
          reward_xp: number
          updated_at: string
          vip_days: number
        }
        Insert: {
          category?: string
          code: string
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name: string
          price_gold?: number
          price_ton?: number
          reward_gold?: number
          reward_item_id?: string | null
          reward_xp?: number
          updated_at?: string
          vip_days?: number
        }
        Update: {
          category?: string
          code?: string
          created_at?: string
          description?: string | null
          id?: string
          is_active?: boolean
          name?: string
          price_gold?: number
          price_ton?: number
          reward_gold?: number
          reward_item_id?: string | null
          reward_xp?: number
          updated_at?: string
          vip_days?: number
        }
        Relationships: [
          {
            foreignKeyName: "shop_items_reward_item_id_fkey"
            columns: ["reward_item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
      }
      skills: {
        Row: {
          attack_bonus: number
          attack_multiplier: number
          can_crit: boolean
          can_miss: boolean
          class_id: string | null
          code: string
          cooldown_seconds: number
          created_at: string
          crit_chance_bonus: number
          defense_bonus: number
          defense_multiplier: number
          description: string
          emoji: string
          energy_cost: number
          hp_bonus: number
          hp_multiplier: number
          id: string
          max_level: number
          name: string
          rarity: string
          required_level: number
          required_skill_points: number
          scaling_per_level: number
          skill_type: string
          special_effect: string | null
          updated_at: string
        }
        Insert: {
          attack_bonus?: number
          attack_multiplier?: number
          can_crit?: boolean
          can_miss?: boolean
          class_id?: string | null
          code: string
          cooldown_seconds?: number
          created_at?: string
          crit_chance_bonus?: number
          defense_bonus?: number
          defense_multiplier?: number
          description?: string
          emoji?: string
          energy_cost?: number
          hp_bonus?: number
          hp_multiplier?: number
          id?: string
          max_level?: number
          name: string
          rarity?: string
          required_level?: number
          required_skill_points?: number
          scaling_per_level?: number
          skill_type?: string
          special_effect?: string | null
          updated_at?: string
        }
        Update: {
          attack_bonus?: number
          attack_multiplier?: number
          can_crit?: boolean
          can_miss?: boolean
          class_id?: string | null
          code?: string
          cooldown_seconds?: number
          created_at?: string
          crit_chance_bonus?: number
          defense_bonus?: number
          defense_multiplier?: number
          description?: string
          emoji?: string
          energy_cost?: number
          hp_bonus?: number
          hp_multiplier?: number
          id?: string
          max_level?: number
          name?: string
          rarity?: string
          required_level?: number
          required_skill_points?: number
          scaling_per_level?: number
          skill_type?: string
          special_effect?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "skills_class_id_fkey"
            columns: ["class_id"]
            isOneToOne: false
            referencedRelation: "character_classes"
            referencedColumns: ["id"]
          },
        ]
      }
      territories: {
        Row: {
          captured_at: string | null
          code: string
          created_at: string
          gold_per_hour: number
          id: string
          name: string
          nation_id: string | null
          owner_guild_id: string | null
          updated_at: string
        }
        Insert: {
          captured_at?: string | null
          code: string
          created_at?: string
          gold_per_hour?: number
          id?: string
          name: string
          nation_id?: string | null
          owner_guild_id?: string | null
          updated_at?: string
        }
        Update: {
          captured_at?: string | null
          code?: string
          created_at?: string
          gold_per_hour?: number
          id?: string
          name?: string
          nation_id?: string | null
          owner_guild_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "territories_nation_id_fkey"
            columns: ["nation_id"]
            isOneToOne: false
            referencedRelation: "nations"
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
      world_bosses: {
        Row: {
          code: string
          created_at: string
          current_hp: number
          description: string | null
          emoji: string | null
          ends_at: string | null
          id: string
          is_active: boolean
          max_hp: number
          name: string
          reward_gold: number
          reward_item_id: string | null
          reward_xp: number
          starts_at: string
          updated_at: string
        }
        Insert: {
          code: string
          created_at?: string
          current_hp?: number
          description?: string | null
          emoji?: string | null
          ends_at?: string | null
          id?: string
          is_active?: boolean
          max_hp?: number
          name: string
          reward_gold?: number
          reward_item_id?: string | null
          reward_xp?: number
          starts_at?: string
          updated_at?: string
        }
        Update: {
          code?: string
          created_at?: string
          current_hp?: number
          description?: string | null
          emoji?: string | null
          ends_at?: string | null
          id?: string
          is_active?: boolean
          max_hp?: number
          name?: string
          reward_gold?: number
          reward_item_id?: string | null
          reward_xp?: number
          starts_at?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "world_bosses_reward_item_id_fkey"
            columns: ["reward_item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
        ]
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
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      calculate_player_power: { Args: { _player_id: string }; Returns: number }
      get_nation_player_counts: {
        Args: never
        Returns: {
          nation_id: string
          total: number
        }[]
      }
      get_player_max_hp: { Args: { _player_id: string }; Returns: number }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
      sync_offline_farm: { Args: { _player_id: string }; Returns: Json }
      total_xp_for_level: { Args: { _level: number }; Returns: number }
      update_nation_rivalry: {
        Args: { _attacker: string; _defender: string; _delta: number }
        Returns: undefined
      }
      xp_for_level: { Args: { _level: number }; Returns: number }
    }
    Enums: {
      app_role: "admin" | "moderator" | "leader" | "player"
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
      item_slot: ["weapon", "armor", "helmet", "boots", "accessory", "relic"],
      pack_status: ["pending", "confirmed", "failed", "refunded"],
    },
  },
} as const
