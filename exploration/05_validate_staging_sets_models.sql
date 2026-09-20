-- Validation queries for the staging "sets" models (theme scoping + Kaggle/API union)
-- Run after building stg_star_wars_theme_ids, stg_kaggle_star_wars_sets,
-- stg_api_star_wars_sets, and stg_all_star_wars_sets.

-- 1. Confirm the recursive CTE correctly identified the full Star Wars theme hierarchy.
-- Expected: 30 rows (theme 158 + 29 descendants across 3 levels of nesting).
-- Note: this model was originally created in the PUBLIC schema before the custom
-- schema macro was added; it now lives in STAGING going forward.
SELECT * FROM LEGO_DB.STAGING.stg_star_wars_theme_ids ORDER BY id;

-- 2. Row count for Kaggle-era Star Wars sets (2017 and earlier), scoped via the theme hierarchy.
-- Expected: 592 rows.
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_kaggle_star_wars_sets;

-- 3. Row count for API-sourced Star Wars sets (2018 onward).
-- Expected: 462 rows (matches the original Rebrickable API fetch).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_api_star_wars_sets;

-- 4. Row count for the unified sets model (Kaggle + API combined via UNION ALL).
-- Expected: 1,054 rows (592 + 462).
SELECT COUNT(*) FROM LEGO_DB.STAGING.stg_all_star_wars_sets;

-- 5. Confirm the two sources split cleanly by year, with no gap and no overlap.
-- Expected: kaggle = 1999-2017 (592 rows), api = 2018-2026 (462 rows).
SELECT source_system, MIN(year) AS earliest, MAX(year) AS latest, COUNT(*) AS n
FROM LEGO_DB.STAGING.stg_all_star_wars_sets
GROUP BY source_system;