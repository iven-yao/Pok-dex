-- Create Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    refresh_token VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create Pokemons table
CREATE TABLE IF NOT EXISTS pokemons (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type_1 VARCHAR(20),
    type_2 VARCHAR(20),
    height INTEGER,
    weight INTEGER,
    hp INTEGER,
    attack INTEGER,
    defense INTEGER,
    special_attack INTEGER,
    special_defense INTEGER,
    speed INTEGER,
    image_url VARCHAR(255)
);

-- Create Abilities table
CREATE TABLE IF NOT EXISTS abilities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL
);

-- Create Pokemons-Abilities Relational table
CREATE TABLE IF NOT EXISTS pokemon_ability (
    id SERIAL PRIMARY KEY,
    pokemon_id INTEGER,
    ability_id INTEGER,
    is_hidden BOOLEAN
);

-- Create Types table
CREATE TABLE IF NOT EXISTS types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

-- Create Pokemon_Images table
CREATE TABLE IF NOT EXISTS pokemon_images (
    id SERIAL PRIMARY KEY,
    pokemon_id INTEGER,
    description VARCHAR(50),
    image_url VARCHAR(255)
);

-- Create Likes table
CREATE TABLE IF NOT EXISTS likes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    pokemon_id INTEGER REFERENCES pokemons(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, pokemon_id)
);

-- Create Comments table
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    pokemon_id INTEGER REFERENCES pokemons(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_pokemon_name ON pokemons(name);
CREATE INDEX IF NOT EXISTS idx_pokemon_type ON pokemons(type_1, type_2);
CREATE INDEX IF NOT EXISTS idx_likes_user_id ON likes(user_id);
CREATE INDEX IF NOT EXISTS idx_likes_pokemon_id ON likes(pokemon_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_pokemon_id ON comments(pokemon_id);
CREATE INDEX IF NOT EXISTS idx_ability_name ON abilities(name);
CREATE INDEX IF NOT EXISTS idx_type_name ON types(name);
CREATE UNIQUE INDEX IF NOT EXISTS uq_pm_ab_pm_id_ab_id ON pokemon_ability(pokemon_id, ability_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_pm_img_pm_id_desc ON pokemon_images(pokemon_id, description);