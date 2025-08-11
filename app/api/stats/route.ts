import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

export async function GET(request: NextRequest) {
  try {
    // Get total users
    const { count: userCount, error: userError } = await supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
    
    if (userError) throw userError
    
    // Get total slips
    const { count: slipCount, error: slipError } = await supabase
      .from('slips')
      .select('*', { count: 'exact', head: true })
    
    if (slipError) throw slipError
    
    // Get total formats
    const { count: formatCount, error: formatError } = await supabase
      .from('slip_formats')
      .select('*', { count: 'exact', head: true })
    
    if (formatError) throw formatError
    
    // Get total fruits
    const { count: fruitCount, error: fruitError } = await supabase
      .from('fruits')
      .select('*', { count: 'exact', head: true })
    
    if (fruitError) throw fruitError
    
    // Get recent slips (last 7 days)
    const sevenDaysAgo = new Date()
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7)
    
    const { count: recentSlipCount, error: recentError } = await supabase
      .from('slips')
      .select('*', { count: 'exact', head: true })
      .gte('created_at', sevenDaysAgo.toISOString())
    
    if (recentError) throw recentError
    
    // Get active formats
    const { count: activeFormatCount, error: activeError } = await supabase
      .from('slip_formats')
      .select('*', { count: 'exact', head: true })
      .eq('is_active', true)
    
    if (activeError) throw activeError
    
    // Get total slip items
    const { count: itemCount, error: itemError } = await supabase
      .from('slip_items')
      .select('*', { count: 'exact', head: true })
    
    if (itemError) throw itemError
    
    const stats = {
      users: userCount || 0,
      slips: slipCount || 0,
      formats: formatCount || 0,
      fruits: fruitCount || 0,
      recentSlips: recentSlipCount || 0,
      activeFormats: activeFormatCount || 0,
      totalItems: itemCount || 0,
      lastUpdated: new Date().toISOString()
    }
    
    return NextResponse.json(stats)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch statistics' },
      { status: 500 }
    )
  }
}
