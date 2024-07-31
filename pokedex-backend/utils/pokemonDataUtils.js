// transform stats data like this in to key value pair like below
// "stats": [
//     {
//         "base_stat": 45,
//         "effort": 0,
//         "stat": {
//             "name": "hp",
//             "url": "https://pokeapi.co/api/v2/stat/1/"
//         }
//     },
//     ... more
// ],
// --------------- to this -----------------
// {
//   hp: 45,
//   attack: 49,
//   defense: 49,
//   special_attack: 65,
//   special_defense: 65,
//   speed: 45
// }
const decodedStats = (statsData) => statsData.reduce((acc, stat) => {
    acc[(stat.stat.name).replace('-','_')] = stat.base_stat;
    return acc;
}, {});

const getAbilityIdFromUrl = (url) => {
    const parts = url.split('/');
    return parts[parts.length - 2];
}

const getAbilityDescription = (flavorTextEntries) => {
    const description = flavorTextEntries.find(entry => entry.language.name === 'en');
    return description? description.flavor_text : '';
}

module.exports = {decodedStats, getAbilityIdFromUrl, getAbilityDescription}