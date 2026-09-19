import os
import requests
import csv
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("REBRICKABLE_API_KEY")
HEADERS = {"Authorization": f"key {API_KEY}"}

STAR_WARS_THEME_IDS = [158, 171]

BASE_URL = "https://rebrickable.com/api/v3/lego/sets/"
all_sets = []

for theme_id in STAR_WARS_THEME_IDS:
    params = {
        "theme_id": theme_id,
        "min_year": 2018,
        "page_size": 100
    }
    url = BASE_URL

    while url:
        response = requests.get(url, headers=HEADERS, params=params)
        response.raise_for_status()
        data = response.json()
        all_sets.extend(data["results"])
        url = data["next"]
        params = None

print(f"Fetched {len(all_sets)} sets total")

output_path = "../data/api_star_wars_sets_2018_onwards.csv"
with open(output_path, "w", newline="", encoding="utf-8") as f:
    if all_sets:
        writer = csv.DictWriter(f, fieldnames=all_sets[0].keys())
        writer.writeheader()
        writer.writerows(all_sets)

print(f"Saved to {output_path}")
print(data["count"])  # total themes in the live API, to confirm 1000 page_size covered everything