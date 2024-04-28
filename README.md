# dbt-scooters Demo

Демонстрационный проект для работы с dbt в рамках вебинара "Введение в dbt: основы моделирования данных"

## Настройка окружения dbt Cloud и получение исходных данных

Чтобы создать новый проект dbt в бесплатной облачной среде dbt Cloud, настроить бесплатную облачную базу данных PostgreSQL
и получить данные для анализа через Telegram-бота, необходимо:

- Получить бесплатный демо-доступ к тренажеру ["dbt для инженеров данных и аналитиков"](https://inzhenerka.tech/dbt)
- Пройти первые 4 урока, последовательно выполнив все задания


## Задание

*Задание взято из Миссии 7 "Создаем таблицы из CSV-файлов" курса ["dbt для инженеров данных и аналитиков"](https://inzhenerka.tech/dbt)*

<img src="https://github.com/Inzhenerka/dbt-course-materials/blob/main/art/Farya.jpg?raw=true" alt="Хакер" style="width: 100px;">&nbsp;<b>Фаря</b>

Надо помочь ребятам из сервисной команды. Они хотят понять, **самокаты каких производителей пользуются наибольшей популярностью**. Иными словами, есть ли у пользователей предпочтения по конкретным брендам. Это поможет определиться с предстоящими закупками.

Они прислали **файл с моделями самокатов**, сказали, он тебе поможет. Файл имеет **формат CSV**, данные там в табличном виде. Только, пожалуйста, давай попробуем обойтись без Экселя в этот раз. Я понимаю, это удобный инструмент, Игорь его любит и наверняка применил бы. Проблема в том, что это не разовая задача, и сервис будет обращаться к нам снова и снова. Потому сразу хочется автоматизировать расчет, а по результатам прикрутить к нему простой дашборд.

Файл [models.csv](/models.csv) находится в корне проекта.

### Выполнение задания

1. Создать из файла `models.csv` сущность dbt seed

Конфигурация сида:

```yml
  - name: "models"
    description: "Scooter models info and statistics"
    config:
      delimiter: ","
```

2. Создать на основе сида `models` модель `companies` с полями:

- company — название компании
- models — количество уникальных моделей
- scooters — количество самокатов (автопарк)

Исходный запрос:

```sql
select
    company,
    count(*) as models,
    sum(scooters) as scooters
from
    dbt.models
group by
    1
```

Свойства модели:

```yml
  - name: "companies"
    description: "Scooter statistics by company"
```

3. Создать агрегированную модель `companies_trips` со статистикой поездок для каждой компании-производителя.

Этапы решения:

- Объединить `trips_prep` с `models` и рассчитать общее количество поездок (`trips`) по компании (`company`)
- Объединить результат с `companies`, чтобы получить информацию о количестве самокатов компании (`scooters`). Затем найти средне число поездок на одном самокате для каждой компании: `trips_per_scooter`


Исходный запрос:

```sql
with trips_cte as (
    select
        company,
        count(*) as trips
    from
        dbt.trips_prep as t
        join dbt.models as m
            on t.scooter_hw_id = m.hardware_id
    group by
        1
)
select
    company,
    t.trips,
    c.scooters,
    t.trips / cast(c.scooters as float) as trips_per_scooter
from
    trips_cte as t
    join dbt.companies as c
        using (company)
```

Свойства модели:

```yml
  - name: "companies_trips"
    description: "Trip statistics by company"
```

4. (Опционально) Создать каталог данных

Закоммитить изменения в репозиторий GitHub и клонировать его на компьютер. После чего установить `dbt-core`, `dbt-postgres` и настроить подключение к базе данных.

Сгенерировать каталог данных:

```bash
dbt docs generate
```

Запустить и открыть каталог:

```bash
dbt docs serve
```
