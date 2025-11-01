const sqlite3 = require("sqlite3");
const { open } = require("sqlite");
const path = require("path");

const DB_PATH = process.env.DB_PATH || path.join(__dirname, "mgnrega_cache.db");

async function init() {
  const db = await open({ filename: DB_PATH, driver: sqlite3.Database });
  await db.exec(`CREATE TABLE IF NOT EXISTS cache (
    district TEXT PRIMARY KEY,
    data TEXT,
    fetched_at INTEGER
  )`);
  return db;
}

async function getDB() {
  if (!global._mgnrega_db) {
    global._mgnrega_db = await init();
  }
  return global._mgnrega_db;
}

module.exports = {
  async getCachedData(district) {
    const db = await getDB();
    const row = await db.get(
      "SELECT district, data, fetched_at FROM cache WHERE district = ?",
      district
    );
    return row || null;
  },
  async upsertCache(district, data) {
    const db = await getDB();
    const now = Date.now();
    await db.run(
      "INSERT INTO cache(district,data,fetched_at) VALUES(?,?,?) ON CONFLICT(district) DO UPDATE SET data=excluded.data, fetched_at=excluded.fetched_at",
      district,
      data,
      now
    );
  },
  async getAllCachedDistricts() {
    const db = await getDB();
    const rows = await db.all("SELECT district FROM cache");
    return rows;
  },
};
