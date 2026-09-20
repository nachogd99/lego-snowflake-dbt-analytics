-- Combined part categories from both sources: the original Kaggle catalog (2017 and earlier)
-- plus categories introduced since 2017 that were missing when reconciling against the API data.
select id, name, 'kaggle' as source_system
from {{ source('raw', 'part_categories') }}

union all

select id, name, 'api' as source_system
from {{ source('raw', 'api_missing_part_categories') }}