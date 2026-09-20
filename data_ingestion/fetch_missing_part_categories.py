import os
import requests
import csv
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("REBRICKABLE_API_KEY")
HEADERS = {"Authorization": f"key {API_KEY}"}

missing_cat_ids = [73, 65, 59, 75, 68, 72, 71, 69, 61, 60, 67, 58, 77, 76]

results = []
for cat_id in missing_cat_ids:
    response = requests.get(
        f"https://rebrickable.com/api/v3/lego/part_categories/{cat_id}/",
        headers=HEADERS
    )
    response.raise_for_status()
    data = response.json()
    results.append({"id": data["id"], "name": data["name"]})

output_path = "../data/api_missing_part_categories.csv"
with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["id", "name"])
    writer.writeheader()
    writer.writerows(results)

print(f"Fetched {len(results)} part categories, saved to {output_path}")