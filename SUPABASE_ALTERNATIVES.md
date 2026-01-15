# Supabase Alternatifleri - Supabase Olmadan Nasıl Yapılır?

## Supabase Ne İşe Yarar?

BandBuddy projesinde Supabase şu amaçlar için kullanılıyor:

### 1. **Authentication (Kimlik Doğrulama)**
- Kullanıcı kayıt (signup)
- Kullanıcı giriş (login)
- Oturum yönetimi (session management)
- Şifre hash'leme ve güvenlik

### 2. **Database (Veritabanı)**
- PostgreSQL veritabanı
- Essays, evaluations, reading sessions, questions, progress, mistakes verilerini saklama
- İlişkisel veri yapısı (foreign keys)

### 3. **Row Level Security (RLS)**
- Her kullanıcının sadece kendi verilerine erişebilmesi
- Güvenlik politikaları

## Supabase Şart mı?

**HAYIR!** Supabase şart değil. Alternatifler var:

---

## Alternatif 1: SQLite + NextAuth.js (EN BASİT)

### Avantajları:
- ✅ Ücretsiz
- ✅ Kurulumu kolay
- ✅ Dosya tabanlı (sunucu gerekmez)
- ✅ Hızlı geliştirme

### Kurulum:

```bash
npm install next-auth @auth/prisma-adapter prisma @prisma/client
npm install bcryptjs
npm install -D @types/bcryptjs
```

### Adımlar:

1. **Prisma Setup:**
```bash
npx prisma init --datasource-provider sqlite
```

2. **Prisma Schema (`prisma/schema.prisma`):**
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = "file:./dev.db"
}

model User {
  id            String    @id @default(cuid())
  email         String    @unique
  password      String
  name          String?
  emailVerified DateTime?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  
  essays            Essay[]
  readingSessions   ReadingSession[]
  userProgress      UserProgress[]
  mistakeLogs       MistakeLog[]
}

model Essay {
  id            String   @id @default(cuid())
  userId        String
  user          User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  title         String?
  content       String
  wordCount     Int
  paragraphCount Int
  examType      String
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt
  
  evaluations   EssayEvaluation[]
}

model EssayEvaluation {
  id                String   @id @default(cuid())
  essayId           String
  essay             Essay    @relation(fields: [essayId], references: [id], onDelete: Cascade)
  overallBand       Float
  taskResponse      Float
  coherenceCohesion Float
  lexicalResource   Float
  grammaticalRange  Float
  feedback          String
  suggestions       String?  // JSON string
  createdAt         DateTime @default(now())
}

model ReadingSession {
  id              String   @id @default(cuid())
  userId          String
  user            User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  passageTitle    String
  passageContent  String
  difficultyLevel String?
  examType        String
  startedAt       DateTime @default(now())
  completedAt     DateTime?
  totalQuestions  Int      @default(0)
  correctAnswers  Int      @default(0)
  totalTimeSeconds Int?
  
  questions       ReadingQuestion[]
}

model ReadingQuestion {
  id              String   @id @default(cuid())
  sessionId       String
  session         ReadingSession @relation(fields: [sessionId], references: [id], onDelete: Cascade)
  questionType    String
  questionText    String
  options         String?  // JSON string
  correctAnswer   String
  userAnswer      String?
  isCorrect       Boolean?
  timeSpentSeconds Int?
  confidenceLevel Int?
  createdAt       DateTime @default(now())
}

model UserProgress {
  id                        String   @id @default(cuid())
  userId                    String
  user                      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  date                      DateTime @default(now())
  examType                  String
  avgEssayBand              Float?
  avgReadingAccuracy        Float?
  avgReadingTimePerQuestion Int?
  essaysCount               Int      @default(0)
  readingSessionsCount      Int      @default(0)
  createdAt                 DateTime @default(now())
  
  @@unique([userId, date, examType])
}

model MistakeLog {
  id            String   @id @default(cuid())
  userId        String
  user          User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  mistakeType   String
  mistakeCategory String
  context       String?
  examType      String
  createdAt     DateTime @default(now())
}
```

3. **Database oluştur:**
```bash
npx prisma migrate dev --name init
npx prisma generate
```

4. **NextAuth.js Setup (`app/api/auth/[...nextauth]/route.ts`):**
```typescript
import NextAuth from 'next-auth'
import CredentialsProvider from 'next-auth/providers/credentials'
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        const user = await prisma.user.findUnique({
          where: { email: credentials.email }
        })

        if (!user) return null

        const isValid = await bcrypt.compare(credentials.password, user.password)
        if (!isValid) return null

        return {
          id: user.id,
          email: user.email,
          name: user.name,
        }
      }
    })
  ],
  pages: {
    signIn: '/login',
  },
  callbacks: {
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.sub as string
      }
      return session
    },
  },
}

export default NextAuth(authOptions)
```

5. **Auth API Route:**
```typescript
// app/api/auth/[...nextauth]/route.ts
import NextAuth from 'next-auth'
import { authOptions } from './authOptions'

