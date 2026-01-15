# 📤 GitHub'a Push Etme - Adım Adım

## Yöntem 1: GitHub Web'den Yeni Repo Oluştur (Önerilen)

### Adım 1: GitHub'da Yeni Repo Oluştur

1. **https://github.com** → Login ol
2. Sağ üstte **"+"** butonuna tıkla → **"New repository"**
3. Repository name: `bandbuddy` (veya istediğin isim)
4. **Public** veya **Private** seç
5. **"Create repository"** butonuna tıkla
6. **Önemli:** README, .gitignore, license ekleme (boş repo oluştur)

### Adım 2: Terminal'de Push Et

Aşağıdaki komutları sırayla çalıştır:

```bash
# 1. Git repo'yu başlat (eğer yoksa)
git init

# 2. Tüm dosyaları ekle
git add .

# 3. Commit yap
git commit -m "Initial commit - BandBuddy IELTS/TOEFL Platform"

# 4. Main branch'e geç
git branch -M main

# 5. GitHub repo URL'ini ekle (YENİ REPO URL'İNİ BURAYA YAPIŞTIR)
git remote add origin https://github.com/KULLANICI_ADI/REPO_ADI.git

# 6. GitHub'a push et
git push -u origin main
```

**Not:** `KULLANICI_ADI` ve `REPO_ADI` yerine kendi GitHub kullanıcı adın ve repo adını yaz.

### Örnek:

Eğer GitHub kullanıcı adın `tdemir97` ve repo adı `bandbuddy` ise:

```bash
git remote add origin https://github.com/tdemir97/bandbuddy.git
```

---

## Yöntem 2: Mevcut Repo'yu Değiştir

Eğer mevcut remote'u değiştirmek istersen:

```bash
# Mevcut remote'u kaldır
git remote remove origin

# Yeni remote ekle
git remote add origin https://github.com/KULLANICI_ADI/REPO_ADI.git

# Push et
git push -u origin main
```

---

## Sorun Giderme

### Eğer "remote origin already exists" hatası alırsan:

```bash
git remote remove origin
git remote add origin https://github.com/KULLANICI_ADI/REPO_ADI.git
```

### Eğer "authentication failed" hatası alırsan:

1. GitHub'da **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **"Generate new token"** → **"Generate new token (classic)"**
3. İsim ver: `vercel-deploy`
4. Scopes: `repo` seç (tüm repo izinleri)
5. **"Generate token"** → Token'ı kopyala
6. Terminal'de push yaparken password yerine bu token'ı kullan

### Eğer "nothing to commit" hatası alırsan:

```bash
# Dosyaları kontrol et
git status

# Eğer dosyalar varsa ama commit edilmemişse:
git add .
git commit -m "Initial commit"
git push -u origin main
```

---

## ✅ Başarı Kontrolü

Push başarılı olduysa:
- GitHub'da repo'nu aç
- Tüm dosyaların göründüğünü kontrol et
- Artık Vercel'e deploy edebilirsin!

