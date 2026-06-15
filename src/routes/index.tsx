import { createFileRoute, Link } from '@tanstack/react-router'
import { createClient } from '@supabase/supabase-js'
import { useEffect, useState, useRef } from 'react'
import { NationCrest } from '../components/NationCrest'
import { ItemIcon } from '../components/ItemIcon'
import { Arcane3D } from '../components/Arcane3D'
import { cn } from '../lib/utils'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/')({
  component: Home,
})

function Home() {
  const [player, setPlayer] = useState<any>(null)
  const [power, setPower] = useState(0)
  const [maxHp, setMaxHp] = useState(100)
  const [territories, setTerritories] = useState<any[]>([])
  const [nationRelics, setNationRelics] = useState<any[]>([])
  const [protectionTime, setProtectionTime] = useState<string | null>(null)
  const [selectedRelic, setSelectedRelic] = useState<any>(null)
  const [offlineReport, setOfflineReport] = useState<any>(null)
  const [currentInvasion, setCurrentInvasion] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const loadHero = async () => {
      const tgUser = (window as any).Telegram?.WebApp?.initDataUnsafe?.user
      if (!tgUser) return

      // Timer para ProteÃ§Ã£o Divina
      const updateProtectionTimer = (until: string | null) => {
        if (!until) {
          setProtectionTime(null)
          return
        }
        const target = new Date(until).getTime()
        const interval = setInterval(() => {
          const now = new Date().getTime()
          const diff = target - now
          if (diff <= 0) {
            setProtectionTime(null)
            clearInterval(interval)
          } else {
            const m = Math.floor(diff / 60000)
            const s = Math.floor((diff % 60000) / 1000)
            setProtectionTime(`${m}:${s.toString().padStart(2, '0')}`)
          }
        }, 1000)
        return interval
      }

      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(*, nations(*), guilds(name))')
        .eq('telegram_id', tgUser.id)
        .single()

      // Carregar TerritÃ³rios (Guerra de Guildas)
      const { data: terr } = await supabase.from('territories' as any).select('*, guilds(name)')

      // Carregar InvasÃ£o Ativa
      const { data: activeInvasion } = await supabase
        .from('active_invasions' as any)
        .select('id, target_nation_id, nations(name)')
        .eq('status', 'attacking')
        .single()

      const playerData = (profile as any)?.players?.[0]
      if (playerData) {
        setPlayer(playerData)
        
        // Buscar Poder e Max HP via RPC para consistÃªncia (Fase 11.9)
        const { data: pwr } = await supabase.rpc('calculate_player_power', { p_player_id: playerData.id, p_level: playerData.level, p_is_vip: playerData.is_vip })
        const { data: mHp } = await supabase.rpc('get_player_max_hp', { p_player_id: playerData.id })
        
        if (pwr) setPower(pwr)
        if (mHp) setMaxHp(mHp)

        // Buscar Itens LendÃ¡rios da NaÃ§Ã£o
        const { data: relics } = await supabase
          .from('player_inventory')
          .select('items(name, attack_bonus, defense_bonus)')
          .eq('items.rarity', 'legendary')
          .eq('players.nation_id', playerData.nation_id)
          // @ts-ignore - join complexo
          .join('players', { on: 'player_id=id' })
        
        setNationRelics(relics || [])

        if (playerData.nations?.divine_protection_until) {
          updateProtectionTimer(playerData.nations.divine_protection_until)
        }

        // Sincronizar Farm Offline (Tarefa 12.2)
        const { data: report } = await supabase.rpc('sync_offline_farm', { p_player_id: playerData.id })
        if (report && (report.hours > 0.1 || report.died)) {
          setOfflineReport(report);
          if (report.died) {
            // Trigger para notificaÃ§Ã£o do bot (Opcional: chamar uma API aqui)
          }
        }
      }
      setTerritories(terr || [])
      setCurrentInvasion(activeInvasion)
      setLoading(false)
    }
    loadHero()
  }, [])

  // Listener Global para ProteÃ§Ã£o Divina (Efeito Sonoro 11.6)
  useEffect(() => {
    const sacredBell = new Audio('/sounds/sacred-bell.mp3');
    sacredBell.volume = 0.5;

    const channel = supabase
      .channel('global-notifications')
      .on(
        'postgres_changes',
        { event: 'UPDATE', schema: 'public', table: 'nations' },
        (payload: any) => {
          const until = payload.new.divine_protection_until;
          
          // Verifica se a proteÃ§Ã£o foi ativada agora (data futura)
          if (until && new Date(until) > new Date()) {
            sacredBell.play().catch(e => {
              // Navegadores bloqueiam Ã¡udio sem interaÃ§Ã£o prÃ©via
              console.log("Ãudio aguardando interaÃ§Ã£o do usuÃ¡rio:", e);
            });
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  if (loading) return (
    <div className="min-h-screen bg-void-slate flex flex-col items-center justify-center font-cinzel">
      <Arcane3D />
      <div className="text-arcane-gold animate-pulse text-xl mt-4">Conectando ao Arcano...</div>
    </div>
  )

  // Redirecionamento Inteligente (Fase 11.8)
  if (!player || player.level < 5 || !player.nation_id) {
    const title = !player ? "Estranho detectado" : player.level < 5 ? "Mapa de Treinamento" : "Jure Lealdade";
    const message = !player ? "VocÃª ainda nÃ£o possui um perfil. Volte ao bot para comeÃ§ar." : player.level < 5 ? `Alcance o nÃ­vel 5 caÃ§ando monstros iniciais para escolher uma naÃ§Ã£o. (NÃ­vel atual: ${player.level})` : "VocÃª alcanÃ§ou o nÃ­vel 5! Escolha sua naÃ§Ã£o para continuar sua jornada.";
    const buttonText = !player || player.level < 5 ? "Voltar ao Bot" : "Escolher NaÃ§Ã£o";
    const buttonLink = !player || player.level < 5 ? `https://t.me/${(window as any).Telegram?.WebApp?.initDataUnsafe?.user?.username || 'YOUR_BOT_USERNAME'}` : "/select-nation";

    return (
      <div className="min-h-screen bg-void-slate text-white p-6 flex flex-col items-center text-center">
        <div className="h-48 w-full"><Arcane3D /></div>
        <h1 className="text-2xl font-black text-arcane-gold font-cinzel mt-4 uppercase">{title}</h1>
        <p className="text-sm text-slate-400 mb-6">{message}</p>
        
        {player && player.level < 5 && (
          <div className="w-full bg-slate-800 rounded-full h-2 mb-8">
            <div className="bg-arcane-gold h-full rounded-full transition-all" style={{ width: `${(player.level / 5) * 100}%` }} />
          </div>
        )}

        <div className="bg-slate-900 border border-slate-700 p-6 rounded-2xl w-full">
          <div className="text-4xl mb-2">{!player ? 'ðŸ‘»' : player.level < 5 ? 'ðŸº' : 'ðŸš©'}</div>
          <h3 className="font-bold">{!player ? 'Perfil Inexistente' : player.level < 5 ? 'Floresta dos Lobos' : 'Escolha sua NaÃ§Ã£o'}</h3>
          <p className="text-xs text-slate-500 mb-4">{!player ? 'Crie seu perfil no bot.' : player.level < 5 ? 'Use /farm no Bot para ganhar XP e Ouro.' : 'Sua jornada comeÃ§a agora!'}</p>
          <Link to={buttonLink} target={!player || player.level < 5 ? '_blank' : '_self'} className="bg-arcane-gold text-void-slate px-6 py-2 rounded-lg text-xs font-bold uppercase">
            {buttonText}
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-void-slate text-white pb-24 overflow-x-hidden">
      {/* Hero Header */}
      <div className="relative h-[450px] flex flex-col items-center justify-end pb-6 border-b border-arcane-gold/20 overflow-hidden">
        <div className="absolute inset-0 opacity-20 pointer-events-none bg-gradient-to-t from-void-slate to-transparent z-10" />
        <div className="mythic-aura-bg scale-[2] opacity-20" />

        {/* VISUAL 3D DE ENTRADA */}
        <Arcane3D />
        
        <h1 className="relative z-20 text-3xl font-black font-cinzel text-arcane-gold uppercase tracking-tighter">
          {player.nations.name} Hero
        </h1>
        <p className="relative z-20 text-xs text-slate-400 font-mono uppercase tracking-[0.2em]">
          {player.guilds?.name || 'Sem Guilda'} â€¢ NÃ­vel {player.level}
        </p>
      </div>

      {/* Main Stats */}
      <div className="grid grid-cols-3 gap-1 px-4 -mt-5 relative z-30">
        <StatBox label="PODER" value={power} color="text-yellow-500" />
        <StatBox label="OURO" value={player.gold} color="text-arcane-gold" isGold />
        <StatBox label="VITÃ“RIAS" value={player.wins} color="text-emerald-500" />
      </div>

      {/* Vitalidade e Vigor (ImersÃ£o e Sustentabilidade) */}
      <div className="px-4 mt-6 space-y-3 relative z-30">
        {/* HP Bar */}
        <div className="space-y-1">
          <div className="flex justify-between text-[10px] font-bold text-slate-400 px-1">
            <span className="flex items-center gap-1"><span className="text-red-500">â¤ï¸</span> VITALIDADE</span>
            <span className="font-mono">{player.current_hp || maxHp} / {maxHp}</span>
          </div>
          <div className="h-2 w-full bg-slate-900 border border-white/5 rounded-full p-0.5 shadow-inner">
            <div 
              className="h-full bg-gradient-to-r from-red-600 to-red-400 rounded-full transition-all duration-500 ease-out" 
              style={{ width: `${((player.current_hp || maxHp) / maxHp) * 100}%` }}
            />
          </div>
        </div>

        {/* Vigor Bar */}
        <div className="space-y-1">
          <div className="flex justify-between text-[10px] font-bold text-slate-400 px-1">
            <span className="flex items-center gap-1"><span className="text-blue-500">âš¡</span> VIGOR</span>
            <span className="font-mono">{player.vigor || 100} / 100</span>
          </div>
          <div className="h-2 w-full bg-slate-900 border border-white/5 rounded-full p-0.5 shadow-inner">
            <div 
              className="h-full bg-gradient-to-r from-blue-600 to-blue-400 rounded-full transition-all duration-1000 ease-out" 
              style={{ width: `${player.vigor || 100}%` }}
            />
          </div>
        </div>
      </div>

      {/* Buffs Ativos e ProteÃ§Ã£o */}
      <div className="px-4 mt-4 flex flex-wrap gap-2">
        {protectionTime && (
          <div className="bg-blue-900/40 border border-blue-500/50 px-3 py-2 rounded-xl flex items-center gap-2 animate-pulse">
            <span className="text-sm">ðŸ›¡ï¸</span>
            <div>
              <div className="text-[8px] text-blue-400 font-bold uppercase leading-none">ProteÃ§Ã£o Divina</div>
              <div className="text-xs font-mono font-black text-white leading-none mt-1">{protectionTime}</div>
            </div>
          </div>
        )}

        {nationRelics.map((r, i) => (
          <button 
            key={i} 
            onClick={() => setSelectedRelic(r.item_templates)}
            className="bg-arcane-gold/10 border border-arcane-gold/30 px-3 py-2 rounded-xl flex items-center gap-2 active:scale-95 transition-transform"
          >
            <div className="relative">
              <ItemIcon slot="relic" itemClass={20} size={16} isRelic />
            </div>
            <div className="text-left">
              <div className="text-[8px] text-arcane-gold font-bold uppercase leading-none">Buff de NaÃ§Ã£o</div>
              <div className="text-[10px] font-black text-white leading-none mt-1 truncate max-w-[80px]">
                {r.item_templates.name}
              </div>
            </div>
          </button>
        ))}

        {!protectionTime && nationRelics.length === 0 && (
          <div className="w-full text-center text-[9px] text-slate-600 uppercase tracking-widest py-2">
            Nenhum bÃ´nus de naÃ§Ã£o ativo no momento
          </div>
        )}
      </div>

      {/* Status da Guerra de Guildas */}
      <div className="px-4 mt-8">
        <h2 className="text-xs font-bold text-slate-500 uppercase tracking-widest mb-4">TerritÃ³rios Dominados</h2>
        <div className="flex gap-4 overflow-x-auto pb-4 no-scrollbar">
          {territories.map((t) => (
            <div key={t.id} className="min-w-[140px] bg-slate-800/40 border border-slate-700 p-3 rounded-xl">
              <div className="text-[10px] text-slate-500 mb-1">{t.name}</div>
              <div className="text-xs font-bold text-yellow-500 truncate">{t.guilds?.name || 'Vago'}</div>
              <div className="text-[9px] text-emerald-500 mt-1">+{t.gold_yield_per_hour}g/h</div>
            </div>
          ))}
        </div>
      </div>

      {/* Navigation Cards */}
      <div className="p-4 grid grid-cols-1 gap-4 mt-4">
        {currentInvasion ? (
          <MenuCard 
            title={`INVASÃƒO ATIVA: ${currentInvasion.nations.name.toUpperCase()}`} 
            desc="Defenda ou ataque a RelÃ­quia inimiga!" 
            icon="âš”ï¸" 
            to="/invasion"
            highlight
          />
        ) : null}
        
        <div className="grid grid-cols-2 gap-4">
          <MenuCard title="Loja VIP" desc="BenÃ§Ã£o dos Antigos" icon="ðŸ’Ž" to="/vip-shop" />
          <MenuCard title="Viajar" desc="Mudar regiÃ£o de caÃ§a" icon="ðŸ§­" to="/map-selection" />
          <MenuCard title="InventÃ¡rio" desc="Seus tesouros" icon="ðŸŽ’" to="/inventory" />
          <MenuCard title="Ranking" desc="Hall da Fama" icon="ðŸ†" to="/ranking" />
        </div>
        <MenuCard title="Chat da Guilda" desc="Fale com seus aliados" icon="ðŸ¹" to="/guild-chat" />
      </div>

      {/* RelatÃ³rio de ExpediÃ§Ã£o (Modal de Retorno) */}
      {offlineReport && (
        <div className="fixed inset-0 bg-black/90 z-[60] flex items-center justify-center p-6 animate-in fade-in duration-500">
          <div className={cn(
            "bg-slate-900 border-t-2 border-b-2 p-8 rounded-3xl w-full max-w-sm text-center relative overflow-hidden",
            offlineReport.died ? "border-red-600 shadow-[0_0_40px_rgba(220,38,38,0.3)]" : "border-arcane-gold shadow-[0_0_40px_rgba(212,175,55,0.2)]"
          )}>
            <div className="mythic-aura-bg opacity-10" />
            <h2 className={cn(
              "text-2xl font-black font-cinzel mb-2 uppercase",
              offlineReport.died ? "text-red-500" : "text-arcane-gold"
            )}>
              {offlineReport.died ? "ðŸ’€ Derrota em Combate" : "RelatÃ³rio de CaÃ§a"}
            </h2>
            <p className="text-[10px] text-slate-500 uppercase tracking-[0.2em] mb-6">
              {offlineReport.died ? "VocÃª foi abatido por NPCs!" : `ExpediÃ§Ã£o de ${offlineReport.hours.toFixed(1)} horas`}
            </p>
            
            <div className="grid grid-cols-2 gap-4 mb-8">
              <div className="bg-slate-800/50 p-4 rounded-2xl border border-white/5">
                <div className="text-[8px] text-slate-500 font-bold mb-1">XP GANHO</div>
                <div className="text-xl font-black text-emerald-500">+{offlineReport.xp}</div>
              </div>
              <div className="bg-slate-800/50 p-4 rounded-2xl border border-white/5">
                <div className="text-[8px] text-slate-500 font-bold mb-1">ADENA (GOLD)</div>
                <div className="text-xl font-black text-arcane-gold">+{offlineReport.gold}</div>
              </div>
            </div>

            {offlineReport.died && (
              <p className="text-[10px] text-red-400 mb-6 italic">Seu herÃ³i fugiu de volta para a capital com ferimentos leves (-5% Adena).</p>
            )}

            {player.is_vip && <div className="mb-6 text-[10px] text-arcane-gold animate-pulse font-bold">âœ¨ BÃ´nus VIP de 30% aplicado!</div>}

            <button 
              onClick={() => setOfflineReport(null)}
              className="w-full bg-arcane-gold text-void-slate py-4 rounded-xl font-black uppercase tracking-widest text-sm shadow-[0_10px_20px_rgba(212,175,55,0.2)]"
            >
              Coletar Recompensas
            </button>
          </div>
        </div>
      )}

      {/* Quick Action Button */}
      <div className="fixed bottom-6 left-4 right-4 flex justify-center pointer-events-none">
        <Link 
          to="/shop" 
          className="pointer-events-auto bg-gradient-to-b from-arcane-gold to-yellow-700 text-void-slate px-10 py-4 rounded-2xl font-black text-lg uppercase shadow-[0_0_30px_rgba(212,175,55,0.3)] active:scale-95 transition-all"
        >
          ðŸ’Ž LOJA DE PACKS
        </Link>
      </div>

      {/* Modal de Detalhes do Buff */}
      {selectedRelic && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center p-6 z-50" onClick={() => setSelectedRelic(null)}>
          <div 
            className="bg-slate-900 border-2 border-arcane-gold/50 p-6 rounded-2xl w-full max-w-xs relative overflow-hidden shadow-[0_0_50px_rgba(212,175,55,0.2)]"
            onClick={e => e.stopPropagation()}
          >
            <div className="mythic-aura-bg opacity-20 scale-150" />
            
            <div className="relative z-10 flex flex-col items-center text-center">
              <ItemIcon slot="relic" itemClass={20} size={64} isRelic className="mb-4" />
              <h2 className="text-xl font-black text-arcane-gold font-cinzel uppercase mb-1">{selectedRelic.name}</h2>
              <p className="text-[10px] text-slate-500 uppercase tracking-widest mb-6">RelÃ­quia de NaÃ§Ã£o Ativa</p>

              <div className="grid grid-cols-2 gap-4 w-full mb-8">
                <div className="bg-slate-800/50 border border-white/5 p-3 rounded-xl">
                  <div className="text-[8px] text-slate-500 font-bold uppercase mb-1">Ataque</div>
                  <div className="text-lg font-black text-red-500">+{selectedRelic.attack}</div>
                </div>
                <div className="bg-slate-800/50 border border-white/5 p-3 rounded-xl">
                  <div className="text-[8px] text-slate-500 font-bold uppercase mb-1">Defesa</div>
                  <div className="text-lg font-black text-blue-500">+{selectedRelic.defense}</div>
                </div>
              </div>

              <button 
                onClick={() => setSelectedRelic(null)}
                className="w-full bg-slate-800 border border-slate-700 py-3 rounded-xl font-bold text-xs uppercase tracking-widest hover:bg-slate-700 transition-colors"
              >
                Fechar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

function StatBox({ label, value, color, isGold = false }: any) {
  return (
    <div className="bg-slate-900 border border-arcane-gold/30 rounded-lg p-3 text-center shadow-2xl backdrop-blur-md">
      <div className="text-[9px] font-bold text-slate-500 uppercase mb-1">{label}</div>
      <div className={cn("text-lg font-black font-mono", color)}>
        {isGold ? `ðŸ’°${value.toLocaleString()}` : value.toLocaleString()}
      </div>
    </div>
  )
}

function MenuCard({ title, desc, icon, to, highlight = false }: any) {
  return (
    <Link 
      to={to} 
      className={cn(
        "p-4 rounded-2xl border transition-all active:scale-95 flex items-center gap-4",
        highlight 
          ? "bg-blood-red/20 border-blood-red shadow-[0_0_15px_rgba(127,29,29,0.3)]" 
          : "bg-slate-800/40 border-slate-700 hover:border-arcane-gold/50"
      )}
    >
      <div className="text-3xl">{icon}</div>
      <div>
        <div className={cn("font-black uppercase text-sm font-cinzel", highlight ? "text-red-500" : "text-white")}>{title}</div>
        <div className="text-[10px] text-slate-400 uppercase tracking-wider">{desc}</div>
      </div>
    </Link>
  )
}
