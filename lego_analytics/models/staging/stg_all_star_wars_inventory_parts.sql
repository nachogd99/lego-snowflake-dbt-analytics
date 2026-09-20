-- Combined inventory parts from both sources: Kaggle (2017 and earlier) and API (2018 onward).
select * from {{ ref('stg_kaggle_star_wars_inventory_parts') }}

union all

select * from {{ ref('stg_api_star_wars_inventory_parts') }}