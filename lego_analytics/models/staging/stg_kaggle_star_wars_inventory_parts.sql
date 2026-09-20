-- Kaggle-era inventory parts (2017 and earlier), scoped to Star Wars sets.
-- Uses only the LATEST inventory version per set, to avoid double-counting
-- parts across superseded inventory revisions.
-- Excludes color_id 9999 (non-standard/promotional inventory items).

with latest_inventory as (
    select
        inv.id as inventory_id,
        inv.set_num,
        inv.version,
        row_number() over (
            partition by inv.set_num
            order by inv.version desc
        ) as rn
    from {{ source('raw', 'inventories') }} inv
)

select
    ip.part_num,
    ip.color_id,
    ip.quantity,
    ip.is_spare,
    li.set_num,
    'kaggle' as source_system
from {{ source('raw', 'inventory_parts') }} ip
inner join latest_inventory li
    on ip.inventory_id = li.inventory_id
    and li.rn = 1
inner join {{ ref('stg_kaggle_star_wars_sets') }} sws
    on li.set_num = sws.set_num
where ip.color_id != 9999