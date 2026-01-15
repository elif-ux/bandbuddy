# 🔐 GitHub Authentication - Adım Adım

## Yöntem 1: Personal Access Token (Önerilen - En Kolay)

### Adım 1: GitHub'da Token Oluştur

1. **https://github.com** → Login ol
2. Sağ üstte **profil resmin** → **Settings**
3. Sol menüden **Developer settings** (en altta)
4. **Personal access tokens** → **Tokens (classic)**
5. **"Generate new token"** → **"Generate new token (classic)"**
6. Token ayarları:
   - **Note:** `bandbuddy-deploy` (veya istediğin isim)
   - **Expiration:** `90 days` (veya istediğin süre)
   - **Scopes:** `repo` seç (tüm repo izinleri)
     - ✅ repo (Full control of private repositories)
7. **"Generate token"** butonuna tıkla
8. **Token'ı kopyala** (bir daha gösterilmeyecek!)
   - Örnek: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Adım 2: Token'ı Git'e Kaydet

Terminal'de şu komutu çalıştır (token'ı yapıştır):

```bash
# Token'ı GitHub'a kaydet
git config --global credential.helper store
```

Sonra push yaparken:
- **Username:** GitHub kullanıcı adın (tdemir97)
- **Password:** Token (ghp_xxxxxxxxxxxx)

---

## Yöntem 2: GitHub CLI ile (Daha Kolay)

```bash
# GitHub CLI yükle (eğer yoksa)
brew install gh

# Login ol
gh auth login

# Seçenekler:
# - GitHub.com
# - HTTPS
# - Login with a web browser
# - Browser'da açılacak, authorize et
```

---

## Yöntem 3: SSH Key (Kalıcı Çözüm)

### Adım 1: SSH Key Oluştur

```bash
# SSH key oluştur
ssh-keygen -t ed25519 -C "your_email@example.com"

# Enter'a bas (default dosya)
# Passphrase isteğe bağlı (boş bırakabilirsin)
```

### Adım 2: SSH Key'i GitHub'a Ekle

```bash
# Public key'i kopyala
cat ~/.ssh/id_ed25519.pub
```

1. GitHub → Settings → SSH and GPG keys
2. "New SSH key"
3. Title: `MacBook` (veya istediğin isim)
4. Key: Kopyaladığın public key'i yapıştır
5. "Add SSH key"

### Adım 3: Remote'u SSH URL'e Çevir

```bash
git remote set-url origin git@github.com:tdemir97/bandbuddy.git
```

---

## ✅ Hızlı Test

Token aldıktan sonra:

```bash
cd /Users/tunademir/Desktop/Cursor/CEIT
git push -u origin main
```

**Username:** `tdemir97`  
**Password:** Token'ı yapıştır

---

## 🎯 En Kolay Yol: GitHub CLI

Eğer macOS kullanıyorsan (Homebrew varsa):

```bash
brew install gh
gh auth login
```

Sonra push yap:

```bash
git push -u origin main
```

Artık authentication gerekmez! 🎉

