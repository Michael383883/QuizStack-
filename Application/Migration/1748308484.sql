CREATE TABLE processed_maps (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    original_file_name TEXT NOT NULL,
    map_type TEXT NOT NULL,
    processed_image_data TEXT NOT NULL,
    countries_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);
