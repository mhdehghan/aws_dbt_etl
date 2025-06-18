# ETL Pipeline (DBT + Redshift + AWS)

This project demonstrates a simple but effective ETL pipeline built using **DBT**, **Amazon Redshift Serverless**, and **AWS S3**.

## Overview

This project ingests open parking data from the City of Toronto into Redshift, transforms and models the data using DBT, and produces a clean, aggregated fact table that summarizes available parking spaces per ward and parking type.

It highlights:
- Redshift Serverless setup with IAM role-based access
- S3-to-Redshift ingestion using `COPY`
- Modular, testable DBT model design
- Real-world city data aligned with Toronto's digital transformation goals

---

## Technologies Used

- **Amazon Redshift Serverless**
- **AWS S3** (for CSV storage)
- **DBT Core** (locally run)
- **SQL (ETL & modeling)**
- **Open Data** (Toronto Parking dataset)

---

## Project Structure

```
dbt-toronto-parking/
├── models/
│   └── my_prj/
│       ├── stg_city_demo_prj.sql
│       └── fct_city_parking_summary.sql
├── dbt_project.yml
├── profiles.yml
└── README.md
```

---

## Data Source

- **CSV Source:** Toronto Parking Dataset
- **Redshift Table:** `public.city_demo_prj`

---

## ETL Flow

1. Upload the CSV file to AWS S3
2. Use `COPY` to load data into Redshift raw table (`city_demo_prj`)
3. DBT `ref('city_demo_prj')` maps the raw table into:
   - **`stg_city_demo_prj`**: Cleans, casts, and formats columns
   - **`fct_city_parking_summary`**: Aggregates total spaces and locations by ward + parking type

---

## Final Model: `fct_city_parking_summary`

| ward | parking_type | unique_locations | total_spaces |
|------|---------------|------------------|---------------|
| ...  | ...           | ...              | ...           |

This model supports city planners and analytics teams by providing insight into how parking resources are distributed across wards and types.

---

## Testing

DBT built-in tests can be added for:
- `not_null` on `_id`

---

## Getting Started

```bash
# Run models
dbt run

# Test logic
dbt test

# Visualize docs
dbt docs generate && dbt docs serve
```



## Redshift Queries:

### Create the table in Redshift
```sql
CREATE TABLE city_demo_prj (
    _id VARCHAR,
    LICENSED_SPACES VARCHAR,
    PARKING_TYPE VARCHAR,
    STREETNAME VARCHAR,
    STREETNO VARCHAR,
    WARD VARCHAR
);

COPY city_demo_prj
FROM 's3://S3-bucket-311/311/parking_data.csv'
IAM_ROLE 'arn:aws:iam::{ID}:role/MyRedshiftS3AccessRole'
IGNOREHEADER 1
DELIMITER ','
CSV;
```

### Create the user and grant permissions
```sql
CREATE USER my_dbt_user WITH PASSWORD 'MYPASSWORD';
GRANT USAGE ON SCHEMA public TO my_dbt_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO my_dbt_user;

