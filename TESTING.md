# BandBuddy Testing Checklist

## Pre-Testing Setup Checklist

- [ ] Supabase project created and configured
- [ ] Database migration executed successfully
- [ ] Environment variables set in `.env.local`
- [ ] Gemini API key obtained and configured
- [ ] Development server running (`npm run dev`)
- [ ] No build errors (`npm run build` succeeds)

## Feature Testing Checklist

### Authentication
- [ ] User can sign up with valid email and password
- [ ] User cannot sign up with invalid email
- [ ] User cannot sign up with password < 6 characters
- [ ] User can log in with correct credentials
- [ ] User cannot log in with wrong credentials
- [ ] Protected routes redirect to login when not authenticated
- [ ] User can log out successfully
- [ ] Session persists across page refreshes

### Writing Module
- [ ] Essay submission form displays correctly
- [ ] Word count updates as user types
- [ ] Paragraph count calculates correctly
- [ ] Essay validation (minimum 100 words) works
- [ ] Essay submission saves to database
- [ ] AI evaluation triggers after submission
- [ ] Evaluation results display all scores (overall + 4 sub-scores)
- [ ] Feedback panel shows detailed feedback
- [ ] Suggestions list displays correctly
- [ ] Essay content displays on results page
- [ ] Results page loads even if evaluation is processing

### Reading Module
- [ ] Reading practice page loads
- [ ] Passage generation works (may take 10-30 seconds)
- [ ] Passage displays correctly
- [ ] All question types display:
  - [ ] Multiple choice
  - [ ] True/False/Not Given
  - [ ] Matching headings
  - [ ] Short answer
- [ ] Answer selection works for all question types
- [ ] Navigation between questions works (Previous/Next)
- [ ] Progress tracker updates correctly
- [ ] Answer submission saves results
- [ ] Results page shows score and accuracy
- [ ] New practice session can be started

### Dashboard
- [ ] Dashboard loads for authenticated users
- [ ] All charts display:
  - [ ] Essay Band Progress Chart
  - [ ] Reading Accuracy Chart
  - [ ] Reading Timing Chart
  - [ ] Mistake Types Chart
- [ ] Charts show data when available
- [ ] Charts show empty state when no data
- [ ] Exam type filter works (IELTS/TOEFL)
- [ ] Recommendations panel displays tips
- [ ] Recommendations update based on performance

### Error Handling
- [ ] API errors display user-friendly messages
- [ ] Network errors are handled gracefully
- [ ] Invalid data shows appropriate errors
- [ ] 404 pages work correctly
- [ ] Unauthorized access is blocked

### Performance
- [ ] Page load times are acceptable (< 2 seconds)
- [ ] AI evaluation completes within 30 seconds
- [ ] Reading generation completes within 30 seconds
- [ ] Dashboard loads quickly
- [ ] No memory leaks during extended use

### Browser Compatibility
- [ ] Chrome/Edge (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Mobile browsers (iOS Safari, Chrome Mobile)

## Database Testing

- [ ] Essays are saved correctly
- [ ] Essay evaluations are saved correctly
- [ ] Reading sessions are saved correctly
- [ ] Reading questions are saved correctly
- [ ] User progress is calculated correctly
- [ ] Mistake logs are created on wrong answers
- [ ] RLS policies prevent unauthorized access
- [ ] Data is isolated per user

## API Testing

Test each API endpoint:

### Writing APIs
- [ ] `POST /api/writing/submit` - Submits essay
- [ ] `POST /api/writing/evaluate` - Evaluates essay with AI

### Reading APIs
- [ ] `POST /api/reading/generate` - Generates passage and questions
- [ ] `GET /api/reading/session/[sessionId]` - Gets session data
- [ ] `POST /api/reading/submit` - Submits answers

### Dashboard APIs
- [ ] `GET /api/dashboard/progress` - Gets progress data
- [ ] `GET /api/dashboard/recommendations` - Gets recommendations

### Auth API
- [ ] `GET /api/auth/[...supabase]` - Handles OAuth callbacks

## Security Testing

- [ ] Users cannot access other users' data
- [ ] SQL injection attempts are blocked
- [ ] XSS attacks are prevented
- [ ] API keys are not exposed in client-side code
- [ ] Authentication tokens are secure
- [ ] RLS policies are enforced

## Edge Cases

- [ ] Very long essays (> 5000 words)
- [ ] Very short essays (< 100 words)
- [ ] Empty essay content
- [ ] Special characters in essay content
- [ ] Multiple submissions in quick succession
- [ ] Reading session with no questions
- [ ] Dashboard with no data
- [ ] Very fast answer submissions
- [ ] Network interruption during evaluation

## User Experience

- [ ] Loading states are shown during async operations
- [ ] Error messages are clear and actionable
- [ ] Success messages confirm actions
- [ ] Navigation is intuitive
- [ ] Forms are responsive and accessible
- [ ] Charts are readable and informative
- [ ] Mobile experience is functional

## Deployment Testing

- [ ] Build succeeds without errors
- [ ] All environment variables are set in production
- [ ] Database migrations run in production
- [ ] Production build works correctly
- [ ] Vercel deployment succeeds
- [ ] Production URLs work correctly

---

## Quick Test Script

Run this quick test sequence:

1. **Start server**: `npm run dev`
2. **Sign up**: Create a new account
3. **Write essay**: Submit a test essay (200+ words)
4. **Check results**: View evaluation results
5. **Reading practice**: Start a reading session
6. **Submit answers**: Complete all questions
7. **View dashboard**: Check progress and charts
8. **Logout**: Sign out and verify redirect

All steps should complete without errors!

