#!/bin/bash

echo "🚀 Deploying Slip Platform from Root Directory..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Installing..."
    npm install -g vercel
fi

# Check if user is logged in
if ! vercel whoami &> /dev/null; then
    echo "🔐 Please login to Vercel..."
    vercel login
fi

echo "📦 Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful! Deploying to Vercel..."
    echo "📍 IMPORTANT: Keep Root Directory as '/' (root) in Vercel setup"
    echo "🔧 Use the full vercel.json configuration"
    echo "🌍 Set environment variables in Vercel dashboard"
    
    vercel --prod
else
    echo "❌ Build failed. Please fix errors before deploying."
    exit 1
fi
