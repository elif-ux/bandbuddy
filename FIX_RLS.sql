-- Sadece eksik olan INSERT policy'yi ekle
-- Diğer policy'ler zaten var, onları tekrar oluşturma

-- Drop policy if it exists (to avoid errors if running multiple times)
DROP POLICY IF EXISTS "Users can insert their own essay evaluations" ON essay_evaluations;

-- Create the INSERT policy
CREATE POLICY "Users can insert their own essay evaluations" ON essay_evaluations
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM essays WHERE essays.id = essay_evaluations.essay_id AND essays.user_id = auth.uid()
  ));

