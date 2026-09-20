select
    id as color_id,
    name as color_name,
    rgb,
    is_trans,
    source_system
from {{ ref('stg_all_colors') }}