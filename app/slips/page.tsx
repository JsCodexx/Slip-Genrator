'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase'
import Navigation from '@/components/Navigation'

interface Slip {
  id: string
  serial_number: string
  slip_date: string
  total_amount: number
  items_count: number
  status: string
  print_count: number
  created_at: string
  format: {
    name: string
    description: string
  }
}

export default function SlipsPage() {
  const [user, setUser] = useState<any>(null)
  const [slips, setSlips] = useState<Slip[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState<string>('all')

  useEffect(() => {
    const getUser = async () => {
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        setUser(user)
        loadSlips()
      } else {
        window.location.href = '/auth'
      }
    }
    getUser()

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event: any, session: any) => {
      if (session?.user) {
        setUser(session.user)
        loadSlips()
      } else {
        setUser(null)
        window.location.href = '/auth'
      }
    })
    return () => subscription.unsubscribe()
  }, [])

  const loadSlips = async () => {
    try {
      setLoading(true)
      console.log('collab: Loading user slips...')
      
      const { data, error } = await supabase
        .from('slips')
        .select(`
          *,
          format:slip_formats(name, description)
        `)
        .eq('user_id', user?.id)
        .order('created_at', { ascending: false })

      if (error) throw error
      
      console.log('collab: Loaded slips:', data?.length || 0)
      setSlips(data || [])
    } catch (error) {
      console.error('collab: Error loading slips:', error)
    } finally {
      setLoading(false)
    }
  }

  const updateSlipStatus = async (slipId: string, newStatus: string) => {
    try {
      const { error } = await supabase
        .from('slips')
        .update({ status: newStatus })
        .eq('id', slipId)

      if (error) throw error

      console.log('collab: Updated slip status:', slipId, 'to', newStatus)
      loadSlips()
    } catch (error) {
      console.error('collab: Error updating slip status:', error)
    }
  }

  const deleteSlip = async (slipId: string) => {
    if (!confirm('Are you sure you want to delete this slip?')) return

    try {
      const { error } = await supabase
        .from('slips')
        .delete()
        .eq('id', slipId)

      if (error) throw error

      console.log('collab: Deleted slip:', slipId)
      loadSlips()
    } catch (error) {
      console.error('collab: Error deleting slip:', error)
    }
  }

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    window.location.href = '/auth'
  }

  if (!user) return <div>Loading...</div>

  const filteredSlips = slips.filter(slip => {
    if (statusFilter !== 'all' && slip.status !== statusFilter) return false
    if (searchTerm && !slip.serial_number.toLowerCase().includes(searchTerm.toLowerCase())) return false
    return true
  })

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navigation user={user} onSignOut={handleSignOut} />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">My Slips</h1>
          <p className="mt-2 text-gray-600 dark:text-gray-400">View and manage all your generated slips</p>
        </div>

        {/* Filters */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 mb-8">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Search</label>
              <input
                type="text"
                placeholder="Search by serial number..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Status</label>
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="all">All Statuses</option>
                <option value="generated">Generated</option>
                <option value="printed">Printed</option>
                <option value="archived">Archived</option>
              </select>
            </div>
          </div>
        </div>

        {/* Slips List */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
          {loading ? (
            <div className="p-8 text-center">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
              <p className="mt-4 text-gray-600 dark:text-gray-400">Loading slips...</p>
            </div>
          ) : filteredSlips.length === 0 ? (
            <div className="p-8 text-center">
              <p className="text-gray-600 dark:text-gray-400">No slips found</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead className="bg-gray-50 dark:bg-gray-700">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Serial Number</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Format</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Date</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Items</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Total</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Status</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Actions</th>
                  </tr>
                </thead>
                <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                  {filteredSlips.map((slip) => (
                    <tr key={slip.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">{slip.serial_number}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{slip.format.name}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{new Date(slip.slip_date).toLocaleDateString()}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">{slip.items_count}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">Rs {slip.total_amount.toFixed(2)}</td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          slip.status === 'generated' ? 'bg-yellow-100 text-yellow-800' :
                          slip.status === 'printed' ? 'bg-green-100 text-green-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {slip.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                        <button
                          onClick={() => updateSlipStatus(slip.id, 'archived')}
                          className="text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-300"
                        >
                          Archive
                        </button>
                        <button
                          onClick={() => deleteSlip(slip.id)}
                          className="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300"
                        >
                          Delete
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Summary Stats */}
        {filteredSlips.length > 0 && (
          <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Slips</div>
              <div className="mt-2 text-3xl font-bold text-gray-900 dark:text-white">{filteredSlips.length}</div>
            </div>
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Value</div>
              <div className="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
                Rs {filteredSlips.reduce((sum, slip) => sum + slip.total_amount, 0).toFixed(2)}
              </div>
            </div>
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Printed</div>
              <div className="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
                {filteredSlips.filter(slip => slip.status === 'printed').length}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
