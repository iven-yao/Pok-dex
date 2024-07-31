const { POKEAPI_BASE_URI } = require("../utils/constants");
const { getAbilityDescription } = require("../utils/pokemonDataUtils");
const { fetchWithRetry } = require("../utils/axiosUtils");

const seedAbility = async (client, multibar) => {
    try {
        const response = await fetchWithRetry(`${POKEAPI_BASE_URI}/ability?limit=${process.env.ABILITY_LIMIT || 1000}`);
        const abilities = response.data.results;
        const bar = multibar.create(abilities.length, 0,{filename: "seedAbility"});

        for(const ability of abilities) {
            const detailResponse = await fetchWithRetry(ability.url);
            const abilityData = {
                id: detailResponse.data.id,
                name: detailResponse.data.name,
                description: getAbilityDescription(detailResponse.data.flavor_text_entries)
            };

            const {id, name, description} = abilityData;
            await client.query(
                '\
                INSERT INTO abilities (id, name, description) \
                VALUES ($1, $2, $3) \
                ON CONFLICT (id) DO NOTHING',
                [id, name, description]
            );

            bar.increment();
        }
        
    } catch (err) {
        console.error(err.message);
        throw err;
    }
}

module.exports = {seedAbility}