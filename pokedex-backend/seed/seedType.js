const { fetchWithRetry } = require("../utils/axiosUtils");
const { POKEAPI_BASE_URI } = require("../utils/constants");

const seedType = async (client, multibar) => {
    try {
        const response = await fetchWithRetry(`${POKEAPI_BASE_URI}/type?limit=${process.env.TYPE_LIMIT || 18}`);
        const types = response.data.results;
        const bar = multibar.create(types.length, 0,{filename: "seedType   "});

        for(const type of types) {
            const detailResponse = await fetchWithRetry(type.url);
            const typeData = {
                id: detailResponse.data.id,
                name: detailResponse.data.name,
            };

            await client.query(
                '\
                INSERT INTO types (id, name) \
                VALUES ($1, $2) \
                ON CONFLICT (id) DO NOTHING',
                [typeData.id, typeData.name]
            );

            bar.increment();
        }


    } catch (err) {
        console.error(err.message);
        throw err;
    }
}

module.exports = {seedType};