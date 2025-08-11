import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

export async function POST(request: NextRequest) {
  try {
    const { userId, formatId, items, totalAmount } = await request.json()
    
    if (!userId || !formatId || !items || !totalAmount) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      )
    }
    
    // Create the slip
    const { data: slip, error: slipError } = await supabase
      .from('slips')
      .insert({
        user_id: userId,
        format_id: formatId,
        total_amount: totalAmount,
        created_at: new Date().toISOString()
      })
      .select()
      .single()
    
    if (slipError) throw slipError
    
    // Create slip items
    const slipItems = items.map((item: any) => ({
      slip_id: slip.id,
      fruit_id: item.fruit_id,
      quantity: item.quantity,
      unit_price: item.unit_price,
      total_price: item.total_price
    }))
    
    const { error: itemsError } = await supabase
      .from('slip_items')
      .insert(slipItems)
    
    if (itemsError) throw itemsError
    
    return NextResponse.json(slip)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to create slip' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const userId = searchParams.get('userId')
    
    if (!userId) {
      return NextResponse.json(
        { error: 'User ID is required' },
        { status: 400 }
      )
    }
    
    const { data, error } = await supabase
      .from('slips')
      .select(`
        *,
        format:slip_formats(*),
        items:slip_items(
          *,
          fruit:fruits(*)
        )
      `)
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    return NextResponse.json(data || [])
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch slips' },
      { status: 500 }
    )
  }
}

export async function PUT(request: NextRequest) {
  try {
    const { slipId, updates } = await request.json()
    
    if (!slipId) {
      return NextResponse.json(
        { error: 'Slip ID is required' },
        { status: 400 }
      )
    }
    
    const { data, error } = await supabase
      .from('slips')
      .update(updates)
      .eq('id', slipId)
      .select()
      .single()
    
    if (error) throw error
    
    return NextResponse.json(data)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to update slip' },
      { status: 500 }
    )
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const slipId = searchParams.get('id')
    
    if (!slipId) {
      return NextResponse.json(
        { error: 'Slip ID is required' },
        { status: 400 }
      )
    }
    
    // Delete slip items first
    const { error: itemsError } = await supabase
      .from('slip_items')
      .delete()
      .eq('slip_id', slipId)
    
    if (itemsError) throw itemsError
    
    // Delete the slip
    const { error: slipError } = await supabase
      .from('slips')
      .delete()
      .eq('id', slipId)
    
    if (slipError) throw slipError
    
    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to delete slip' },
      { status: 500 }
    )
  }
}
