-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE processed_maps (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    original_file_name TEXT NOT NULL,
    map_type TEXT NOT NULL,
    processed_image_data TEXT NOT NULL,
    countries_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
-- Ejemplo de tabla para la API
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);


-- Tabla de preguntas para nuestro API
CREATE TABLE questions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    question TEXT NOT NULL, 
    image TEXT,             
    difficulty TEXT,        
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

CREATE TABLE map_configs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    cell_size INTEGER NOT NULL,
    start_pos_x INTEGER NOT NULL,
    start_pos_y INTEGER NOT NULL,
    goal_pos_x INTEGER NOT NULL,
    goal_pos_y INTEGER NOT NULL,
    config_data JSONB NOT NULL, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);