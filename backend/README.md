
MGNREGA Backend (Node.js + SQLite)
---------------------------------

Setup:
1. Install Node.js (v18+ recommended).
2. In this folder run:
   npm install

3. Configure environment variables:
   - DATA_SOURCE_URL : The API URL pattern to fetch district data.
       Use token {district} where relevant. Example:
       'https://api.data.gov.in/resource/'
   - PORT : port to run server (default 8080)

Run:
   npm start

Endpoints:
 - GET /health
 - GET /data/:district  -> returns cached or freshly fetched data
 - GET /refresh?district=Name  -> manually refresh cache for district

Cron:
 - The server automatically refreshes cached districts every 6 hours.

Important:
 - Replace DATA_SOURCE_URL with the exact MGNREGA API endpoint you plan to use.
 - If the API needs headers or keys, include them in the URL or set up axios config in index.js.
