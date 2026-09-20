with color_year_totals as (
    select
        year,
        color_id,
        sum(quantity) as quantity
    from {{ ref('fact_inventory_parts') }}
    group by year, color_id
),

overall_color_ranks as (
    select
        color_id,
        sum(quantity) as overall_quantity,
        row_number() over (order by sum(quantity) desc) as rn
    from {{ ref('fact_inventory_parts') }}
    group by color_id
),

year_totals as (
    select
        year,
        sum(quantity) as year_total_quantity
    from {{ ref('fact_inventory_parts') }}
    group by year
)

select
    cyt.year,
    case when ocr.rn <= 10 then dc.color_name else 'Other' end as color_group,
    sum(cyt.quantity) as quantity,
    round(sum(cyt.quantity)::float / yt.year_total_quantity * 100, 2) as pct_of_year

from color_year_totals cyt
inner join overall_color_ranks ocr on cyt.color_id = ocr.color_id
inner join {{ ref('dim_colors') }} dc on cyt.color_id = dc.color_id
inner join year_totals yt on cyt.year = yt.year

group by cyt.year, color_group, yt.year_total_quantity
order by cyt.year, quantity desc