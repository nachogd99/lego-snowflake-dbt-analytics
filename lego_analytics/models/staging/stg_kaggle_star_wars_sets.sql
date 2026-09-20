select
    s.set_num,
    s.name,
    s.year,
    s.theme_id,
    s.num_parts,
    'Kaggle' as source_system
from {{ source('raw', 'sets') }} s
inner join {{ ref('stg_star_wars_theme_ids') }} swt
    on s.theme_id = swt.id