-- Combined parts from both sources: the original Kaggle catalog (2017 and earlier)
-- plus parts introduced since 2017 that were missing when reconciling against the API data.
select part_num, name, part_cat_id, 'kaggle' as source_system
from {{ source('raw', 'parts') }}

union all

select part_num, name, part_cat_id, 'api' as source_system
from {{ source('raw', 'api_missing_parts') }}