const handler = NextAuth(authOptions)
export { handler as GET, handler as POST }
```

6. **Signup API (`app/api/auth/signup/route.ts`):**
```typescript
import { NextRequest, NextResponse } from 'next/server'
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

export async function POST(request: NextRequest) {
  try {
    const { email, password, name } = await request.json()

    if (!email || !password) {
      return NextResponse.json({ error: 'Email and password required' }, { status: 400 })
    }

    const existingUser = await prisma.user.findUnique({
      where: { email }
    })

    if (existingUser) {
      return NextResponse.json({ error: 'User already exists' }, { status: 400 })
    }

    const hashedPassword = await bcrypt.hash(password, 10)

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        name: name || null,
      }
    })

    return NextResponse.json({ 
      user: { id: user.id, email: user.email, name: user.name } 
    })
  } catch (error) {
    console.error('Signup error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
```

---

## Alternatif 2: MongoDB + NextAuth.js

### Avantajları:
- ✅ JSON tabanlı (esnek yapı)
- ✅ Ücretsiz tier (MongoDB Atlas)
- ✅ Kolay ölçeklenebilir

### Kurulum:

```bash
npm install next-auth mongodb mongoose bcryptjs
```

### Schema Örneği:
```typescript
// models/User.ts
import mongoose from 'mongoose'

const UserSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: String,
  createdAt: { type: Date, default: Date.now }
})

export default mongoose.models.User || mongoose.model('User', UserSchema)
```

---

## Alternatif 3: PostgreSQL (Direct) + NextAuth.js

### Avantajları:
- ✅ Supabase ile aynı veritabanı
- ✅ Daha fazla kontrol
- ✅ Kendi sunucunuzda çalıştırabilirsiniz

### Kurulum:

```bash
npm install pg @types/pg next-auth bcryptjs
```

### Connection:
```typescript
// lib/db.ts
import { Pool } from 'pg'

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
})
```

---

## Alternatif 4: Firebase (Google)

### Avantajları:
- ✅ Authentication built-in
- ✅ Firestore database
- ✅ Ücretsiz tier

### Kurulum:

```bash
npm install firebase next-auth
```

---

## Alternatif 5: Clerk (En Kolay Auth)

### Avantajları:
- ✅ Çok kolay setup
- ✅ UI bile hazır
- ✅ Ücretsiz tier var

### Kurulum:

```bash
npm install @clerk/nextjs
```

---

## Hangi Alternatifi Seçmeliyim?

| Özellik | SQLite + NextAuth | MongoDB + NextAuth | PostgreSQL + NextAuth | Firebase | Clerk |
|---------|-------------------|-------------------|---------------------|----------|-------|
| **Kurulum Zorluğu** | ⭐⭐⭐ Kolay | ⭐⭐ Orta | ⭐⭐ Orta | ⭐⭐⭐ Kolay | ⭐⭐⭐ Çok Kolay |
| **Maliyet** | ✅ Ücretsiz | ✅ Ücretsiz tier | ✅ Ücretsiz | ✅ Ücretsiz tier | ✅ Ücretsiz tier |
| **Geliştirme Hızı** | ⭐⭐⭐ Hızlı | ⭐⭐ Orta | ⭐⭐ Orta | ⭐⭐⭐ Hızlı | ⭐⭐⭐ Çok Hızlı |
| **Production Ready** | ⚠️ Küçük projeler | ✅✅✅ | ✅✅✅ | ✅✅✅ | ✅✅✅ |
| **Ölçeklenebilirlik** | ⚠️ Sınırlı | ✅✅✅ | ✅✅✅ | ✅✅✅ | ✅✅✅ |

### Öneri:
- **Hızlı prototip için:** SQLite + NextAuth.js
- **Production için:** MongoDB Atlas + NextAuth.js veya PostgreSQL + NextAuth.js
- **En kolay auth için:** Clerk

---

## Supabase'den Alternatife Geçiş Adımları

1. **Yeni database/Auth çözümünü kur**
2. **Migration script'i çalıştır** (verileri aktar)
3. **Supabase import'larını değiştir:**
   - `supabase/client.ts` → Yeni auth client
   - `supabase/server.ts` → Yeni database client
4. **API route'larını güncelle**
5. **Auth middleware'i güncelle**

---

## Özet

**Supabase şart değil!** Aşağıdaki alternatifler kullanılabilir:

1. ✅ **SQLite + NextAuth.js** - En basit, ücretsiz
2. ✅ **MongoDB + NextAuth.js** - Esnek, ücretsiz tier
3. ✅ **PostgreSQL + NextAuth.js** - Supabase ile aynı DB
4. ✅ **Firebase** - Google'ın çözümü
5. ✅ **Clerk** - En kolay auth

**Tavsiye:** Hızlı başlamak için SQLite + NextAuth.js, production için MongoDB Atlas + NextAuth.js kullanın.

