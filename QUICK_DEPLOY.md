# 🚀 Hızlı Deploy - 3 Adım

## ✅ Adım 1: Supabase RLS Policy Fix

Supabase Dashboard → SQL Editor → Şu SQL'i çalıştır:

```sql
DROP POLICY IF EXISTS "Users can insert their own essay evaluations" ON essay_evaluations;

CREATE POLICY "Users can insert their own essay evaluations" ON essay_evaluations
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM essays WHERE essays.id = essay_evaluations.essay_id AND essays.user_id = auth.uid()
  ));
```

## ✅ Adım 2: Vercel'e Deploy

### Seçenek A: Vercel Dashboard (Önerilen - En Kolay)

1. **https://vercel.com** → Login ol
2. **"New Project"** → GitHub repo seç
3. **Environment Variables ekle:**
   - `NEXT_PUBLIC_SUPABASE_URL` = `https://thtoxwaebzvsjrzblcms.supabase.co`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRodG94d2FlYnp2c2pyemJsY21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyODExNjcsImV4cCI6MjA3Nzg1NzE2N30.8DBlP6DrWHDAqC--6ZTrvG6kMOGR9-us8cfXcEK9B04`
   - `GEMINI_API_KEY` = `AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng`
4. **"Deploy"** butonuna tıkla
5. **2-3 dakika bekle** → Site hazır! 🎉

### Seçenek B: CLI ile

```bash
# Deploy script'i çalıştır
./deploy.sh

# Veya manuel
npx vercel --prod --yes
```

**Not:** CLI ile deploy edersen, environment variables'ları Vercel Dashboard'dan eklemen gerekecek.

## ✅ Adım 3: Test Et

1. Site URL'ine git (örn: `bandbuddy.vercel.app`)
2. Sign up yap
3. Essay yaz ve submit et
4. Evaluation'ın çalıştığını kontrol et

## 🎉 Tamamlandı!

Artık siteniz canlıda!

---

**Sorun mu var?**
- Environment variables eklendi mi kontrol et
- Supabase RLS policy düzeltildi mi kontrol et
- Build log'larına bak (Vercel Dashboard → Deployments → Logs)

