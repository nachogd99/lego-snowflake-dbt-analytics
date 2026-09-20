-- Recursive CTE to find the Kaggle-era Star Wars theme hierarchy (root 158 + all descendants)
-- Note: this ID scheme applies ONLY to the historical Kaggle SETS/THEMES tables.
-- The live Rebrickable API uses a different, unrelated scheme (just IDs 158 and 171) for API_SETS.

with recursive star_wars_themes as (
    select id, name, parent_id
    from {{ source('raw', 'themes') }}
    where id = 158

    union all

    select t.id, t.name, t.parent_id
    from {{ source('raw', 'themes') }} t
    inner join star_wars_themes swt on t.parent_id = swt.id
)

select * from star_wars_themes