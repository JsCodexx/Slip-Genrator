import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const activeOnly = searchParams.get('activeOnly') === 'true'
    
    let query = supabase
      .from('slip_formats')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (activeOnly) {
      query = query.eq('is_active', true)
    }
    
    const { data, error } = await query
    
    if (error) throw error
    
    return NextResponse.json(data || [])
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch slip formats' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const { name, description, template_html, logo_data, logo_type, store_name, store_address, store_phone, store_email, store_website, tax_rate, currency_symbol, footer_text } = await request.json()
    
    if (!name || !template_html) {
      return NextResponse.json(
        { error: 'Name and template HTML are required' },
        { status: 400 }
      )
    }
    
    const { data, error } = await supabase
      .from('slip_formats')
      .insert({
        name,
        description,
        template_html,
        logo_data,
        logo_type,
        store_name,
        store_address,
        store_phone,
        store_email,
        store_website,
        tax_rate: tax_rate || 0,
        currency_symbol: currency_symbol || 'Rs',
        footer_text,
        is_active: true
      })
      .select()
      .single()
    
    if (error) throw error
    
    return NextResponse.json(data)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to create slip format' },
      { status: 500 }
    )
  }
}

export async function PUT(request: NextRequest) {
  try {
    const { id, name, description, template_html, logo_data, logo_type, store_name, store_address, store_phone, store_email, store_website, tax_rate, currency_symbol, footer_text, is_active } = await request.json()
    
    if (!id) {
      return NextResponse.json(
        { error: 'ID is required' },
        { status: 400 }
      )
    }
    
    const { data, error } = await supabase
      .from('slip_formats')
      .update({
        name,
        description,
        template_html,
        logo_data,
        logo_type,
        store_name,
        store_address,
        store_phone,
        store_email,
        store_website,
        tax_rate,
        currency_symbol,
        footer_text,
        is_active
      })
      .eq('id', id)
      .select()
      .single()
    
    if (error) throw error
    
    return NextResponse.json(data)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to update slip format' },
      { status: 500 }
    )
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const formatId = searchParams.get('id')
    
    if (!formatId) {
      return NextResponse.json(
        { error: 'Format ID is required' },
        { status: 400 }
      )
    }
    
    // First, check if the format exists
    const { data: existingFormat, error: fetchError } = await supabase
      .from('slip_formats')
      .select('id')
      .eq('id', formatId)
      .single()
    
    if (fetchError || !existingFormat) {
      return NextResponse.json(
        { error: 'Format not found' },
        { status: 404 }
      )
    }
    
    // Delete the format
    const { error: deleteError } = await supabase
      .from('slip_formats')
      .delete()
      .eq('id', formatId)
    
    if (deleteError) throw deleteError
    
    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to delete slip format' },
      { status: 500 }
    )
  }
}
