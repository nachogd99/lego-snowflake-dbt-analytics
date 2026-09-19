import os
import time
import requests
import csv
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("REBRICKABLE_API_KEY")
HEADERS = {"Authorization": f"key {API_KEY}"}

missing_color_ids = [1061, 1050, 1136, 1055, 1103, 1063, 1053, 1054, 1095]

results = []
for color_id in missing_color_ids:
    response = requests.get(
        f"https://rebrickable.com/api/v3/lego/colors/{color_id}/",
        headers=HEADERS
    )
    response.raise_for_status()
    data = response.json()
    results.append({
        "id": data["id"],
        "name": data["name"],
        "rgb": data["rgb"],
        "is_trans": data["is_trans"]
    })
    time.sleep(1.5)

output_path = "../data/api_missing_colors.csv"
with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["id", "name", "rgb", "is_trans"])
    writer.writeheader()
    writer.writerows(results)

print(f"Fetched {len(results)} colors, saved to {output_path}")