with part_aggregates as (
    select
        set_num,
        count(distinct part_num) as distinct_part_count,
        count(distinct color_id) as distinct_color_count,
        sum(quantity) as total_quantity
    from {{ ref('fact_inventory_parts') }}
    group by set_num
),

top_color_per_set as (
    select
        set_num,
        color_id,
        sum(quantity) as color_quantity,
        row_number() over (
            partition by set_num
            order by sum(quantity) desc
        ) as rn
    from {{ ref('fact_inventory_parts') }}
    group by set_num, color_id
),

year_averages as (
    select
        year,
        avg(num_parts) as avg_num_parts_that_year
    from {{ ref('dim_sets') }}
    group by year
)

select
    ds.set_num,
    ds.set_name,
    ds.year,
    ds.num_parts,
    ds.source_system,

    pa.distinct_part_count,
    pa.distinct_color_count,
    pa.total_quantity,

    round(pa.total_quantity::float / nullif(pa.distinct_part_count, 0), 2) as repetition_ratio,

    tc.color_quantity as top_color_quantity,
    round(tc.color_quantity::float / nullif(pa.total_quantity, 0) * 100, 1) as top_color_pct,

    ya.avg_num_parts_that_year,
    round(ds.num_parts::float / nullif(ya.avg_num_parts_that_year, 0), 2) as size_vs_year_avg_ratio,

    case
        when ds.year between 1999 and 2005 then 'Original/Prequel'
        when ds.year between 2006 and 2014 then 'Clone Wars era'
        when ds.year between 2015 and 2019 then 'Sequel Trilogy era'
        when ds.year between 2020 and 2026 then 'Disney+ era'
        else 'Other'
    end as era

from {{ ref('dim_sets') }} ds
inner join part_aggregates pa on ds.set_num = pa.set_num
left join top_color_per_set tc on ds.set_num = tc.set_num and tc.rn = 1
left join year_averages ya on ds.year = ya.year