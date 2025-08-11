'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase'
import Navigation from '@/components/Navigation'

interface SlipFormat {
  id: string
  name: string
  description: string
  template_html: string
  is_active: boolean
  created_at: string
  updated_at: string
}

interface SystemStats {
  total_users: number
  total_slips: number
  total_formats: number
  total_revenue: number
}

export default function AdminPage() {
  const [user, setUser] = useState<any>(null)
  const [formats, setFormats] = useState<SlipFormat[]>([])
  const [stats, setStats] = useState<SystemStats>({
    total_users: 0,
    total_slips: 0,
    total_formats: 0,
    total_revenue: 0
  })
  const [loading, setLoading] = useState(true)
  const [editingFormat, setEditingFormat] = useState<SlipFormat | null>(null)
  const [showEditModal, setShowEditModal] = useState(false)
  const [newFormat, setNewFormat] = useState({
    name: '',
    description: '',
    template_html: '',
    is_active: true
  })

  useEffect(() => {
    const getUser = async () => {
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        // Check if user is admin (you can implement your own admin check logic)
        setUser(user)
        loadData()
      } else {
        window.location.href = '/auth'
      }
    }
    getUser()

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event: any, session: any) => {
      if (session?.user) {
        setUser(session.user)
        loadData()
      } else {
        setUser(null)
        window.location.href = '/auth'
      }
    })
    return () => subscription.unsubscribe()
  }, [])

  const loadData = async () => {
    try {
      setLoading(true)
      console.log('collab: Loading admin data...')
      
      // Load formats
      const { data: formatsData, error: formatsError } = await supabase
        .from('slip_formats')
        .select('*')
        .order('created_at', { ascending: false })

      if (formatsError) throw formatsError

      // Load stats
      const { data: usersData, error: usersError } = await supabase
        .from('profiles')
        .select('id', { count: 'exact' })

      if (usersError) throw usersError

      const { data: slipsData, error: slipsError } = await supabase
        .from('slips')
        .select('total_amount', { count: 'exact' })

      if (slipsError) throw slipsError

      const totalRevenue = slipsData?.reduce((sum: number, slip: any) => sum + (slip.total_amount || 0), 0) || 0

      setFormats(formatsData || [])
      setStats({
        total_users: usersData?.length || 0,
        total_slips: slipsData?.length || 0,
        total_formats: formatsData?.length || 0,
        total_revenue: totalRevenue
      })

      console.log('collab: Admin data loaded successfully')
    } catch (error) {
      console.error('collab: Error loading admin data:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleCreateFormat = async () => {
    try {
      const { error } = await supabase
        .from('slip_formats')
        .insert([newFormat])

      if (error) throw error

      console.log('collab: Created new slip format')
      setNewFormat({ name: '', description: '', template_html: '', is_active: true })
      loadData()
    } catch (error) {
      console.error('collab: Error creating format:', error)
    }
  }

  const handleUpdateFormat = async () => {
    if (!editingFormat) return

    try {
      const { error } = await supabase
        .from('slip_formats')
        .update({
          name: editingFormat.name,
          description: editingFormat.description,
          template_html: editingFormat.template_html,
          is_active: editingFormat.is_active,
          updated_at: new Date().toISOString()
        })
        .eq('id', editingFormat.id)

      if (error) throw error

      console.log('collab: Updated slip format:', editingFormat.id)
      setShowEditModal(false)
      setEditingFormat(null)
      loadData()
    } catch (error) {
      console.error('collab: Error updating format:', error)
    }
  }

  const toggleFormatStatus = async (formatId: string, currentStatus: boolean) => {
    try {
      const { error } = await supabase
        .from('slip_formats')
        .update({ is_active: !currentStatus })
        .eq('id', formatId)

      if (error) throw error

      console.log('collab: Toggled format status:', formatId)
      loadData()
    } catch (error) {
      console.error('collab: Error toggling format status:', error)
    }
  }

  const deleteFormat = async (formatId: string) => {
    if (!confirm('Are you sure you want to delete this format? This action cannot be undone.')) return

    try {
      const { error } = await supabase
        .from('slip_formats')
        .delete()
        .eq('id', formatId)

      if (error) throw error

      console.log('collab: Deleted slip format:', formatId)
      loadData()
    } catch (error) {
      console.error('collab: Error deleting format:', error)
    }
  }

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    window.location.href = '/auth'
  }

  if (!user) return <div>Loading...</div>

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navigation user={user} onSignOut={handleSignOut} />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Admin Dashboard</h1>
          <p className="mt-2 text-gray-600 dark:text-gray-400">Manage slip formats and view system statistics</p>
        </div>

        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Users</div>
            <div className="mt-2 text-3xl font-bold text-blue-600">{stats.total_users}</div>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Slips</div>
            <div className="mt-2 text-3xl font-bold text-green-600">{stats.total_slips}</div>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Formats</div>
            <div className="mt-2 text-3xl font-bold text-purple-600">{stats.total_formats}</div>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Revenue</div>
            <div className="mt-2 text-3xl font-bold text-yellow-600">Rs {stats.total_revenue.toFixed(2)}</div>
          </div>
        </div>

        {/* Create New Format */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 mb-8">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">Create New Format</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Name</label>
              <input
                type="text"
                value={newFormat.name}
                onChange={(e) => setNewFormat({ ...newFormat, name: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Format name"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Description</label>
              <input
                type="text"
                value={newFormat.description}
                onChange={(e) => setNewFormat({ ...newFormat, description: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Format description"
              />
            </div>
          </div>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Template HTML</label>
            <textarea
              value={newFormat.template_html}
              onChange={(e) => setNewFormat({ ...newFormat, template_html: e.target.value })}
              rows={4}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="HTML template for the slip format"
            />
          </div>
          <div className="flex items-center mb-4">
            <input
              type="checkbox"
              id="is_active"
              checked={newFormat.is_active}
              onChange={(e) => setNewFormat({ ...newFormat, is_active: e.target.checked })}
              className="mr-2"
            />
            <label htmlFor="is_active" className="text-sm text-gray-700 dark:text-gray-300">Active</label>
          </div>
          <button
            onClick={handleCreateFormat}
            disabled={!newFormat.name || !newFormat.template_html}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Create Format
          </button>
        </div>

        {/* Formats Management */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
          <div className="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
            <h2 className="text-xl font-semibold text-gray-900 dark:text-white">Manage Formats</h2>
          </div>
          <div className="overflow-x-auto">
            {loading ? (
              <div className="p-8 text-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                <p className="mt-4 text-gray-600 dark:text-gray-400">Loading formats...</p>
              </div>
            ) : (
              <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead className="bg-gray-50 dark:bg-gray-700">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Name</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Description</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Status</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Created</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Actions</th>
                  </tr>
                </thead>
                <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                  {formats.map((format) => (
                    <tr key={format.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">
                        {format.name}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500 dark:text-gray-300 max-w-xs truncate">
                        {format.description}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          format.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                        }`}>
                          {format.is_active ? 'Active' : 'Inactive'}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">
                        {new Date(format.created_at).toLocaleDateString()}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                        <button
                          onClick={() => {
                            setEditingFormat(format)
                            setShowEditModal(true)
                          }}
                          className="text-blue-600 hover:text-blue-900 dark:text-blue-400 dark:hover:text-blue-300"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => toggleFormatStatus(format.id, format.is_active)}
                          className={`${
                            format.is_active ? 'text-yellow-600 hover:text-yellow-900' : 'text-green-600 hover:text-green-900'
                          } dark:text-yellow-400 dark:hover:text-yellow-300 dark:text-green-400 dark:hover:text-green-300`}
                        >
                          {format.is_active ? 'Deactivate' : 'Activate'}
                        </button>
                        <button
                          onClick={() => deleteFormat(format.id)}
                          className="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300"
                        >
                          Delete
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>

      {/* Edit Modal */}
      {showEditModal && editingFormat && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-hidden">
            <div className="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                Edit Format: {editingFormat.name}
              </h2>
              <button
                onClick={() => setShowEditModal(false)}
                className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <div className="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Name</label>
                  <input
                    type="text"
                    value={editingFormat.name}
                    onChange={(e) => setEditingFormat({ ...editingFormat, name: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Description</label>
                  <input
                    type="text"
                    value={editingFormat.description}
                    onChange={(e) => setEditingFormat({ ...editingFormat, description: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Template HTML</label>
                <textarea
                  value={editingFormat.template_html}
                  onChange={(e) => setEditingFormat({ ...editingFormat, template_html: e.target.value })}
                  rows={8}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div className="flex items-center mb-4">
                <input
                  type="checkbox"
                  id="edit_is_active"
                  checked={editingFormat.is_active}
                  onChange={(e) => setEditingFormat({ ...editingFormat, is_active: e.target.checked })}
                  className="mr-2"
                />
                <label htmlFor="edit_is_active" className="text-sm text-gray-700 dark:text-gray-300">Active</label>
              </div>
            </div>
            <div className="p-6 border-t border-gray-200 dark:border-gray-700">
              <div className="flex justify-end space-x-3">
                <button
                  onClick={() => setShowEditModal(false)}
                  className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
                >
                  Cancel
                </button>
                <button
                  onClick={handleUpdateFormat}
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  Update Format
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
