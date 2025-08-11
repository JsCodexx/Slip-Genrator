# Supabase Setup Guide for Slip Generation Platform

This guide will help you set up Supabase for the Slip Generation Platform, which allows users to generate POS-style receipts with dynamic pricing and multiple format options.

## Prerequisites

- A Supabase account (free tier works fine)
- Node.js and npm installed on your machine

## Step 1: Create a New Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `slip_generation` (or your preferred name)
   - **Database Password**: Create a strong password (save this!)
   - **Region**: Choose the closest to your users
5. Click "Create new project"
6. Wait for the project to be created (this may take a few minutes)

## Step 2: Get Your Project Credentials

1. In your project dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (e.g., `https://your-project-id.supabase.co`)
   - **Anon public key** (starts with `eyJ...`)
   - **Service role key** (starts with `eyJ...`)

## Step 3: Set Up Environment Variables

1. In your project root, create a `.env.local` file
2. Add the following variables:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
```

**Important**: Replace the placeholder values with your actual Supabase credentials.

## Step 4: Set Up Authentication

1. In your Supabase dashboard, go to **Authentication** → **Settings**
2. Under **Site URL**, add: `http://localhost:3000`
3. Under **Redirect URLs**, add: `http://localhost:3000/auth/callback`
4. Save the changes

## Step 5: Set Up the Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the entire contents of `database-setup.sql`
3. Paste it into the SQL editor
4. Click **Run** to execute the script

This will create:
- **Profiles table**: User management
- **Slip formats table**: 20 different slip templates
- **Fruits table**: Product catalog with price ranges
- **Slips table**: Main slip records for POS receipts
- **Slip items table**: Individual items on each slip
- **Generic slips table**: For other document types
- **RLS policies**: Row-level security for data protection
- **Functions and triggers**: For automation and calculations
- **Sample data**: 20 slip formats and 20 fruits

## Step 6: Test the Setup

1. Start your development server: `npm run dev`
2. Navigate to `http://localhost:3000`
3. You should be redirected to the auth page
4. Create a new account or sign in
5. You should see the Slip Generation Dashboard

## Database Schema Overview

### Tables

1. **`profiles`**: User profiles and authentication
2. **`slip_formats`**: Available slip templates (20 formats)
3. **`fruits`**: Product catalog with base/max prices
4. **`slips`**: Generated POS slip records
5. **`slip_items`**: Individual items on each slip
6. **`generic_slips`**: Generic document storage

### Key Features

- **Unique serial numbers**: Each slip gets a unique identifier
- **Random date generation**: Slips get dates within your specified range
- **Dynamic pricing**: Fruit prices are randomly generated between base and max prices
- **Multiple formats**: Choose from 20 different slip designs
- **Receipt-style layout**: Professional receipt appearance matching your design requirements

### Slip Design

The generated slips now use a professional receipt format with:
- Company header and branding
- Date, time, and receipt number
- Clean item listing with prices
- Totals section with cash and change calculation
- Professional footer with thank you message
- Print-optimized styling

## Troubleshooting

### Common Issues

1. **"supabaseUrl is required" error**
   - Check that your `.env.local` file exists and has the correct values
   - Restart your development server after making changes

2. **Authentication errors**
   - Verify your Site URL and Redirect URLs in Supabase settings
   - Check that your environment variables are correct

3. **Database connection issues**
   - Ensure your Supabase project is active
   - Check that the database schema was created successfully

4. **Magic Link not working**
   - Verify your Supabase project URL is correct
   - Check that email provider is enabled in Authentication settings

### Getting Help

- Check the browser console for error messages
- Verify your Supabase project status in the dashboard
- Ensure all environment variables are set correctly
- Check that the database schema was created without errors

## Next Steps

After setup, you can:
1. Generate slips with different formats
2. Customize fruit selections and quantities
3. Set date ranges for slip generation
4. Save slips to the database
5. Print professional-looking receipts
6. View and manage your generated slips

The platform now generates beautiful, receipt-style slips that match your design requirements exactly!
