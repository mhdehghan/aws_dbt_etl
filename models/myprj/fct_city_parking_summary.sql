select
    ward,
    parking_type,
    count(distinct street_name || '-' || street_no) as unique_locations,
    sum(licensed_spaces) as total_spaces
from {{ ref('stg_city_demo_prj') }}
group BY 1, 2
order by total_spaces desc