import os
import time
import requests
import csv
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("REBRICKABLE_API_KEY")
HEADERS = {"Authorization": f"key {API_KEY}"}

set_nums = []
with open("../data/api_star_wars_sets_2018_onwards.csv", "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        set_nums.append(row["set_num"])

print(f"Fetching parts for {len(set_nums)} sets...")

output_path = "../data/api_star_wars_inventory_parts_2018_onwards.csv"
fieldnames = ["set_num", "part_num", "color_id", "quantity", "is_spare"]

# Open the file once, upfront, and write rows as we go — not all at the end
with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    for i, set_num in enumerate(set_nums):
        url = f"https://rebrickable.com/api/v3/lego/sets/{set_num}/parts/"
        params = {"page_size": 1000}

        while url:
            # Retry logic: try up to 3 times on transient server errors
            for attempt in range(3):
                try:
                    response = requests.get(url, headers=HEADERS, params=params)
                    response.raise_for_status()
                    break  # success, exit retry loop
                except requests.exceptions.HTTPError as e:
                    if response.status_code in (500, 502, 503, 504) and attempt < 2:
                        wait = 5 * (attempt + 1)  # 5s, then 10s
                        print(f"  Server error on {set_num}, retrying in {wait}s...")
                        time.sleep(wait)
                    else:
                        raise  # give up after 3 tries, or on non-transient errors

            data = response.json()

            for part in data["results"]:
                writer.writerow({
                    "set_num": set_num,
                    "part_num": part["part"]["part_num"],
                    "color_id": part["color"]["id"],
                    "quantity": part["quantity"],
                    "is_spare": part["is_spare"]
                })

            url = data["next"]
            params = None

        time.sleep(1.5)

        if (i + 1) % 50 == 0:
            print(f"  {i + 1}/{len(set_nums)} sets processed...")
            f.flush()  # make sure progress is actually written to disk, not just buffered

print(f"Done. Saved to {output_path}")