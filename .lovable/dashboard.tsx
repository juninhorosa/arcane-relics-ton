import { createFileRoute } from '@tanstack/react-start'
import { useEffect, useState } from 'react'

export const Route = createFileRoute('/admin/dashboard')({
  component: AdminDashboard,
})

function AdminDashboard() {
  const [stats, setStats] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetch('/api/admin/stats')
      .then(res => res.json())
      .then(data => {
        setStats(data)
        setLoading(false)
      })
  }, [])

  if (loading) return <div className="p-8">Carregando métricas do reino...</div>

  return (
    <div className="p-8 bg-slate-50 min-h-screen">
      <header className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900">Painel de Controle Arcano</h1>
        <p className="text-slate-500">Métricas globais e monitoramento de transações</p>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <StatCard title="Total de Heróis" value={stats.totalPlayers} icon="👤" color="bg-blue-500" />
        <StatCard title="TON Arrecadado" value={`${stats.totalTon} TON`} icon="💎" color="bg-emerald-500" />
        <StatCard title="Batalhas Travadas" value={stats.totalBattles} icon="⚔️" color="bg-red-500" />
        <StatCard title="Packs Vendidos" value={Object.values(stats.salesByPack || {}).reduce((a: any, b: any) => a + b, 0)} icon="📦" color="bg-amber-500" />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
            ⚔️ Rivalidades Ativas
            <span className="text-xs font-normal text-slate-500">(Limite para Proteção: 50)</span>
          </h2>
          <div className="space-y-6">
            {stats.rivalries && stats.rivalries.map((r: any, i: number) => (
              <div key={i} className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="font-medium text-slate-700">
                    {r.winner?.name} <span className="text-slate-400 mx-1">massacrando</span> {r.loser?.name}
                  </span>
                  <span className="font-bold text-slate-900">{r.count} / 50</span>
                </div>
                <div className="h-2 w-full bg-slate-100 rounded-full overflow-hidden">
                  <div 
                    className={`h-full transition-all duration-500 ${r.count >= 40 ? 'bg-red-500 animate-pulse' : r.count >= 25 ? 'bg-amber-500' : 'bg-blue-500'}`}
                    style={{ width: `${Math.min((r.count / 50) * 100, 100)}%` }}
                  ></div>
                </div>
              </div>
            ))}
            {(!stats.rivalries || stats.rivalries.length === 0) && (
              <p className="text-center text-slate-400 py-4 italic">Nenhuma rivalidade intensa no momento.</p>
            )}
          </div>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
          <h2 className="text-xl font-bold mb-4">Vendas por Categoria</h2>
          <div className="space-y-4">
            {stats.salesByPack && Object.entries(stats.salesByPack).map(([name, count]: any) => (
              <div key={name} className="flex justify-between items-center">
                <span className="text-slate-600">{name}</span>
                <span className="font-mono font-bold bg-slate-100 px-3 py-1 rounded">{count} units</span>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200 flex flex-col justify-center items-center text-center">
          <div className="text-4xl mb-2">🚀</div>
          <h2 className="text-xl font-bold">Anúncio Global</h2>
          <p className="text-sm text-slate-500 mb-4">Envie uma mensagem para todos os jogadores via Bot.</p>
          <button className="bg-slate-900 text-white px-6 py-2 rounded-lg font-medium hover:bg-slate-800 transition-colors">
            Criar Campanha
          </button>
        </div>
      </div>
    </div>
  )
}

function StatCard({ title, value, icon, color }: any) {
  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200 flex items-center gap-4">
      <div className={`${color} w-12 h-12 rounded-lg flex items-center justify-center text-2xl text-white shadow-inner`}>
        {icon}
      </div>
      <div>
        <p className="text-sm text-slate-500 font-medium uppercase tracking-wider">{title}</p>
        <p className="text-2xl font-bold text-slate-900">{value}</p>
      </div>
    </div>
  )
}