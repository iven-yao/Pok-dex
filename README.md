# Pok-dex
pokedex flutter app

## run locally
in `./pokedex-backend` directory
- use Node > 14
- create an .env file, please refer to .env.example for guidance
- run `npm i`
- run `docker compose up --build`, to start server and db
- run `npm run seed`, to seed the PokeAPI data in db, (by default will load, 18 types, 307 abilities, 1025 pokemons and pokemon_ability relations)

and you are ready to test the mobile app
