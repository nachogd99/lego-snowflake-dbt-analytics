select
    ip.set_num,
    ip.part_num,
    ip.color_id,
    ip.quantity,
    ip.is_spare,
    ip.source_system,
    ds.year,
    ds.theme_id,
    ds.num_parts as set_total_num_parts
from {{ ref('stg_all_star_wars_inventory_parts') }} ip
inner join {{ ref('dim_sets') }} ds
    on ip.set_num = ds.set_num