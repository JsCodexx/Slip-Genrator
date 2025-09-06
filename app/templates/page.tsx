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
  logo_data?: string
  logo_type?: string
  store_name?: string
  store_address?: string
  store_phone?: string
  store_email?: string
  store_website?: string
  tax_rate?: number
  currency_symbol?: string
  footer_text?: string
}

export default function TemplatesPage() {
  const [user, setUser] = useState<any>(null)
  const [formats, setFormats] = useState<SlipFormat[]>([])
  const [loading, setLoading] = useState(true)
  const [selectedFormat, setSelectedFormat] = useState<SlipFormat | null>(null)
  const [showPreview, setShowPreview] = useState(false)
  const [showCreateForm, setShowCreateForm] = useState(false)
  const [showEditForm, setShowEditForm] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  
  // Form state for creating new template
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    template_html: '',
    logo: null as File | null,
    store_name: '',
    store_address: '',
    store_phone: '',
    store_email: '',
    store_website: '',
    tax_rate: 0,
    currency_symbol: 'Rs',
    footer_text: ''
  })

  // Form state for editing existing template
  const [editFormData, setEditFormData] = useState({
    id: '',
    name: '',
    description: '',
    template_html: '',
    logo: null as File | null,
    store_name: '',
    store_address: '',
    store_phone: '',
    store_email: '',
    store_website: '',
    tax_rate: 0,
    currency_symbol: 'Rs',
    footer_text: '',
    existing_logo_data: '',
    existing_logo_type: ''
  })

  const [creating, setCreating] = useState(false)
  const [updating, setUpdating] = useState(false)
  const [newLogoPreview, setNewLogoPreview] = useState<string | null>(null)
  const [logoPreviewLoading, setLogoPreviewLoading] = useState(false)

  useEffect(() => {
    const getUser = async () => {
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        setUser(user)
        loadFormats()
      } else {
        window.location.href = '/auth'
      }
    }
    getUser()

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event: any, session: any) => {
      if (session?.user) {
        setUser(session.user)
        loadFormats()
      } else {
        setUser(null)
        window.location.href = '/auth'
      }
    })
    return () => subscription.unsubscribe()
  }, [])

  const loadFormats = async () => {
    try {
      setLoading(true)
      console.log('collab: Loading slip formats...')
      
      const { data, error } = await supabase
        .from('slip_formats')
        .select('*')
        .eq('is_active', true)
        .order('name', { ascending: true })

      if (error) throw error
      
      console.log('collab: Loaded formats:', data?.length || 0)
      setFormats(data || [])
    } catch (error) {
      console.error('collab: Error loading formats:', error)
    } finally {
      setLoading(false)
    }
  }

  const handlePreview = (format: SlipFormat) => {
    setSelectedFormat(format)
    setShowPreview(true)
  }

  const handleCreateTemplate = async () => {
    try {
      setCreating(true)
      console.log('collab: Creating new template...')

      let logoData = null
      let logoType = null

      // Convert logo to base64 if provided
      if (formData.logo) {
        const reader = new FileReader()
        logoData = await new Promise<string>((resolve) => {
          reader.onload = (e) => resolve(e.target?.result as string)
          reader.readAsDataURL(formData.logo!)
        })
        logoType = formData.logo.type
      }

      // Create the new template
      const { data, error } = await supabase
        .from('slip_formats')
        .insert({
          name: formData.name,
          description: formData.description,
          template_html: formData.template_html,
          logo_data: logoData,
          logo_type: logoType,
          store_name: formData.store_name,
          store_address: formData.store_address,
          store_phone: formData.store_phone,
          store_email: formData.store_email,
          store_website: formData.store_website,
          tax_rate: formData.tax_rate,
          currency_symbol: formData.currency_symbol,
          footer_text: formData.footer_text,
          is_active: true
        })
        .select()

      if (error) throw error

      console.log('collab: Template created successfully:', data)
      
      // Reset form and close modal
      setFormData({
        name: '',
        description: '',
        template_html: '',
        logo: null,
        store_name: '',
        store_address: '',
        store_phone: '',
        store_email: '',
        store_website: '',
        tax_rate: 0,
        currency_symbol: 'Rs',
        footer_text: ''
      })
      setShowCreateForm(false)
      
      // Reload formats
      await loadFormats()
      
      alert('Template created successfully!')
    } catch (error) {
      console.error('collab: Error creating template:', error)
      alert('Error creating template: ' + (error as Error).message)
    } finally {
      setCreating(false)
    }
  }

  const handleEdit = (format: SlipFormat) => {
    setEditFormData({
      id: format.id,
      name: format.name,
      description: format.description || '',
      template_html: format.template_html,
      logo: null,
      store_name: format.store_name || '',
      store_address: format.store_address || '',
      store_phone: format.store_phone || '',
      store_email: format.store_email || '',
      store_website: format.store_website || '',
      tax_rate: format.tax_rate || 0,
      currency_symbol: format.currency_symbol || 'Rs',
      footer_text: format.footer_text || '',
      existing_logo_data: format.logo_data || '',
      existing_logo_type: format.logo_type || ''
    })
    setNewLogoPreview(null)
    setLogoPreviewLoading(false)
    setShowEditForm(true)
  }

  const handleUpdateTemplate = async () => {
    try {
      setUpdating(true)
      console.log('collab: Updating template...')

      let logoData = editFormData.existing_logo_data
      let logoType = editFormData.existing_logo_type

      // Convert new logo to base64 if provided
      if (editFormData.logo) {
        const reader = new FileReader()
        logoData = await new Promise<string>((resolve) => {
          reader.onload = (e) => resolve(e.target?.result as string)
          reader.readAsDataURL(editFormData.logo!)
        })
        logoType = editFormData.logo.type
      }

      // Update the existing template
      const { data, error } = await supabase
        .from('slip_formats')
        .update({
          name: editFormData.name,
          description: editFormData.description,
          template_html: editFormData.template_html,
          logo_data: logoData,
          logo_type: logoType,
          store_name: editFormData.store_name,
          store_address: editFormData.store_address,
          store_phone: editFormData.store_phone,
          store_email: editFormData.store_email,
          store_website: editFormData.store_website,
          tax_rate: editFormData.tax_rate,
          currency_symbol: editFormData.currency_symbol,
          footer_text: editFormData.footer_text
        })
        .eq('id', editFormData.id)
        .select()

      if (error) throw error

      console.log('collab: Template updated successfully:', data)
      
      // Close modal and reload formats
      setShowEditForm(false)
      setNewLogoPreview(null)
      setLogoPreviewLoading(false)
      await loadFormats()
      
      alert('Template updated successfully!')
    } catch (error) {
      console.error('collab: Error updating template:', error)
      alert('Error updating template: ' + (error as Error).message)
    } finally {
      setUpdating(false)
    }
  }

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    window.location.href = '/auth'
  }

  if (!user) return <div>Loading...</div>

  const filteredFormats = formats.filter(format => 
    format.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    format.description.toLowerCase().includes(searchTerm.toLowerCase())
  )

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navigation user={user} onSignOut={handleSignOut} />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8 flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Slip Templates</h1>
            <p className="mt-2 text-gray-600 dark:text-gray-400">Browse and preview available slip formats</p>
          </div>
          <button
            onClick={() => setShowCreateForm(true)}
            className="px-6 py-3 bg-green-600 text-white rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500"
          >
            Create New Template
          </button>
        </div>

        {/* Search */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 mb-8">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Search Templates</label>
            <input
              type="text"
              placeholder="Search by name or description..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        {/* Templates Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {loading ? (
            Array.from({ length: 6 }).map((_, i) => (
              <div key={i} className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 animate-pulse">
                <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded mb-4"></div>
                <div className="h-3 bg-gray-200 dark:bg-gray-700 rounded mb-2"></div>
                <div className="h-3 bg-gray-200 dark:bg-gray-700 rounded w-2/3"></div>
              </div>
            ))
          ) : filteredFormats.length === 0 ? (
            <div className="col-span-full text-center py-12">
              <p className="text-gray-600 dark:text-gray-400">No templates found</p>
            </div>
          ) : (
            filteredFormats.map((format) => (
              <div key={format.id} className="bg-white dark:bg-gray-800 rounded-lg shadow hover:shadow-lg transition-shadow">
                <div className="p-6">
                  {/* Logo preview if available */}
                  {format.logo_data && (
                    <div className="mb-4 text-center">
                      <img 
                        src={format.logo_data} 
                        alt="Logo" 
                        className="h-16 w-16 mx-auto object-contain border rounded"
                      />
                    </div>
                  )}
                  
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                    {format.name}
                  </h3>
                  <p className="text-gray-600 dark:text-gray-400 mb-4 line-clamp-3">
                    {format.description}
                  </p>
                  
                  {/* Store details preview */}
                  {format.store_name && (
                    <div className="mb-4 text-sm text-gray-500 dark:text-gray-400">
                      <p><strong>Store:</strong> {format.store_name}</p>
                      {format.store_address && <p><strong>Address:</strong> {format.store_address}</p>}
                      {format.store_phone && <p><strong>Phone:</strong> {format.store_phone}</p>}
                    </div>
                  )}
                  
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-gray-500 dark:text-gray-400">
                      Created: {new Date(format.created_at).toLocaleDateString()}
                    </span>
                    <div className="flex space-x-2">
                      <button
                        onClick={() => handleEdit(format)}
                        className="px-3 py-2 bg-yellow-600 text-white rounded-md hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-yellow-500 text-sm"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => handlePreview(format)}
                        className="px-3 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                      >
                        Preview
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Summary Stats */}
        {filteredFormats.length > 0 && (
          <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Total Templates</div>
              <div className="mt-2 text-3xl font-bold text-gray-900 dark:text-white">{filteredFormats.length}</div>
            </div>
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <div className="text-sm font-medium text-gray-500 dark:text-gray-400">Active Formats</div>
              <div className="mt-2 text-3xl font-bold text-gray-900 dark:text-white">
                {filteredFormats.filter(format => format.is_active).length}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Create Template Modal */}
      {showCreateForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-hidden">
            <div className="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                Create New Template
              </h2>
              <button
                onClick={() => setShowCreateForm(false)}
                className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            
            <div className="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Basic Info */}
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Template Name *
                    </label>
                    <input
                      type="text"
                      value={formData.name}
                      onChange={(e) => setFormData({...formData, name: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter template name"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Description
                    </label>
                    <textarea
                      value={formData.description}
                      onChange={(e) => setFormData({...formData, description: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      rows={3}
                      placeholder="Enter template description"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Logo Image
                    </label>
                    <input
                      type="file"
                      accept="image/*"
                      onChange={(e) => setFormData({...formData, logo: e.target.files?.[0] || null})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <p className="text-xs text-gray-500 mt-1">Upload a logo image (PNG, JPG, JPEG)</p>
                  </div>
                </div>
                
                {/* Store Details */}
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Name *
                    </label>
                    <input
                      type="text"
                      value={formData.store_name}
                      onChange={(e) => setFormData({...formData, store_name: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store name"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Address
                    </label>
                    <textarea
                      value={formData.store_address}
                      onChange={(e) => setFormData({...formData, store_address: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      rows={2}
                      placeholder="Enter store address"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Phone
                    </label>
                    <input
                      type="text"
                      value={formData.store_phone}
                      onChange={(e) => setFormData({...formData, store_phone: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store phone number"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Email
                    </label>
                    <input
                      type="email"
                      value={formData.store_email}
                      onChange={(e) => setFormData({...formData, store_email: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store email"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Website
                    </label>
                    <input
                      type="url"
                      value={formData.store_website}
                      onChange={(e) => setFormData({...formData, store_website: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store website"
                    />
                  </div>
                  
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                        Tax Rate (%)
                      </label>
                      <input
                        type="number"
                        step="0.01"
                        min="0"
                        max="100"
                        value={formData.tax_rate}
                        onChange={(e) => setFormData({...formData, tax_rate: parseFloat(e.target.value) || 0})}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="0.00"
                      />
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                        Currency Symbol
                      </label>
                      <input
                        type="text"
                        value={formData.currency_symbol}
                        onChange={(e) => setFormData({...formData, currency_symbol: e.target.value})}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Rs"
                      />
                    </div>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Footer Text
                    </label>
                    <input
                      type="text"
                      value={formData.footer_text}
                      onChange={(e) => setFormData({...formData, footer_text: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter custom footer text"
                    />
                  </div>
                </div>
              </div>
              
              {/* Template HTML */}
              <div className="mt-6">
                <div className="flex justify-between items-center mb-2">
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    Template HTML *
                  </label>
                  <button
                    type="button"
                    onClick={() => {
                      const sampleTemplate = `<div style="width:80mm;margin:auto;font-family:Courier New,monospace;border:1px solid #000;padding:4mm;font-size:10px;line-height:1.2">
  <div style="text-align:center;margin-bottom:3px">
    {{logo}}
    <h2 style="margin:2px 0;color:#333;font-size:12px">{{store_name}}</h2>
    <p style="margin:1px 0;color:#666;font-size:8px">{{store_address}}</p>
    <p style="margin:1px 0;color:#666;font-size:8px">Phone: {{store_phone}}</p>
    <p style="margin:1px 0;color:#666;font-size:8px">Email: {{store_email}}</p>
  </div>
  
  <hr style="border:1px solid #ddd;margin:2px 0">
  
  <div style="margin-bottom:3px">
    <p style="margin:1px 0;font-size:9px">Date: {{date}}</p>
    <p style="margin:1px 0;font-size:9px">Slip #: {{slip_number}}</p>
  </div>
  
  <hr style="border:1px solid #ddd;margin:2px 0">
  
  <div style="margin-bottom:3px">
    {{#each items}}
    <div style="display:flex;justify-content:space-between;margin:1px 0;font-size:9px">
      <span>{{name}}</span>
      <span>{{price}}</span>
    </div>
    {{/each}}
  </div>
  
  <hr style="border:1px solid #ddd;margin:2px 0">
  
  <div style="text-align:right;margin-bottom:3px">
    <p style="margin:1px 0;font-weight:bold;font-size:9px">Subtotal: {{currency_symbol}} {{total}}</p>
    <p style="margin:1px 0;font-size:8px;color:#666">Tax ({{tax_rate}}%): {{currency_symbol}} {{tax_amount}}</p>
    <p style="margin:1px 0;font-weight:bold;font-size:9px">Total: {{currency_symbol}} {{grand_total}}</p>
  </div>
  
  <div style="text-align:center;margin-top:3px;font-size:8px;color:#666">
    {{footer_text}}
  </div>
</div>`;
                      setFormData({...formData, template_html: sampleTemplate});
                    }}
                    className="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200"
                  >
                    Load Sample Template
                  </button>
                </div>
                <div className="mb-2 text-xs text-gray-500">
                  <p>Use these placeholders in your template:</p>
                  <ul className="list-disc list-inside mt-1 space-y-1">
                    <li><code>{'{{logo}}'}</code> - Will be replaced with the uploaded logo</li>
                    <li><code>{'{{store_name}}'}</code> - Will be replaced with store name</li>
                    <li><code>{'{{store_address}}'}</code> - Will be replaced with store address</li>
                    <li><code>{'{{store_phone}}'}</code> - Will be replaced with store phone</li>
                    <li><code>{'{{store_email}}'}</code> - Will be replaced with store email</li>
                    <li><code>{'{{store_website}}'}</code> - Will be replaced with store website</li>
                    <li><code>{'{{date}}'}</code> - Will be replaced with current date</li>
                    <li><code>{'{{slip_number}}'}</code> - Will be replaced with slip number</li>
                    <li><code>{'{{items}}'}</code> - Will be replaced with items list</li>
                    <li><code>{'{{total}}'}</code> - Will be replaced with total amount</li>
                    <li><code>{'{{grand_total}}'}</code> - Will be replaced with grand total amount</li>
                    <li><code>{'{{tax_amount}}'}</code> - Will be replaced with calculated tax amount</li>
                    <li><code>{'{{tax_rate}}'}</code> - Will be replaced with tax rate</li>
                    <li><code>{'{{currency_symbol}}'}</code> - Will be replaced with currency symbol</li>
                    <li><code>{'{{footer_text}}'}</code> - Will be replaced with footer text</li>
                  </ul>
                </div>
                <textarea
                  value={formData.template_html}
                  onChange={(e) => setFormData({...formData, template_html: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm"
                  rows={15}
                  placeholder="Enter your HTML template with placeholders..."
                />
              </div>
            </div>
            
            <div className="p-6 border-t border-gray-200 dark:border-gray-700">
              <div className="flex justify-end space-x-3">
                <button
                  onClick={() => setShowCreateForm(false)}
                  className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
                >
                  Cancel
                </button>
                <button
                  onClick={handleCreateTemplate}
                  disabled={creating || !formData.name || !formData.store_name || !formData.template_html}
                  className="px-6 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {creating ? 'Creating...' : 'Create Template'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Edit Template Modal */}
      {showEditForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-hidden">
            <div className="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                Edit Template: {editFormData.name}
              </h2>
              <button
                onClick={() => {
                  setShowEditForm(false)
                  setNewLogoPreview(null)
                  setLogoPreviewLoading(false)
                }}
                className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            
            <div className="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Basic Info */}
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Template Name *
                    </label>
                    <input
                      type="text"
                      value={editFormData.name}
                      onChange={(e) => setEditFormData({...editFormData, name: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter template name"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Description
                    </label>
                    <textarea
                      value={editFormData.description}
                      onChange={(e) => setEditFormData({...editFormData, description: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      rows={3}
                      placeholder="Enter template description"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Logo Image
                    </label>
                    {(editFormData.existing_logo_data || newLogoPreview || logoPreviewLoading) && (
                      <div className="mb-2">
                        <p className="text-xs text-gray-500 mb-2">
                          {logoPreviewLoading ? 'Processing new logo...' : 
                           newLogoPreview ? 'New logo preview:' : 'Current logo:'}
                        </p>
                        {logoPreviewLoading ? (
                          <div className="h-16 w-16 border rounded flex items-center justify-center bg-gray-100">
                            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
                          </div>
                        ) : (
                          <img 
                            src={newLogoPreview || editFormData.existing_logo_data} 
                            alt={newLogoPreview ? "New Logo Preview" : "Current Logo"} 
                            className="h-16 w-16 object-contain border rounded"
                          />
                        )}
                      </div>
                    )}
                    <input
                      type="file"
                      accept="image/*"
                      onChange={(e) => {
                        const file = e.target.files?.[0] || null;
                        setEditFormData({...editFormData, logo: file});
                        
                        // Create preview of new logo
                        if (file) {
                          setLogoPreviewLoading(true);
                          const reader = new FileReader();
                          reader.onload = (e) => {
                            setNewLogoPreview(e.target?.result as string);
                            setLogoPreviewLoading(false);
                          };
                          reader.onerror = () => {
                            setLogoPreviewLoading(false);
                          };
                          reader.readAsDataURL(file);
                        } else {
                          setNewLogoPreview(null);
                          setLogoPreviewLoading(false);
                        }
                      }}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                    <p className="text-xs text-gray-500 mt-1">Upload a new logo image to replace the current one (PNG, JPG, JPEG)</p>
                  </div>
                </div>
                
                {/* Store Details */}
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Name *
                    </label>
                    <input
                      type="text"
                      value={editFormData.store_name}
                      onChange={(e) => setEditFormData({...editFormData, store_name: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store name"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Address
                    </label>
                    <textarea
                      value={editFormData.store_address}
                      onChange={(e) => setEditFormData({...editFormData, store_address: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      rows={2}
                      placeholder="Enter store address"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Phone
                    </label>
                    <input
                      type="text"
                      value={editFormData.store_phone}
                      onChange={(e) => setEditFormData({...editFormData, store_phone: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store phone number"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Email
                    </label>
                    <input
                      type="email"
                      value={editFormData.store_email}
                      onChange={(e) => setEditFormData({...editFormData, store_email: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store email"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Store Website
                    </label>
                    <input
                      type="url"
                      value={editFormData.store_website}
                      onChange={(e) => setEditFormData({...editFormData, store_website: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter store website"
                    />
                  </div>
                  
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                        Tax Rate (%)
                      </label>
                      <input
                        type="number"
                        step="0.01"
                        min="0"
                        max="100"
                        value={editFormData.tax_rate}
                        onChange={(e) => setEditFormData({...editFormData, tax_rate: parseFloat(e.target.value) || 0})}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="0.00"
                      />
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                        Currency Symbol
                      </label>
                      <input
                        type="text"
                        value={editFormData.currency_symbol}
                        onChange={(e) => setEditFormData({...editFormData, currency_symbol: e.target.value})}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="Rs"
                      />
                    </div>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                      Footer Text
                    </label>
                    <input
                      type="text"
                      value={editFormData.footer_text}
                      onChange={(e) => setEditFormData({...editFormData, footer_text: e.target.value})}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Enter custom footer text"
                    />
                  </div>
                </div>
              </div>
              
              {/* Template HTML */}
              <div className="mt-6">
                <div className="flex justify-between items-center mb-2">
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    Template HTML *
                  </label>
                  <button
                    type="button"
                    onClick={() => {
                      const sampleTemplate = `<div style="width:320px;margin:auto;font-family:Verdana,sans-serif;border:1px solid #000;padding:10px">
  <div style="text-align:center;margin-bottom:15px">
    {{logo}}
    <h2 style="margin:10px 0;color:#333">{{store_name}}</h2>
    <p style="margin:5px 0;color:#666;font-size:12px">{{store_address}}</p>
    <p style="margin:5px 0;color:#666;font-size:12px">Phone: {{store_phone}}</p>
    <p style="margin:5px 0;color:#666;font-size:12px">Email: {{store_email}}</p>
  </div>
  
  <hr style="border:1px solid #ddd;margin:15px 0">
  
  <div style="margin-bottom:15px">
    <p style="margin:5px 0;font-size:12px">Date: {{date}}</p>
    <p style="margin:5px 0;font-size:12px">Slip #: {{slip_number}}</p>
  </div>
  
  <hr style="border:1px solid #ddd;margin:15px 0">
  
  <div style="margin-bottom:15px">
    {{#each items}}
    <div style="display:flex;justify-content:space-between;margin:5px 0;font-size:12px">
      <span>{{name}}</span>
      <span>{{price}}</span>
    </div>
    {{/each}}
  </div>
  
  <hr style="border:1px solid #ddd;margin:15px 0">
  
  <div style="text-align:right;margin-bottom:15px">
    <p style="margin:5px 0;font-weight:bold">Subtotal: {{currency_symbol}} {{total}}</p>
    <p style="margin:5px 0;font-size:11px;color:#666">Tax ({{tax_rate}}%): {{currency_symbol}} {{tax_amount}}</p>
    <p style="margin:5px 0;font-weight:bold">Total: {{currency_symbol}} {{grand_total}}</p>
  </div>
  
  <div style="text-align:center;margin-top:20px;font-size:11px;color:#666">
    {{footer_text}}
  </div>
</div>`;
                      setEditFormData({...editFormData, template_html: sampleTemplate});
                    }}
                    className="px-3 py-1 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200"
                  >
                    Load Sample Template
                  </button>
                </div>
                <div className="mb-2 text-xs text-gray-500">
                  <p>Use these placeholders in your template:</p>
                  <ul className="list-disc list-inside mt-1 space-y-1">
                    <li><code>{'{{logo}}'}</code> - Will be replaced with the uploaded logo</li>
                    <li><code>{'{{store_name}}'}</code> - Will be replaced with store name</li>
                    <li><code>{'{{store_address}}'}</code> - Will be replaced with store address</li>
                    <li><code>{'{{store_phone}}'}</code> - Will be replaced with store phone</li>
                    <li><code>{'{{store_email}}'}</code> - Will be replaced with store email</li>
                    <li><code>{'{{store_website}}'}</code> - Will be replaced with store website</li>
                    <li><code>{'{{date}}'}</code> - Will be replaced with current date</li>
                    <li><code>{'{{slip_number}}'}</code> - Will be replaced with slip number</li>
                    <li><code>{'{{items}}'}</code> - Will be replaced with items list</li>
                    <li><code>{'{{total}}'}</code> - Will be replaced with total amount</li>
                    <li><code>{'{{grand_total}}'}</code> - Will be replaced with grand total amount</li>
                    <li><code>{'{{tax_amount}}'}</code> - Will be replaced with calculated tax amount</li>
                    <li><code>{'{{tax_rate}}'}</code> - Will be replaced with tax rate</li>
                    <li><code>{'{{currency_symbol}}'}</code> - Will be replaced with currency symbol</li>
                    <li><code>{'{{footer_text}}'}</code> - Will be replaced with footer text</li>
                  </ul>
                </div>
                <textarea
                  value={editFormData.template_html}
                  onChange={(e) => setEditFormData({...editFormData, template_html: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm"
                  rows={15}
                  placeholder="Enter your HTML template with placeholders..."
                />
              </div>
            </div>
            
            <div className="p-6 border-t border-gray-200 dark:border-gray-700">
              <div className="flex justify-end space-x-3">
                <button
                  onClick={() => {
                    setShowEditForm(false)
                    setNewLogoPreview(null)
                    setLogoPreviewLoading(false)
                  }}
                  className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
                >
                  Cancel
                </button>
                <button
                  onClick={handleUpdateTemplate}
                  disabled={updating || !editFormData.name || !editFormData.store_name || !editFormData.template_html}
                  className="px-6 py-2 bg-yellow-600 text-white rounded-md hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-yellow-500 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {updating ? 'Updating...' : 'Update Template'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Preview Modal */}
      {showPreview && selectedFormat && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-hidden">
            <div className="flex justify-between items-center p-6 border-b border-gray-200 dark:border-gray-700">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                Preview: {selectedFormat.name}
              </h2>
              <button
                onClick={() => setShowPreview(false)}
                className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <div className="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
              <div className="prose dark:prose-invert max-w-none">
                <div dangerouslySetInnerHTML={{ __html: selectedFormat.template_html }} />
              </div>
            </div>
            <div className="p-6 border-t border-gray-200 dark:border-gray-700">
              <div className="flex justify-end space-x-3">
                <button
                  onClick={() => setShowPreview(false)}
                  className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
                >
                  Close
                </button>
                <button
                  onClick={() => {
                    setShowPreview(false)
                    window.location.href = '/'
                  }}
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  Use This Template
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
