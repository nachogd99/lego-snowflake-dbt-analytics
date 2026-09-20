-- Validation queries for the staging "inventory_parts" models
-- Run after building stg_kaggle_star_wars_inventory_parts, stg_api_star_wars_inventory_parts,
-- and stg_all_star_wars_inventory_parts.

-- 1. Row count for Kaggle-era Star Wars inventory parts (2017 and earlier).
-- Scoped to Star Wars sets, latest inventory version only, color_id 9999 excluded.
-- Expected: 52,939 rows.
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_kaggle_star_wars_inventory_parts;

-- 2. Row count for API-sourced Star Wars inventory parts (2018 onward).
-- Expected: 55,023 rows (55,170 raw rows minus 147 excluded color_id=9999 rows).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_api_star_wars_inventory_parts;

-- 3. Confirm the actual count of color_id=9999 rows in the raw API data.
-- This corrected an earlier assumption (based on 3 distinct affected part_nums)
-- that only 3 rows were affected — the real figure is 147 rows, since the same
-- promotional/non-standard item pattern recurs across many different sets.
SELECT COUNT(*) FROM LEGO_DB.RAW.API_INVENTORY_PARTS WHERE color_id = 9999;

-- 4. Check for exact duplicate rows in the raw API inventory parts data,
-- as a second possible explanation for the row-count discrepancy above.
-- Returned no rows — confirms the gap was fully explained by the color_id=9999
-- exclusion alone, not duplicate data.
SELECT set_num, part_num, color_id, quantity, is_spare, COUNT(*) as cnt
FROM LEGO_DB.RAW.API_INVENTORY_PARTS
GROUP BY set_num, part_num, color_id, quantity, is_spare
HAVING COUNT(*) > 1;

-- 5. Row count for the unified inventory parts model (Kaggle + API combined via UNION ALL).
-- Expected: 107,962 rows (52,939 + 55,023).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_all_star_wars_inventory_parts;