-- Combined colors from both sources: the original Kaggle catalog (2017 and earlier)
-- plus colors introduced since 2017 that were missing when reconciling against the API data.
select id, name, rgb, is_trans, 'kaggle' as source_system
from {{ source('raw', 'colors') }}

union all

select id, name, rgb, is_trans, 'api' as source_system
from {{ source('raw', 'api_missing_colors') }}