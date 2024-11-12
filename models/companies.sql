select
    company,
    count(*) as models,
    sum(scooters) as scooters
from
    {{ ref("scooters") }}
group by
    1
