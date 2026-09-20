-- Combined Star Wars sets from both sources: Kaggle (2017 and earlier) and API (2018 onward).
-- No overlap in years between the two sources — verified during raw data reconciliation.
select * from {{ ref('stg_kaggle_star_wars_sets') }}

union all

select * from {{ ref('stg_api_star_wars_sets') }}