#!/bin/bash

echo "🚀 GitHub'a Push Etme - Hazır!"
echo "================================"
echo ""
echo "✅ Git repo başlatıldı"
echo "✅ Dosyalar eklendi"
echo "✅ Commit yapıldı"
echo ""
echo "📝 Şimdi yapman gerekenler:"
echo ""
echo "1. GitHub'da yeni repo oluştur:"
echo "   https://github.com → '+' → New repository"
echo "   Repo adı: bandbuddy (veya istediğin isim)"
echo "   Boş repo oluştur (README, .gitignore ekleme)"
echo ""
echo "2. GitHub kullanıcı adını ve repo adını yaz:"
read -p "GitHub kullanıcı adın: " GITHUB_USER
read -p "Repo adı: " REPO_NAME
echo ""
echo "3. Remote ekleniyor..."
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
echo ""
echo "4. GitHub'a push ediliyor..."
git push -u origin main
echo ""
echo "✅ Tamamlandı!"
echo ""
echo "Artık Vercel'e deploy edebilirsin:"
echo "https://vercel.com → New Project → Repo seç"

