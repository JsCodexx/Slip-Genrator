@echo off
echo 🚀 Deploying Slip Platform from Root Directory...

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Vercel CLI not found. Installing...
    npm install -g vercel
)

REM Check if user is logged in
vercel whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo 🔐 Please login to Vercel...
    vercel login
)

echo 📦 Building project...
call npm run build

if %errorlevel% equ 0 (
    echo ✅ Build successful! Deploying to Vercel...
    echo 📍 IMPORTANT: Keep Root Directory as '/' (root) in Vercel setup
    echo 🔧 Use the full vercel.json configuration
    echo 🌍 Set environment variables in Vercel dashboard
    
    vercel --prod
) else (
    echo ❌ Build failed. Please fix errors before deploying.
    pause
    exit /b 1
)
