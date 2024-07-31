const { POKEAPI_BASE_URL } = require("../utils/constants");
const { getAbilityDescription } = require("../utils/pokemonDataUtils");
const { fetchWithRetry } = require("../utils/axiosUtils");
const Ability = require("../models/Ability");

const seedAbility = async (client, multibar) => {

    
    
    try {
        const response = await fetchWithRetry(`${POKEAPI_BASE_URL}/ability?limit=${process.env.ABILITY_LIMIT || 1000}`);
        const abilities = response.data.results;
        const bar = multibar.create(abilities.length, 0,{filename: "seedAbility"});

        const batchSize = 50;
        for (let i = 0; i < abilities.length; i += batchSize) {
            const batch = abilities.slice(i, i + batchSize);
            const abilityDetails = await Promise.all(batch.map(ability => fetchWithRetry(ability.url)));

            const abilityData = abilityDetails.map(detailResponse => ({
                id: detailResponse.data.id,
                name: detailResponse.data.name,
                description: getAbilityDescription(detailResponse.data.flavor_text_entries)
            }));
            
            await Ability.createInBatch(client, abilityData);

            bar.increment(batch.length);
        }
        
    } catch (err) {
        console.error(err.message);
        throw err;
    }
}

module.exports = {seedAbility}