# Pok-dex
pokedex flutter app

## Run locally
in `./pokedex-backend` directory
- use Docker & Node >= 14
- create an .env file, please refer to .env.example for guidance
- run `npm i`
- run `docker compose up --build`, to start server and db
- run `npm run seed`, to seed the PokeAPI data in db, (by default will load, 18 types, 307 abilities, 1025 pokemons, pokemon_ability relations, and some images of pokemons)

and now you are ready to test on the flutter end

in `./pokedexapp` directory
- run `flutter pub get`
- run `flutter run .\lib\main.dart`

## Notes
- I'm using Android emulator for testing (Pixel 8 API 34)
- on first load, app will make api calls to get types, abilities, pokemons, relations, and images data. app will store all these data in local SQLite database, and rely on this database for all the following functions (offline)
- currently using local backend, in Android emulator, we need to use http://10.0.2.2 instead of http://localhost, which is currently hardcoded in the app (need to be fixed)
- by default, the app will only fetch the data again if last fetch time has past 24 hrs, or the app lost the track of the time (most likely because the whole database is deleted)
