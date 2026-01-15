# ⚙️ Environment Variables Ekleme

## ✅ Deploy Başarılı!

Site URL: https://bandbuddy-6tw0simfv-tuna-demirs-projects.vercel.app

## ⚠️ ÖNEMLİ: Environment Variables Ekle!

Deploy yapıldı ama environment variables eklenmedi. Vercel Dashboard'dan eklemen gerekiyor.

### Adım 1: Vercel Dashboard'a Git

1. **https://vercel.com** → Login ol
2. **Dashboard** → **bandbuddy** projesini seç
3. **Settings** → **Environment Variables**

### Adım 2: Environment Variables Ekle

Şu 3 değişkeni ekle:

#### 1. NEXT_PUBLIC_SUPABASE_URL
```
Value: https://thtoxwaebzvsjrzblcms.supabase.co
Environments: Production, Preview, Development (hepsi seçili)
```

#### 2. NEXT_PUBLIC_SUPABASE_ANON_KEY
```
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRodG94d2FlYnp2c2pyemJsY21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyODExNjcsImV4cCI6MjA3Nzg1NzE2N30.8DBlP6DrWHDAqC--6ZTrvG6kMOGR9-us8cfXcEK9B04
Environments: Production, Preview, Development (hepsi seçili)
```

#### 3. GEMINI_API_KEY
```
Value: AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng
Environments: Production, Preview, Development (hepsi seçili)
```

### Adım 3: Redeploy Et

Environment variables ekledikten sonra:

1. **Deployments** → **Latest deployment** → **"Redeploy"**
2. Veya **Settings** → **Environment Variables** → **"Save"** → Otomatik redeploy

---

## ✅ Sonraki Adımlar

1. ✅ **Environment Variables ekle** (yukarıdaki adımlar)
2. ✅ **Redeploy et**
3. ✅ **Supabase RLS Policy fix** (FIX_RLS.sql dosyasındaki SQL'i çalıştır)
4. ✅ **Test et** (Site URL'ine git, sign up, essay yaz)

---

## 🎉 Tamamlandı!

Environment variables ekledikten ve redeploy ettikten sonra site tam çalışır hale gelecek!


