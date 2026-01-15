# Deployment Guide - BandBuddy

## 🚀 Vercel Deployment

### 1. Environment Variables Gerekli

Vercel Dashboard'da şu environment variables'ları eklemeniz gerekiyor:

```
NEXT_PUBLIC_SUPABASE_URL=https://thtoxwaebzvsjrzblcms.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRodG94d2FlYnp2c2pyemJsY21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyODExNjcsImV4cCI6MjA3Nzg1NzE2N30.8DBlP6DrWHDAqC--6ZTrvG6kMOGR9-us8cfXcEK9B04
GEMINI_API_KEY=AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng
```

### 2. Vercel CLI ile Deploy

```bash
# Vercel'e login ol
vercel login

# Deploy et
vercel --prod
```

### 3. Vercel Dashboard ile Deploy

1. https://vercel.com adresine git
2. GitHub hesabınla login ol
3. "New Project" butonuna tıkla
4. Bu repository'yi seç
5. Environment Variables ekle (yukarıdaki değerler)
6. "Deploy" butonuna tıkla

### 4. Supabase RLS Policy Fix

Deploy etmeden önce Supabase'de şu SQL'i çalıştır:

```sql
DROP POLICY IF EXISTS "Users can insert their own essay evaluations" ON essay_evaluations;

CREATE POLICY "Users can insert their own essay evaluations" ON essay_evaluations
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM essays WHERE essays.id = essay_evaluations.essay_id AND essays.user_id = auth.uid()
  ));
```

### 5. Post-Deploy Checklist

- [ ] Environment variables eklendi mi?
- [ ] Supabase RLS policy düzeltildi mi?
- [ ] Site çalışıyor mu?
- [ ] Login/Signup çalışıyor mu?
- [ ] Essay submission çalışıyor mu?
- [ ] Evaluation çalışıyor mu?
- [ ] Reading generation çalışıyor mu?

## 📝 Notlar

- Vercel otomatik olarak GitHub push'larından deploy eder
- Environment variables değiştiğinde redeploy gerekir
- Build başarılı olmalı (test edildi ✅)
