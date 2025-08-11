#!/bin/bash

# Vercel Deployment Script for Slip Platform
# Make sure you have Vercel CLI installed: npm i -g vercel

echo "🚀 Starting Vercel Deployment for Slip Platform..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI is not installed. Installing now..."
    npm install -g vercel
fi

# Check if user is logged in
if ! vercel whoami &> /dev/null; then
    echo "🔐 Please log in to Vercel..."
    vercel login
fi

# Build the project
echo "🔨 Building the project..."
npm run build

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Deploy to Vercel
    echo "🚀 Deploying to Vercel..."
    vercel --prod
    
    echo "🎉 Deployment completed!"
    echo "📱 Check your Vercel dashboard for the deployment status"
else
    echo "❌ Build failed! Please fix the errors and try again."
    exit 1
fi
