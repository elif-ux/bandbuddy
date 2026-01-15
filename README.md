# BandBuddy - IELTS/TOEFL Preparation Platform

A personalized online platform combining AI-driven assessment, adaptive practice, and motivational tracking for IELTS/TOEFL exam preparation.

## Features

### Writing Module
- Submit IELTS/TOEFL-style essays via text input
- AI-powered evaluation with overall band score and sub-scores (Task Response, Coherence & Cohesion, Lexical Resource, Grammatical Range & Accuracy)
- Personalized feedback and improvement suggestions aligned with official rubrics
- Word count and paragraph analysis

### Reading Module
- Dynamically generated reading passages based on user weaknesses
- Adaptive question types: multiple-choice, True/False/Not Given, matching headings, and short answers
- Performance tracking: accuracy, time per question, and confidence levels
- Adaptive difficulty adjustment

### Dashboard
- Progress visualization with charts:
  - Essay band improvement over time
  - Reading accuracy and timing trends
  - Most frequent mistake types
- Personalized recommendations based on performance

## Technology Stack

- **Frontend**: Next.js 14+ with TypeScript, TailwindCSS
- **Backend**: Next.js API routes
- **Database & Auth**: Supabase (PostgreSQL)
- **AI Integration**: Google Gemini API
- **Data Visualization**: Recharts
- **Validation**: Zod
- **Deployment**: Vercel

## Setup Instructions

### Prerequisites

- Node.js 18+ and npm
- Supabase account
- Google Gemini API key

### Installation

1. Clone the repository and install dependencies:
```bash
npm install
```

2. Set up environment variables:
   - Copy `.env.local.example` to `.env.local`
   - Fill in your Supabase credentials:
     - `NEXT_PUBLIC_SUPABASE_URL` - Your Supabase project URL
     - `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Your Supabase anonymous key
     - `SUPABASE_SERVICE_ROLE_KEY` - Your Supabase service role key (for server-side operations)
   - Add your Gemini API key:
     - `GEMINI_API_KEY` - Your Google Gemini API key

3. Set up the database:
   - Open your Supabase dashboard
   - Go to SQL Editor
   - Run the migration file: `supabase/migrations/001_initial_schema.sql`
   - This will create all necessary tables and Row Level Security policies

4. Run the development server:
```bash
npm run dev
```

5. Open [http://localhost:3000](http://localhost:3000) in your browser.

## Deployment to Vercel

1. Push your code to a Git repository (GitHub, GitLab, or Bitbucket)

2. Import your project in Vercel:
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your Git repository

3. Configure environment variables in Vercel:
   - Add all the environment variables from `.env.local`
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `GEMINI_API_KEY`

4. Deploy:
   - Vercel will automatically detect Next.js and deploy
   - The project will build and deploy automatically

## Project Structure

```
/
├── app/                    # Next.js app directory
│   ├── (auth)/            # Authentication pages
│   ├── api/               # API routes
│   ├── dashboard/         # Dashboard page
│   ├── reading/           # Reading module pages
│   ├── writing/           # Writing module pages
│   └── layout.tsx         # Root layout
├── components/            # React components
│   ├── dashboard/         # Dashboard components
│   ├── layout/            # Layout components
│   ├── reading/           # Reading components
│   └── writing/           # Writing components
├── lib/                   # Utility functions
│   ├── adaptation.ts      # Adaptive difficulty logic
│   ├── gemini.ts          # Gemini API client
│   ├── metrics.ts         # Essay metrics calculation
│   ├── rubrics.ts         # IELTS/TOEFL rubrics
│   └── validators.ts      # Zod schemas
├── supabase/              # Supabase configuration
│   ├── client.ts          # Browser client
│   ├── server.ts          # Server client
│   └── migrations/        # Database migrations
└── middleware.ts          # Route protection middleware
```

## Database Schema

The application uses the following main tables:

- `essays` - Stores submitted essays
- `essay_evaluations` - Stores AI-generated scores and feedback
- `reading_sessions` - Tracks reading practice sessions
- `reading_questions` - Stores generated questions and answers
- `user_progress` - Aggregated progress data for dashboard
- `mistake_logs` - Tracks frequent error types

All tables have Row Level Security (RLS) enabled to ensure users can only access their own data.

## API Routes

- `/api/writing/submit` - Submit essay for evaluation
- `/api/writing/evaluate` - Generate AI evaluation
- `/api/reading/generate` - Generate reading passage and questions
- `/api/reading/submit` - Submit reading answers
- `/api/reading/session/[sessionId]` - Get reading session data
- `/api/dashboard/progress` - Get user progress data
- `/api/dashboard/recommendations` - Get personalized recommendations

## Testing Guide

### Prerequisites for Testing

1. **Supabase Setup**:
   - Create a Supabase account at [supabase.com](https://supabase.com)
   - Create a new project
   - Go to Project Settings > API
   - Copy your Project URL and anon/public key
   - Copy your service_role key (keep this secret!)

2. **Database Migration**:
   - In Supabase dashboard, go to SQL Editor
   - Copy and paste the contents of `supabase/migrations/001_initial_schema.sql`
   - Click "Run" to execute the migration
   - Verify tables are created in the Table Editor

3. **Gemini API Key**:
   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create an API key
   - Copy the key to `.env.local`

4. **Environment Variables**:
   ```bash
   cp .env.local.example .env.local
   # Edit .env.local with your actual values
   ```

### Manual Testing Steps

#### 1. Authentication Testing

**Test Sign Up:**
1. Navigate to `http://localhost:3000/signup`
2. Enter a valid email and password (min 6 characters)
3. Click "Sign Up"
4. Should redirect to dashboard or show success message

