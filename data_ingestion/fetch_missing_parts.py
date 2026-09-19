import os
import time
import requests
import csv
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("REBRICKABLE_API_KEY")
HEADERS = {"Authorization": f"key {API_KEY}"}

part_nums = []
with open("../data/missing_part_nums.csv", "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        part_nums.append(row["PART_NUM"])

print(f"Fetching details for {len(part_nums)} missing parts...")

def chunks(lst, size):
    for i in range(0, len(lst), size):
        yield lst[i:i + size]

results = []
for batch in chunks(part_nums, 50):
    url = "https://rebrickable.com/api/v3/lego/parts/"
    params = {"part_nums": ",".join(batch), "page_size": 100}

    while url:
        response = requests.get(url, headers=HEADERS, params=params)
        response.raise_for_status()
        data = response.json()

        for part in data["results"]:
            results.append({
                "part_num": part["part_num"],
                "name": part["name"],
                "part_cat_id": part["part_cat_id"]
            })

        url = data["next"]
        params = None

    time.sleep(1.5)

print(f"Fetched {len(results)} parts")

output_path = "../data/api_missing_parts.csv"
with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["part_num", "name", "part_cat_id"])
    writer.writeheader()
    writer.writerows(results)

print(f"Saved to {output_path}")