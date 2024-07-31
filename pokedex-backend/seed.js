const { pool } = require("./config/seed-connect");
const { seedAbility } = require("./seed/seedAbility");
const { seedPokemon } = require("./seed/seedPokemon");
const { seedType } = require("./seed/seedType");
const cliProgress = require('cli-progress');

async function executeWithTransaction(client, operation) {
    try {
        await client.query('BEGIN');
        await operation();
        await client.query('COMMIT');
    } catch (error) {
        await client.query('ROLLBACK');
        console.error(`Error in ${operation.name}, rolling back:`, error);
        // Optionally, you can choose to re-throw the error if you want to stop the entire process
        // throw error;
    }
}

async function connectWithRetry(maxRetries = 5, delay = 5000) {
    for (let i = 0; i < maxRetries; i++) {
        try {
            const client = await pool.connect();
            console.log('Successfully connected to the database');
            return client;
        } catch (err) {
            console.error(`Failed to connect to the database (attempt ${i + 1}/${maxRetries}):`, err.message);
            if (i === maxRetries - 1) throw err;
            await new Promise(res => setTimeout(res, delay));
        }
    }
}

async function seedDatabase() {
    console.log('Starting database seeding process...');
    let client;
    const multibar = new cliProgress.MultiBar({
        format: ' {bar} | {filename} | {value}/{total}',
    }, cliProgress.Presets.shades_grey);
    
    try {
        client = await connectWithRetry();

        await executeWithTransaction(client, async () => await seedType(client, multibar));
        await executeWithTransaction(client, async () => await seedAbility(client, multibar));
        await executeWithTransaction(client, async () => await seedPokemon(client, multibar));

    } catch (error) {
        console.error('Error during seeding process:', error);
    } finally {
        if (client) {
            await client.release();
        }
        multibar.stop();
    }
}
  
async function main() {
    try {
      await seedDatabase();

      console.log("Finish!");
    } catch (error) {
      console.error('Failed to seed database after multiple attempts:', error);
    } finally {
      await pool.end();
    }
}
  
main();