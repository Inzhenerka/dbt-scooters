select
    company,
    count(*) as models,
    sum(scooters) as scooters
from
    {{ ref("models") }}
group by
    1
