#!/bin/bash

echo "🚀 BandBuddy Deployment Script"
echo "=============================="
echo ""

# Check if environment variables are set
if [ -z "$NEXT_PUBLIC_SUPABASE_URL" ] || [ -z "$NEXT_PUBLIC_SUPABASE_ANON_KEY" ] || [ -z "$GEMINI_API_KEY" ]; then
  echo "⚠️  Environment variables not set in terminal"
  echo ""
  echo "Setting environment variables for this deployment..."
  echo ""
  
  # Set environment variables (you can modify these)
  export NEXT_PUBLIC_SUPABASE_URL="https://thtoxwaebzvsjrzblcms.supabase.co"
  export NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRodG94d2FlYnp2c2pyemJsY21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyODExNjcsImV4cCI6MjA3Nzg1NzE2N30.8DBlP6DrWHDAqC--6ZTrvG6kMOGR9-us8cfXcEK9B04"
  export GEMINI_API_KEY="AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng"
  
  echo "✅ Environment variables set"
  echo ""
fi

echo "📦 Deploying to Vercel..."
echo ""

# Deploy to Vercel
npx vercel --prod --yes --env NEXT_PUBLIC_SUPABASE_URL="$NEXT_PUBLIC_SUPABASE_URL" --env NEXT_PUBLIC_SUPABASE_ANON_KEY="$NEXT_PUBLIC_SUPABASE_ANON_KEY" --env GEMINI_API_KEY="$GEMINI_API_KEY"

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📝 Next steps:"
echo "1. Go to Vercel Dashboard: https://vercel.com/dashboard"
echo "2. Select your project"
echo "3. Go to Settings > Environment Variables"
echo "4. Add these variables permanently:"
echo "   - NEXT_PUBLIC_SUPABASE_URL"
echo "   - NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "   - GEMINI_API_KEY"
echo "5. Make sure Supabase RLS policy is fixed (see FIX_RLS.sql)"
echo ""
