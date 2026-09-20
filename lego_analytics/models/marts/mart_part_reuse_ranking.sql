select
    fip.part_num,
    dp.part_name,
    dp.part_category_name,
    count(distinct fip.set_num) as num_sets_used_in,
    sum(fip.quantity) as total_quantity_across_sets,
    round(sum(fip.quantity)::float / count(distinct fip.set_num), 2) as avg_quantity_per_set

from {{ ref('fact_inventory_parts') }} fip
inner join {{ ref('dim_parts') }} dp on fip.part_num = dp.part_num

group by fip.part_num, dp.part_name, dp.part_category_name
order by num_sets_used_in desc