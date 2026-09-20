select
    p.part_num,
    p.name as part_name,
    pc.name as part_category_name,
    p.source_system
from {{ ref('stg_all_parts') }} p
left join {{ ref('stg_all_part_categories') }} pc
    on p.part_cat_id = pc.id