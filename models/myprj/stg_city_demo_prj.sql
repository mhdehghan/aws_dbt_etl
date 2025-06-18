select
    try_cast(_id as int) as id,
    initcap(PARKING_TYPE) as parking_type,
    initcap(STREETNAME) as street_name,
    trim(STREETNO) as street_no,
    initcap(WARD) as ward,
    try_cast(LICENSED_SPACES as int) as licensed_spaces
from public.city_demo_prj
where _id is not null