**Test Login:**
1. Navigate to `http://localhost:3000/login`
2. Enter your credentials
3. Should redirect to dashboard
4. Verify navbar shows user is logged in

**Test Protected Routes:**
1. Try accessing `/dashboard`, `/writing`, or `/reading` without logging in
2. Should redirect to `/login`
3. After login, should access these pages

**Test Logout:**
1. Click "Sign Out" in navbar
2. Should redirect to home page
3. Should not be able to access protected routes

#### 2. Writing Module Testing

**Test Essay Submission:**
1. Navigate to `/writing`
2. Select exam type (IELTS or TOEFL)
3. Enter essay title (optional)
4. Type or paste essay content (minimum 100 words)
5. Verify word count and paragraph count display correctly
6. Click "Submit Essay"
7. Should redirect to results page

**Test Essay Evaluation:**
1. After submission, wait for evaluation (may take 10-30 seconds)
2. Refresh the results page if evaluation is still processing
3. Verify:
   - Overall band score displays (0-9)
   - All 4 sub-scores display (Task Response, Coherence, Lexical, Grammar)
   - Detailed feedback is shown
   - Improvement suggestions are listed
   - Essay content is displayed at bottom

**Test Validation:**
1. Try submitting essay with less than 100 words
2. Should show error message
3. Try submitting with empty content
4. Should show validation error

#### 3. Reading Module Testing

**Test Reading Passage Generation:**
1. Navigate to `/reading`
2. Select exam type (IELTS or TOEFL)
3. Click "Start Reading Practice"
4. Wait for passage to generate (may take 10-30 seconds)
5. Verify passage is displayed
6. Verify questions are displayed below passage

**Test Question Types:**
1. Answer multiple-choice questions
2. Answer True/False/Not Given questions
3. Answer matching headings questions
4. Answer short answer questions
5. Verify you can navigate between questions (Previous/Next)
6. Verify progress tracker updates

**Test Answer Submission:**
1. Answer all questions
2. Click "Submit Answers"
3. Verify results page shows:
   - Score (correct/total)
   - Accuracy percentage
   - Time spent
4. Click "Start New Practice" to generate another passage

**Test Session Persistence:**
1. Start a reading session
2. Navigate away and come back using the session URL
3. Verify session is saved and can be resumed

#### 4. Dashboard Testing

**Test Dashboard Display:**
1. Navigate to `/dashboard`
2. Verify all charts are displayed:
   - Essay Band Progress Chart
   - Reading Accuracy Trends Chart
   - Reading Timing Trends Chart
   - Mistake Types Chart
3. Verify recommendations panel shows personalized tips

**Test Exam Type Filter:**
1. Switch between IELTS and TOEFL
2. Verify data updates for each exam type
3. Verify charts reflect the selected exam type

**Test Progress Tracking:**
1. Submit multiple essays
2. Complete multiple reading sessions
3. Return to dashboard
4. Verify:
   - Band scores appear in the progress chart
   - Reading accuracy trends are shown
   - Mistake types are aggregated
   - Recommendations update based on performance

#### 5. Error Handling Testing

**Test API Errors:**
1. Disable Gemini API key temporarily
2. Try submitting an essay
3. Should show appropriate error message
4. Try generating reading passage
5. Should show error message

**Test Network Errors:**
1. Disconnect from internet
2. Try submitting essay
3. Should show error message
4. Reconnect and retry

**Test Invalid Data:**
1. Try accessing invalid essay ID
2. Should redirect or show error
3. Try accessing invalid reading session ID
4. Should redirect to reading page

### Automated Testing (Optional)

To add automated tests, install testing dependencies:

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom jest jest-environment-jsdom
```

Create `jest.config.js`:
```javascript
const nextJest = require('next/jest')

const createJestConfig = nextJest({
  dir: './',
})

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
}

module.exports = createJestConfig(createJestConfig)
```

### Performance Testing

**Test Loading Times:**
1. Check essay evaluation time (should be < 30 seconds)
2. Check reading passage generation time (should be < 30 seconds)
3. Check dashboard load time (should be < 2 seconds)

**Test Concurrent Users:**
1. Open multiple browser tabs
2. Test with different user accounts
3. Verify data isolation (users only see their own data)

### Browser Testing

Test on:
- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

### Known Limitations

1. **AI Response Time**: Gemini API may take 10-30 seconds for evaluation/generation
2. **Rate Limits**: Gemini API has rate limits - if exceeded, wait before retrying
3. **Browser Compatibility**: Requires modern browser with JavaScript enabled
4. **Session Storage**: Reading sessions are saved in database, not local storage

### Troubleshooting

**Issue: "Failed to evaluate essay"**
- Check Gemini API key is correct
- Check API quota hasn't been exceeded
- Verify internet connection
- Check browser console for errors

**Issue: "Unauthorized" errors**
- Verify Supabase credentials in `.env.local`
- Check Supabase project is active
- Verify RLS policies are set up correctly

**Issue: Charts not displaying**
- Check browser console for errors
- Verify Recharts is installed
- Check data exists in database

**Issue: Database errors**
- Verify migration was run successfully
- Check Supabase project is active
- Verify RLS policies allow user access

## Contributing

This is a project implementation. For modifications or improvements:

1. Create a new branch for your changes
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

This project is for educational purposes.

