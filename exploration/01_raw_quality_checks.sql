-- Sets referencing a theme that doesn't exist
SELECT COUNT(*) AS orphaned_sets
FROM LEGO_DB.RAW.SETS s
LEFT JOIN LEGO_DB.RAW.THEMES t ON s.theme_id = t.id
WHERE t.id IS NULL;

-- Parts referencing a category that doesn't exist
SELECT COUNT(*) AS orphaned_parts
FROM LEGO_DB.RAW.PARTS p
LEFT JOIN LEGO_DB.RAW.PART_CATEGORIES pc ON p.part_cat_id = pc.id
WHERE pc.id IS NULL;

-- Inventory_parts referencing a color that doesn't exist
SELECT COUNT(*) AS orphaned_colors
FROM LEGO_DB.RAW.INVENTORY_PARTS ip
LEFT JOIN LEGO_DB.RAW.COLORS c ON ip.color_id = c.id
WHERE c.id IS NULL;

-- Unexpected nulls in fields that should always be populated
SELECT
    SUM(CASE WHEN set_num IS NULL THEN 1 ELSE 0 END) AS null_set_num,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN theme_id IS NULL THEN 1 ELSE 0 END) AS null_theme_id
FROM LEGO_DB.RAW.SETS;

-- Check latest date in kaggle set
SELECT MAX(year) AS latest_kaggle_year
FROM LEGO_DB.RAW.SETS
WHERE theme_id IN (158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,612,613);