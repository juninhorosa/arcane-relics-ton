import { createFileRoute } from '@tanstack/react-start'
import { useEffect, useState } from 'react'

export const Route = createFileRoute('/admin/audit-logs')({
  component: AdminAuditLogs,
})

function AdminAuditLogs() {
  const [logs, setLogs] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [filter, setFilter] = useState('all')
  const [page, setPage] = useState(0)
  const [totalCount, setTotalCount] = useState(0)
  const pageSize = 20

  const fetchLogs = async () => {
    setLoading(true)
    const params = new URLSearchParams({
      page: page.toString(),
      type: filter,
      search: search
    })
    const res = await fetch(`/api/admin/audit-logs?${params.toString()}`)
    const result = await res.json()
    setLogs(result.data || [])
    setTotalCount(result.count || 0)
    setLoading(false)
  }

  useEffect(() => {
    fetchLogs()
  }, [filter, page])

  const getActionStyles = (type: string) => {
    switch (type) {
      case 'ban': return 'bg-red-100 text-red-700 border-red-200'
      case 'unban': return 'bg-blue-100 text-blue-700 border-blue-200'
      case 'grant_item': return 'bg-green-100 text-green-700 border-green-200'
      default: return 'bg-slate-100 text-slate-700 border-slate-200'
    }
  }

  const totalPages = Math.ceil(totalCount / pageSize)

  return (
    <div className="p-8 bg-white min-h-screen">
      <header className="mb-8 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Logs de Auditoria</h1>
          <p className="text-slate-500">Histórico de ações disciplinares e administrativas</p>
        </div>
        <div className="flex flex-wrap items-center gap-4">
          <div className="flex gap-2">
            <input 
              type="text" 
              placeholder="Buscar herói..." 
              className="border rounded-lg px-3 py-2 text-sm bg-white shadow-sm focus:ring-2 focus:ring-slate-200 outline-none transition-all w-48"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') {
                  if (page !== 0) setPage(0);
                  else fetchLogs();
                }
              }}
            />
            <button 
              onClick={() => {
                if (page !== 0) setPage(0);
                else fetchLogs();
              }}
              className="bg-slate-900 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-slate-800 transition-colors"
            >
              Buscar
            </button>
          </div>
          <div className="flex items-center gap-2 border-l pl-4 border-slate-200">
            <label className="text-sm font-medium text-slate-600 whitespace-nowrap">Ação:</label>
          <select 
            value={filter}
            onChange={(e) => {
              setFilter(e.target.value)
              setPage(0) // Reseta para a primeira página ao filtrar
            }}
            className="border rounded-lg px-3 py-2 text-sm bg-white shadow-sm focus:ring-2 focus:ring-slate-200 outline-none transition-all"
          >
            <option value="all">Todas as Ações</option>
            <option value="ban">Banimentos</option>
            <option value="unban">Desbanimentos</option>
            <option value="grant_item">Concessão de Itens</option>
          </select>
        </div>
      </header>

      <div className="overflow-x-auto">
        <table className="w-full border-collapse">
          <thead>
            <tr className="bg-slate-100 text-left text-xs uppercase text-slate-600">
              <th className="p-4 border">Data</th>
              <th className="p-4 border">Ação</th>
              <th className="p-4 border">Herói Alvo</th>
              <th className="p-4 border">Motivo</th>
              <th className="p-4 border">Admin ID</th>
            </tr>
          </thead>
          <tbody className="text-sm">
            {loading ? (
              <tr><td colSpan={5} className="p-4 text-center">Carregando logs...</td></tr>
            ) : logs.map(log => (
              <tr key={log.id} className="hover:bg-slate-50">
                <td className="p-4 border text-slate-500">{new Date(log.created_at).toLocaleString()}</td>
                <td className="p-4 border font-bold">
                  <span className={`px-2 py-1 rounded border text-[10px] font-black tracking-tight ${getActionStyles(log.action_type)}`}>
                    {log.action_type.toUpperCase()}
                  </span>
                </td>
                <td className="p-4 border">
                  {log.target?.profiles?.display_name} <span className="text-slate-400 text-xs">@{log.target?.profiles?.username}</span>
                </td>
                <td className="p-4 border italic">"{log.reason}"</td>
                <td className="p-4 border font-mono text-xs">{log.admin?.id?.substring(0, 8)}...</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Controles de Paginação */}
      {!loading && totalPages > 1 && (
        <div className="mt-6 flex justify-between items-center bg-slate-50 p-4 rounded-lg border border-slate-200">
          <div className="text-sm text-slate-500">
            Mostrando {logs.length} de {totalCount} registros
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => setPage(p => Math.max(0, p - 1))}
              disabled={page === 0}
              className="px-4 py-2 text-sm font-medium bg-white border rounded-md hover:bg-slate-50 disabled:opacity-50 transition-colors"
            >
              Anterior
            </button>
            <div className="flex items-center px-4 text-sm font-bold text-slate-700">
              Página {page + 1} de {totalPages}
            </div>
            <button
              onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
              disabled={page >= totalPages - 1}
              className="px-4 py-2 text-sm font-medium bg-white border rounded-md hover:bg-slate-50 disabled:opacity-50 transition-colors"
            >
              Próximo
            </button>
          </div>
        </div>
      )}
    </div>
  )
}