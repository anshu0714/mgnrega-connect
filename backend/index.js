const express = require("express");
const axios = require("axios");
const cors = require("cors");
const cron = require("node-cron");
const db = require("./db");
require("dotenv").config();

const PORT = process.env.PORT || 8080;
const DATA_SOURCE_URL = process.env.DATA_SOURCE_URL || "";

const app = express();
app.use(cors());
app.use(express.json());

// fetch data from source for a given district
async function fetchFromSource(district) {
  if (!DATA_SOURCE_URL) {
    throw new Error(
      "DATA_SOURCE_URL not configured. Set it in your .env file."
    );
  }

  const url = DATA_SOURCE_URL.replace(
    "{district}",
    encodeURIComponent(district)
  );
  console.log("Fetching from:", url);

  const resp = await axios.get(url, { timeout: 20000 });
  return resp.data;
}

// Health check
app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

// Get MGNREGA data for a district
app.get("/data/:district", async (req, res) => {
  const district = req.params.district;
  try {
    const cached = await db.getCachedData(district);
    if (cached) {
      const ageHours = (Date.now() - cached.fetched_at) / (1000 * 60 * 60);
      if (ageHours < 24) {
        console.log(`Serving cached data for ${district}`);
        console.log(`Result: ${JSON.parse(cached.data)}`);
        return res.json({
          cached: true,
          source: "db",
          data: JSON.parse(cached.data),
        });
      }
    }

    console.log(`Fetching fresh data for ${district}`);
    const data = await fetchFromSource(district);
    await db.upsertCache(district, JSON.stringify(data));

    res.json({ cached: false, source: "external", data });
  } catch (e) {
    console.error("Error fetching data for", district, e.message);
    try {
      const cached = await db.getCachedData(district);
      if (cached) {
        return res.json({
          cached: true,
          source: "db",
          data: JSON.parse(cached.data),
          warning: "served cached data due to fetch error",
        });
      }
    } catch (_) {}
    res.status(500).json({ error: e.message || "unknown error" });
  }
});

// Manual refresh of district
app.get("/refresh", async (req, res) => {
  const district = req.query.district;
  if (!district)
    return res.status(400).json({ error: "district query param required" });

  try {
    const data = await fetchFromSource(district);
    await db.upsertCache(district, JSON.stringify(data));
    res.json({ refreshed: true, district });
  } catch (e) {
    res.status(500).json({ error: e.message || "failed to refresh" });
  }
});

// Refresh all cached districts every 6 hours
cron.schedule("0 */6 * * *", async () => {
  console.log("Cron: refreshing all cached districts...");
  try {
    const rows = await db.getAllCachedDistricts();
    for (const r of rows) {
      try {
        const data = await fetchFromSource(r.district);
        await db.upsertCache(r.district, JSON.stringify(data));
        console.log("Refreshed cache for", r.district);
      } catch (err) {
        console.error("Error refreshing", r.district, err.message);
      }
    }
  } catch (e) {
    console.error("Cron error:", e.message);
  }
});

app.listen(PORT, () => {
  console.log(`MGNREGA backend running on port ${PORT}`);
});
