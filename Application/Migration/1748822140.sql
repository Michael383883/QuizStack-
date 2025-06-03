CREATE TABLE questions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    question TEXT NOT NULL,
    difficulty_level INT NOT NULL,
    difficulty_name TEXT NOT NULL,
    status TEXT DEFAULT 'draft' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);
CREATE INDEX idx_questions_difficulty ON questions (difficulty_level);
CREATE INDEX idx_questions_status ON questions (status);
CREATE INDEX idx_questions_created_at ON questions (created_at);
