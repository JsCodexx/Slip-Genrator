import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'

// Force dynamic rendering for this route
export const dynamic = 'force-dynamic'

export async function GET(request: Request) {
  try {
    const requestUrl = new URL(request.url)
    const code = requestUrl.searchParams.get('code')
    const next = requestUrl.searchParams.get('next') || '/'

    if (code) {
      const supabase = createRouteHandlerClient({ cookies })
      
      // For implicit flow, we don't need to exchange code for session
      // The session should already be available
      const { data: { session }, error } = await supabase.auth.getSession()
      
      if (error) {
        console.error('Auth callback error:', error)
        // Redirect to auth page with error
        return NextResponse.redirect(`${requestUrl.origin}/auth?error=auth_callback_failed`)
      }
      
      if (!session) {
        console.error('No session found after magic link')
        return NextResponse.redirect(`${requestUrl.origin}/auth?error=no_session`)
      }
    }

    // URL to redirect to after sign in process completes
    // Use the 'next' parameter or default to home page
    const redirectUrl = next.startsWith('/') ? `${requestUrl.origin}${next}` : `${requestUrl.origin}/`
    return NextResponse.redirect(redirectUrl)
  } catch (error) {
    console.error('Auth callback error:', error)
    // Fallback redirect to auth page
    const requestUrl = new URL(request.url)
    return NextResponse.redirect(`${requestUrl.origin}/auth?error=callback_error`)
  }
}
