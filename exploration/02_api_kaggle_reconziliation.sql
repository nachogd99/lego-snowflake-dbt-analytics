-- Does API_INVENTORY_PARTS reference any part_num not in the Kaggle PARTS table?
SELECT COUNT(DISTINCT ip.part_num) AS unknown_parts
FROM LEGO_DB.RAW.API_INVENTORY_PARTS ip
LEFT JOIN LEGO_DB.RAW.PARTS p ON ip.part_num = p.part_num
WHERE p.part_num IS NULL;

-- Actuals IDs
SELECT DISTINCT ip.part_num
FROM LEGO_DB.RAW.API_INVENTORY_PARTS ip
LEFT JOIN LEGO_DB.RAW.PARTS p ON ip.part_num = p.part_num
WHERE p.part_num IS NULL;


-- Does API_INVENTORY_PARTS reference any color_id not in the Kaggle COLORS table?
SELECT COUNT(DISTINCT ip.color_id) AS unknown_colors
FROM LEGO_DB.RAW.API_INVENTORY_PARTS ip
LEFT JOIN LEGO_DB.RAW.COLORS c ON ip.color_id = c.id
WHERE c.id IS NULL;

-- Actuals IDs
SELECT DISTINCT ip.color_id
FROM LEGO_DB.RAW.API_INVENTORY_PARTS ip
LEFT JOIN LEGO_DB.RAW.COLORS c ON ip.color_id = c.id
WHERE c.id IS NULL;


-- Oprhan Check after reconziliation
-- Confirm every part_num in API_INVENTORY_PARTS now resolves against PARTS + API_MISSING_PARTS combined
SELECT COUNT(DISTINCT ip.part_num) AS still_unknown_parts
FROM LEGO_DB.RAW.API_INVENTORY_PARTS ip
LEFT JOIN (
    SELECT part_num FROM LEGO_DB.RAW.PARTS
    UNION ALL
    SELECT part_num FROM LEGO_DB.RAW.API_MISSING_PARTS
) all_parts ON ip.part_num = all_parts.part_num
WHERE all_parts.part_num IS NULL;

-- Confirm every color_id in API_INVENTORY_PARTS now resolves against COLORS + API_MISSING_COLORS combined
SELECT COUNT(DISTINCT ip.color_id) AS still_unknown_colors
FROM LEGO_DB.RAW.API_INVENTORY_PARTS ip
LEFT JOIN (
    SELECT id FROM LEGO_DB.RAW.COLORS
    UNION ALL
    SELECT id FROM LEGO_DB.RAW.API_MISSING_COLORS
) all_colors ON ip.color_id = all_colors.id
WHERE all_colors.id IS NULL;