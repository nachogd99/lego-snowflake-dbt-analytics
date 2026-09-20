-- Investigating why mart_set_analytics has 971 rows instead of the expected 1,054
-- (matching dim_sets / stg_all_star_wars_sets).
-- Finding: 83 sets in dim_sets have no matching rows in fact_inventory_parts.
-- Of these, 82 are non-standalone entries (co-packs, "Super Packs", bundles,
-- gift sets, promotional kits, a signed minifigure, an advent calendar) that
-- bundle OTHER existing sets together and have no independent parts inventory
-- of their own (their pieces are already counted under the individual sets
-- they bundle) — correctly excluded by the inner join.
-- One exception (set 75160, U-wing, 2017) is a genuine standalone set that
-- is missing an inventory record in the source Kaggle/Rebrickable data itself
-- — a real gap in the source, not an artifact of our pipeline.
-- Decision: keep mart_set_analytics as-is (inner join); 971 rows is the
-- correct, meaningful count of standalone sets with real part composition data.

SELECT ds.set_num, ds.set_name, ds.year, ds.num_parts, ds.source_system
FROM LEGO_DB.MARTS.dim_sets ds
LEFT JOIN LEGO_DB.MARTS.fact_inventory_parts fip
    ON ds.set_num = fip.set_num
WHERE fip.set_num IS NULL
ORDER BY ds.year;

-- Confirms 75160 (U-wing) genuinely has no inventory record at all in the raw data.
SELECT * FROM LEGO_DB.RAW.SETS WHERE set_num = '75160';
SELECT * FROM LEGO_DB.RAW.INVENTORIES WHERE set_num = '75160';