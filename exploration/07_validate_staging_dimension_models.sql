-- Validation queries for the staging dimension models: colors, parts, part_categories
-- Run after building stg_all_colors, stg_all_parts, and stg_all_part_categories.

-- 1. Row count for combined colors (Kaggle + API top-up).
-- Expected: 144 rows (135 + 9).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_all_colors;

-- 2. Row count for combined parts (Kaggle + API top-up).
-- Expected: 26,967 rows (25,993 + 974 — see note below on the 974 vs 975 discrepancy).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_all_parts;

-- 3. Check whether any part_cat_id values referenced by the new API-sourced parts
-- are missing from the original Kaggle PART_CATEGORIES table.
-- Returned 14 missing category IDs, requiring one more API top-up fetch
-- (api_missing_part_categories).
SELECT DISTINCT amp.part_cat_id
FROM LEGO_DB.RAW.API_MISSING_PARTS amp
LEFT JOIN LEGO_DB.RAW.PART_CATEGORIES pc ON amp.part_cat_id = pc.id
WHERE pc.id IS NULL;

-- 4. Confirm the actual row count of the API_MISSING_PARTS raw table.
-- Returned 974, not 975 as originally assumed — the original missing_part_nums.csv
-- had 977 distinct values; 974 resolved successfully via the batch fetch, and the
-- remaining 3 were the promotional items (color_id=9999) investigated separately.
SELECT COUNT(*) FROM LEGO_DB.RAW.API_MISSING_PARTS;

-- 5. Check for duplicate part_num values in the combined parts staging model.
-- Returned no rows — confirms the union is clean, no double-counted parts.
SELECT part_num, COUNT(*)
FROM LEGO_DB.STAGING.stg_all_parts
GROUP BY part_num
HAVING COUNT(*) > 1;

-- 6. Row count for combined part_categories (Kaggle + API top-up).
-- Expected: 71 rows (57 + 14).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_all_part_categories;