ALTER TABLE questions DROP COLUMN difficulty_level;
ALTER TABLE questions DROP COLUMN difficulty_name;
ALTER TABLE questions DROP COLUMN status;
ALTER TABLE questions ADD COLUMN image TEXT DEFAULT null;
ALTER TABLE questions ADD COLUMN difficulty TEXT DEFAULT null;
