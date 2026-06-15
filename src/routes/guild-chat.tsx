import { createFileRoute } from '@tanstack/react-router'
import { createClient } from '@supabase/supabase-js'
import { useEffect, useState, useRef } from 'react'
import type { Database } from '../integrations/supabase/types'

const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
)

export const Route = createFileRoute('/guild-chat')({
  component: GuildChat,
})

function GuildChat() {
  const [messages, setMessages] = useState<any[]>([])
  const [player, setPlayer] = useState<any>(null)
  const [newMessage, setNewMessage] = useState('')
  const [loading, setLoading] = useState(true)
  const scrollRef = useRef<HTMLDivElement>(null)

  const tgUser = typeof window !== 'undefined' ? (window as any).Telegram?.WebApp?.initDataUnsafe?.user : null

  useEffect(() => {
    const setupChat = async () => {
      if (!tgUser) return

      // 1. Identificar o jogador e sua guilda
      const { data: profile } = await supabase
        .from('profiles')
        .select('*, players(*, guilds(*))')
        .eq('telegram_id', tgUser.id)
        .single()

      const playerData = (profile as any)?.players?.[0]
      if (!playerData || !playerData.guild_id) {
        setLoading(false)
        return
      }
      setPlayer(playerData)

      // 2. Buscar histÃ³rico de mensagens (Ãºltimas 50)
      const { data: history } = await supabase
        .from('guild_chat_messages' as any)
        .select('*, players(profiles(display_name))')
        .eq('guild_id', playerData.guild_id)
        .order('created_at', { ascending: true })
        .limit(50)

      setMessages(history || [])
      setLoading(false)
      setTimeout(scrollToBottom, 100)

      // 3. InscriÃ§Ã£o Realtime para novas mensagens
      const channel = supabase
        .channel(`guild:${playerData.guild_id}`)
        .on(
          'postgres_changes',
          {
            event: 'INSERT',
            schema: 'public',
            table: 'guild_chat_messages',
            filter: `guild_id=eq.${playerData.guild_id}`,
          },
          async (payload) => {
            // Buscar o nome do remetente para a nova mensagem
            const { data: sender } = await supabase
              .from('players')
              .select('profiles(display_name)')
              .eq('id', payload.new.player_id)
              .single()
            
            const fullMessage = { ...payload.new, players: sender }
            setMessages((prev) => [...prev, fullMessage])
            scrollToBottom()
          }
        )
        .subscribe()

      return () => {
        supabase.removeChannel(channel)
      }
    }

    setupChat()
  }, [])

  const scrollToBottom = () => {
    scrollRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  const sendMessage = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!newMessage.trim() || !player) return

    const content = newMessage.trim()
    setNewMessage('')

    const { error } = await supabase.from('guild_chat_messages' as any).insert({
      guild_id: player.guild_id,
      player_id: player.id,
      content: content,
    })

    if (error) alert('Erro ao enviar mensagem')
  }

  if (loading) return <div className="p-8 text-center text-slate-500 italic">Abrindo pergaminhos da guilda...</div>
  if (!player?.guild_id) return (
    <div className="p-8 text-center bg-slate-900 min-h-screen text-white flex flex-col justify-center">
      <div className="text-6xl mb-4">ðŸšï¸</div>
      <h2 className="text-2xl font-bold">Sem AlianÃ§a</h2>
      <p className="text-slate-400">VocÃª precisa se juntar a uma guilda para acessar este chat.</p>
    </div>
  )

  return (
    <div className="flex flex-col bg-slate-900 h-screen text-white">
      {/* Header */}
      <header className="p-4 bg-slate-800 border-b border-slate-700 flex justify-between items-center shadow-lg">
        <div>
          <h1 className="font-black text-yellow-500 uppercase tracking-tighter">Chat da Guilda</h1>
          <p className="text-[10px] text-slate-400 uppercase">{player.guilds?.name}</p>
        </div>
        <div className="text-xs font-mono text-slate-500">REALTIME ON</div>
      </header>

      {/* Mensagens */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((msg) => (
          <div key={msg.id} className={`flex flex-col ${msg.player_id === player.id ? 'items-end' : 'items-start'}`}>
            <span className="text-[10px] text-slate-500 mb-1 px-1">
              {msg.players?.profiles?.display_name || 'Desconhecido'}
            </span>
            <div className={`max-w-[80%] p-3 rounded-2xl text-sm ${msg.player_id === player.id ? 'bg-yellow-600 text-white rounded-tr-none' : 'bg-slate-800 text-slate-200 rounded-tl-none'}`}>
              {msg.content}
            </div>
          </div>
        ))}
        <div ref={scrollRef} />
      </div>

      {/* Input */}
      <form onSubmit={sendMessage} className="p-4 bg-slate-800 border-t border-slate-700 flex gap-2">
        <input
          type="text"
          value={newMessage}
          onChange={(e) => setNewMessage(e.target.value)}
          placeholder="Escreva para seus aliados..."
          className="flex-1 bg-slate-900 border border-slate-700 rounded-xl px-4 py-2 text-sm focus:outline-none focus:border-yellow-600 transition-colors"
        />
        <button type="submit" className="bg-yellow-600 p-2 rounded-xl active:scale-90 transition-transform">
          ðŸ¹
        </button>
      </form>
    </div>
  )
}
