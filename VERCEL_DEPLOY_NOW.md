# 🚀 Vercel'e Deploy - Şimdi!

## ✅ GitHub'a Push Tamamlandı!

Repo hazır: https://github.com/tdemir97/bandbuddy

## 🎯 Şimdi Vercel'e Deploy Et

### Adım 1: Vercel Dashboard'a Git

1. **https://vercel.com** → Login ol (GitHub hesabınla)
2. **"New Project"** butonuna tıkla
3. **"Import Git Repository"** → GitHub repo'nu seç
   - `tdemir97/bandbuddy` seç

### Adım 2: Environment Variables Ekle

**ÖNEMLİ:** Environment Variables eklemeyi unutma!

1. Project ayarlarında **"Environment Variables"** bölümüne git
2. Şu 3 değişkeni ekle:

```
NEXT_PUBLIC_SUPABASE_URL
https://thtoxwaebzvsjrzblcms.supabase.co
```

```
NEXT_PUBLIC_SUPABASE_ANON_KEY
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRodG94d2FlYnp2c2pyemJsY21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyODExNjcsImV4cCI6MjA3Nzg1NzE2N30.8DBlP6DrWHDAqC--6ZTrvG6kMOGR9-us8cfXcEK9B04
```

```
GEMINI_API_KEY
AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng
```

3. Her birini ekle ve **"Save"** yap
4. **Production, Preview, Development** hepsine seçili olduğundan emin ol

### Adım 3: Deploy Et

1. **"Deploy"** butonuna tıkla
2. **2-3 dakika bekle** → Build tamamlanacak
3. **Site URL'i al** (örn: `bandbuddy.vercel.app`)

### Adım 4: Supabase RLS Policy Fix

**Deploy etmeden önce yapılması gereken:**

1. **Supabase Dashboard** → **SQL Editor**
2. Şu SQL'i çalıştır:

```sql
DROP POLICY IF EXISTS "Users can insert their own essay evaluations" ON essay_evaluations;

CREATE POLICY "Users can insert their own essay evaluations" ON essay_evaluations
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM essays WHERE essays.id = essay_evaluations.essay_id AND essays.user_id = auth.uid()
  ));
```

### Adım 5: Test Et

1. Site URL'ine git
2. Sign up yap
3. Essay yaz ve submit et
4. Evaluation'ın çalıştığını kontrol et

---

## 🎉 Tamamlandı!

Artık siteniz canlıda! Her GitHub push'unda otomatik deploy olacak.

---

## 📝 Notlar

- **Environment Variables** eklemeyi unutma!
- **Supabase RLS Policy** fix'i yapmayı unutma!
- Build log'larını kontrol et: Vercel Dashboard → Deployments → Logs


