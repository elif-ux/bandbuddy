# 🚀 Hızlı Başlangıç - BandBuddy

## ✅ Şu An Yapılanlar

1. ✅ **Gemini API Key eklendi**
2. ✅ **Development server başlatıldı**
3. ✅ **Vercel CLI yükleniyor**

## 🌐 Local Development

**Server çalışıyor:**
👉 http://localhost:3000

**Not:** Supabase ayarları yapılmadığı için auth ve database çalışmayacak. Sadece UI'ı görebilirsiniz.

## 🚀 Vercel'e Deploy (En Kolay Yöntem)

### Adım 1: Vercel CLI ile Login

```bash
vercel login
```

### Adım 2: Environment Variables'ı Vercel'e Ekle

Vercel dashboard'dan ekleyin veya CLI ile:

```bash
vercel env add GEMINI_API_KEY
# Value: AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng

vercel env add NEXT_PUBLIC_SUPABASE_URL
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
vercel env add SUPABASE_SERVICE_ROLE_KEY
```

### Adım 3: Deploy Et

```bash
vercel --prod
```

**VEYA daha kolay:**

### GitHub ile Otomatik Deploy

1. **GitHub'a push edin:**
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/bandbuddy.git
git push -u origin main
```

2. **Vercel.com'a gidin:**
   - https://vercel.com → "New Project"
   - GitHub repo'yu seçin
   - Environment variables'ı ekleyin:
     - `GEMINI_API_KEY` = AIzaSyBax9d1-KZkUkcCkl6uydz9BY8YbwEcvng
     - Supabase credentials (sonra ekleyeceksiniz)
   - "Deploy" butonuna tıklayın

**✅ 2 dakikada canlıda!**

## 📋 Sonraki Adımlar

### Supabase Kurulumu (Gerekli)

1. **Supabase hesabı oluştur:**
   - https://supabase.com → Sign Up
   - Yeni project oluştur

2. **Database migration çalıştır:**
   - Supabase Dashboard → SQL Editor
   - `supabase/migrations/001_initial_schema.sql` dosyasını çalıştır

3. **API Keys al:**
   - Settings → API
   - Project URL ve anon key'i kopyala

4. **Environment variables'a ekle:**
   ```env
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
   ```

## 🎯 Şimdi Ne Yapabilirsiniz?

✅ **Local'de test:** http://localhost:3000
✅ **Vercel'e deploy:** `vercel --prod`
✅ **GitHub'a push:** Her push → otomatik deploy

## 🆘 Sorun mu var?

**Server çalışmıyor mu?**
```bash
npm run dev
```

**Build hatası mı?**
```bash
npm run build
```

**Vercel deploy hatası mı?**
- Environment variables'ı kontrol edin
- `vercel --prod --debug` ile debug edin

---

**Tebrikler! 🎉 BandBuddy hazır!**

