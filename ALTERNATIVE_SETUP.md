# Supabase Alternatifi: SQLite + NextAuth.js Kurulum Rehberi

Bu rehber, Supabase yerine SQLite + NextAuth.js kullanarak BandBuddy'yi çalıştırmak için adım adım talimatlar içerir.

## 1. Gerekli Paketleri Yükleyin

```bash
npm install next-auth @prisma/client prisma bcryptjs
npm install -D @types/bcryptjs
```

## 2. Prisma Setup

```bash
npx prisma init --datasource-provider sqlite
```

## 3. Prisma Schema Oluşturun

`prisma/schema.prisma` dosyasını oluşturun:

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

## 4. Database Oluşturun

```bash
npx prisma migrate dev --name init
npx prisma generate
```

## 5. Prisma Client'ı Oluşturun

`lib/prisma.ts` dosyası:

```typescript
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

## 6. NextAuth.js Kurulumu

### `app/api/auth/[...nextauth]/route.ts`:

```typescript
import NextAuth, { NextAuthOptions } from 'next-auth'
import CredentialsProvider from 'next-auth/providers/credentials'
import { prisma } from '@/lib/prisma'
import bcrypt from 'bcryptjs'

export const authOptions: NextAuthOptions = {
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
      if (session.user && token.sub) {
        session.user.id = token.sub
      }
      return session
    },
    async jwt({ token, user }) {
      if (user) {
        token.sub = user.id
      }
      return token
    }
  },
  session: {
    strategy: 'jwt',
  },
}

const handler = NextAuth(authOptions)
export { handler as GET, handler as POST }
```

## 7. Signup API Route

### `app/api/auth/signup/route.ts`:

```typescript
import { NextRequest, NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'
import bcrypt from 'bcryptjs'

export async function POST(request: NextRequest) {
  try {
    const { email, password, name } = await request.json()

    if (!email || !password) {
      return NextResponse.json({ error: 'Email and password required' }, { status: 400 })
    }

    if (password.length < 6) {
      return NextResponse.json({ error: 'Password must be at least 6 characters' }, { status: 400 })
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
      },
      select: {
        id: true,
        email: true,
        name: true,
      }
    })

    return NextResponse.json({ user })
  } catch (error) {
    console.error('Signup error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
```

## 8. Environment Variables

`.env.local` dosyasına ekleyin:

```env
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-random-secret-key-here
DATABASE_URL="file:./dev.db"
GEMINI_API_KEY=your_gemini_api_key
```

NEXTAUTH_SECRET oluşturmak için:
```bash
openssl rand -base64 32
```

## 9. Auth Helper Functions

### `lib/auth.ts`:

```typescript
import { getServerSession } from 'next-auth/next'
import { authOptions } from '@/app/api/auth/[...nextauth]/route'

export async function getCurrentUser() {
  const session = await getServerSession(authOptions)
  return session?.user
}

export async function getCurrentUserId() {
  const user = await getCurrentUser()
  return user?.id
}
```

## 10. Login/Signup Sayfalarını Güncelleyin

### Login sayfası (`app/(auth)/login/page.tsx`):

NextAuth.js kullanacak şekilde güncelleyin:

```typescript
'use client'

import { signIn } from 'next-auth/react'
import { useState } from 'react'
// ... rest of the code
```

### Signup sayfası:

API route'u çağıracak şekilde güncelleyin.

## 11. API Route'larını Güncelleyin

Tüm API route'larda Supabase yerine Prisma kullanın:

```typescript
// Örnek: app/api/writing/submit/route.ts
import { prisma } from '@/lib/prisma'
import { getCurrentUserId } from '@/lib/auth'

export async function POST(request: NextRequest) {
  const userId = await getCurrentUserId()
  if (!userId) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // Prisma ile veri kaydetme
  const essay = await prisma.essay.create({
    data: {
      userId,
      content: validated.content,
      // ...
    }
  })
}
```

## 12. Middleware Güncelleme

`middleware.ts` dosyasını NextAuth.js kullanacak şekilde güncelleyin.

## Avantajlar

✅ **Ücretsiz** - SQLite dosya tabanlı, ücretsiz
✅ **Kolay Setup** - Az konfigürasyon
✅ **Hızlı Geliştirme** - Local development için mükemmel
✅ **NextAuth.js** - Güvenli, test edilmiş auth çözümü

## Dezavantajlar

⚠️ **Production için sınırlı** - SQLite production için çok kullanıcılı senaryolarda sınırlı
⚠️ **Ölçeklenebilirlik** - Büyük ölçekli uygulamalar için uygun değil

## Production İçin

Production için MongoDB Atlas veya PostgreSQL kullanın:

```bash
# MongoDB için
npx prisma init --datasource-provider mongodb

# PostgreSQL için
npx prisma init --datasource-provider postgresql
```

Sadece `prisma/schema.prisma` dosyasındaki `datasource` kısmını değiştirin!

