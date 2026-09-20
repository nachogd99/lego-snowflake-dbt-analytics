-- API-sourced inventory parts (2018 onward), already scoped to Star Wars sets at extraction.
-- Excludes color_id 9999 (non-standard/promotional inventory items) for consistency
-- with the Kaggle-side staging model.

select
    part_num,
    color_id,
    quantity,
    is_spare,
    set_num,
    'api' as source_system
from {{ source('raw', 'api_inventory_parts') }}
where color_id != 9999