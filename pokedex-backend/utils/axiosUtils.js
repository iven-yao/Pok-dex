const axios = require('axios');

async function fetchWithRetry(url, maxRetries = 5, delay = 1000) {
  for (let i = 0; i < maxRetries; i++) {
    try {
        return await axios.get(url, { timeout: 10000 }); // 10 second timeout
    } catch (error) {
        if (i === maxRetries - 1) throw error;
        await new Promise(resolve => setTimeout(resolve, delay));
        delay *= 2; // Exponential backoff
    }
  }
}

const fetchDetails = async(url) => {
    const response = await fetchWithRetry(url);
    return response.data;
}

module.exports = {fetchWithRetry, fetchDetails}