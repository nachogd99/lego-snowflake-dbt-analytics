select
    set_num,
    name as set_name,
    year,
    theme_id,
    num_parts,
    source_system
from {{ ref('stg_all_star_wars_sets') }}