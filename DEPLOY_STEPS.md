# 🚀 Hızlı Deployment Adımları

## 1. GitHub'a Push (Eğer henüz yapmadıysanız)

```bash
git init
git add .
git commit -m "Initial commit - BandBuddy"
git branch -M main
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

## 2. Vercel Dashboard'dan Deploy

1. **https://vercel.com** adresine git
2. **GitHub hesabınla login ol**
3. **"New Project"** butonuna tıkla
4. **Repository'yi seç** (BandBuddy projesi)
5. **Environment Variables ekle:**

   ```
   NEXT_PUBLIC_SUPABASE_URL = https://thtoxwaebzvsjrzblcms.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRodG94d2FlYnp2c2pyemJsY21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyODExNjcsImV4cCI6MjA3Nzg1NzE2N30.8DBlP6DrWHDAqC--6ZTrvG6kMOGR9-us8cfXcEK9B04
   GEMINI_API_KEY = AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng
   ```

6. **"Deploy"** butonuna tıkla
7. **2-3 dakika bekle** - Deploy tamamlanacak
8. **Site URL'i al** (örn: `bandbuddy.vercel.app`)

## 3. Supabase RLS Policy Fix

Deploy etmeden önce **Supabase SQL Editor**'da şu SQL'i çalıştır:

```sql
DROP POLICY IF EXISTS "Users can insert their own essay evaluations" ON essay_evaluations;

CREATE POLICY "Users can insert their own essay evaluations" ON essay_evaluations
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM essays WHERE essays.id = essay_evaluations.essay_id AND essays.user_id = auth.uid()
  ));
```

## ✅ Tamamlandı!

Artık siteniz canlıda! 🎉

**Not:** Her GitHub push'unda otomatik deploy olacak.

