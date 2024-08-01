const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./routes/auth');
const pokemonRoutes = require('./routes/pokemon');
const abilityRoutes = require('./routes/ability');
const typeRoutes = require('./routes/type');
const pokemonAbilityRoutes = require('./routes/pokemonAbility');
const pokemonImageRoutes = require('./routes/pokemonImages');

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/pokemon', pokemonRoutes);
app.use('/api/ability', abilityRoutes);
app.use('/api/type', typeRoutes);
app.use('/api/pokemon_ability', pokemonAbilityRoutes);
app.use('/api/pokemon_image', pokemonImageRoutes);

const PORT = process.env.PORT || 8080;

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));