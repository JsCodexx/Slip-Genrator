# Vercel Deployment Guide for Slip Platform

## 🚀 Prerequisites

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **GitHub/GitLab/Bitbucket**: Your code should be in a Git repository
3. **Supabase Project**: Ensure your Supabase project is set up and running

## 📋 Environment Variables Setup

### 1. Local Development
Create a `.env.local` file in your project root:
```bash
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://slip_genration.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here

# Optional: Service Role Key (for server-side operations)
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
```

### 2. Vercel Environment Variables
In your Vercel dashboard, add these environment variables:

| Variable Name | Value | Environment |
|---------------|-------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | `https://slip_genration.supabase.co` | Production, Preview, Development |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Your Supabase anon key | Production, Preview, Development |
| `SUPABASE_SERVICE_ROLE_KEY` | Your Supabase service role key | Production, Preview, Development |

## 🔧 Configuration Files

### 1. vercel.json
Already configured with:
- Build configuration for Next.js
- Environment variable mapping
- API function timeout settings

### 2. next.config.js
Optimized for Vercel with:
- Image optimization
- Security headers
- SWC minification

## 📦 Deployment Steps

### Method 1: Vercel CLI (Recommended)

1. **Install Vercel CLI**:
```bash
npm i -g vercel
```

2. **Login to Vercel**:
```bash
vercel login
```

3. **Deploy**:
```bash
vercel
```

4. **Follow the prompts**:
   - Link to existing project or create new
   - Set project name
   - Confirm deployment

### Method 2: GitHub Integration

1. **Connect Repository**:
   - Go to [vercel.com/dashboard](https://vercel.com/dashboard)
   - Click "New Project"
   - Import your Git repository

2. **Configure Project**:
   - Set project name
   - Framework preset: Next.js
   - Root directory: `./` (if not root)

3. **Environment Variables**:
   - Add all required environment variables
   - Set them for Production, Preview, and Development

4. **Deploy**:
   - Click "Deploy"
   - Vercel will automatically build and deploy

## 🌐 Domain Configuration

### Custom Domain (Optional)
1. Go to your project settings in Vercel
2. Navigate to "Domains"
3. Add your custom domain
4. Update DNS records as instructed

## 🔍 Post-Deployment Checklist

### 1. Verify Environment Variables
- Check that all Supabase environment variables are set
- Test authentication functionality
- Verify database connections

### 2. Test Core Features
- User authentication (sign up/sign in)
- Template creation and editing
- Slip generation and printing
- Database operations

### 3. Check Console for Errors
- Open browser developer tools
- Look for any console errors
- Check network requests

## 🚨 Common Issues & Solutions

### 1. Environment Variables Not Loading
**Problem**: `NEXT_PUBLIC_SUPABASE_URL` is undefined
**Solution**: 
- Ensure variables are set in Vercel dashboard
- Redeploy after adding variables
- Check variable names (case-sensitive)

### 2. CORS Issues
**Problem**: Supabase requests blocked
**Solution**:
- Verify Supabase project settings
- Check allowed origins in Supabase dashboard
- Ensure proper environment variables

### 3. Build Failures
**Problem**: Build errors during deployment
**Solution**:
- Check `next.config.js` syntax
- Verify all dependencies in `package.json`
- Check for TypeScript errors

### 4. Database Connection Issues
**Problem**: Can't connect to Supabase
**Solution**:
- Verify Supabase project is active
- Check environment variables
- Ensure database is accessible

## 📱 Performance Optimization

### 1. Enable Vercel Analytics
```bash
vercel analytics
```

### 2. Enable Edge Functions (if needed)
Update `vercel.json`:
```json
{
  "functions": {
    "app/api/**/*.ts": {
      "maxDuration": 30
    }
  }
}
```

### 3. Image Optimization
Already configured in `next.config.js`:
```javascript
images: {
  domains: ['slip_genration.supabase.co'],
  unoptimized: true
}
```

## 🔄 Continuous Deployment

### Automatic Deployments
- Every push to `main` branch triggers production deployment
- Pull requests create preview deployments
- Branch deployments for development

### Manual Deployments
```bash
# Deploy to production
vercel --prod

# Deploy to preview
vercel

# Deploy specific branch
vercel --target=staging
```

## 📊 Monitoring & Analytics

### 1. Vercel Analytics
- Page views and performance
- User behavior tracking
- Real-time monitoring

### 2. Supabase Dashboard
- Database performance
- API usage statistics
- Authentication logs

## 🆘 Support

### Vercel Support
- [Vercel Documentation](https://vercel.com/docs)
- [Vercel Community](https://github.com/vercel/vercel/discussions)

### Supabase Support
- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Community](https://github.com/supabase/supabase/discussions)

## 🎯 Next Steps

1. **Deploy to Vercel** using the steps above
2. **Test all functionality** in the deployed environment
3. **Set up monitoring** and analytics
4. **Configure custom domain** if needed
5. **Set up CI/CD** for automated deployments

---

**Happy Deploying! 🚀**
