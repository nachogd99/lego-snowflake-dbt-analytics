-- API-sourced Star Wars sets (2018 onward). Already scoped to Star Wars at extraction time
-- (theme_id 158, 171 — the live API's consolidated theme scheme).
select
    set_num,
    name,
    year,
    theme_id,
    num_parts,
    'api' as source_system
from {{ source('raw', 'api_sets') }}