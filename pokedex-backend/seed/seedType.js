const Type = require("../models/PokemonType");
const { fetchWithRetry } = require("../utils/axiosUtils");
const { POKEAPI_BASE_URL } = require("../utils/constants");

const seedType = async (client, multibar) => {

    try {
        const response = await fetchWithRetry(`${POKEAPI_BASE_URL}/type?limit=${process.env.TYPE_LIMIT || 18}`);
        const types = response.data.results;
        const bar = multibar.create(types.length, 0, { filename: "seedType   " });

        const typeDetails = await Promise.all(types.map(type => fetchWithRetry(type.url)));

        const typeData = typeDetails.map(detailResponse => ({
            id: detailResponse.data.id,
            name: detailResponse.data.name,
        }));

        await Type.createInBatch(client, typeData);

        bar.increment(types.length);

    } catch (err) {
        console.error(err.message);
        throw err;
    }
}

module.exports = {seedType};