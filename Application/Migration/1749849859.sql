CREATE TABLE map_configs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    width INT NOT NULL,
    height INT NOT NULL,
    cell_size INT NOT NULL,
    start_pos_x INT NOT NULL,
    start_pos_y INT NOT NULL,
    goal_pos_x INT NOT NULL,
    goal_pos_y INT NOT NULL,
    config_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);
