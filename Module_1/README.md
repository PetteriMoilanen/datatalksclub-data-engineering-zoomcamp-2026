# Solutions to Module 1 homework: Docker & SQL

https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2026/01-docker-terraform/homework.md

Shell commands etc. required to answer questions have been run in a GitHub Codespace created in this repo.

## Question 1. Understanding Docker images
Run docker with the python:3.13 image. Use an entrypoint bash to interact with the container.

What's the version of pip in the image?

25.3
24.3.1
24.2.1
23.3.1

### Answer
25.3
### Steps
1. Start a container with:
   *docker run -it --rm --entrypoint=bash python:3.13*
3. Once inside the container:
   *pip --version*

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

If multiple answers are correct, select any 

### Answer
postgres:5432 and db:5432

### Explanation
You can refer to the database both by the service and the container name; the internal port is in the both cases the same.

## Note: SQL queries have been run in Jupyter notebook connected to database

## Question 3. Counting short trips
For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a trip_distance of less than or equal to 1 mile?

- 7,853
- 8,007
- 8,254
- 8,421

### Answer
8007

### Query:
```python
query = text("""
    SELECT count(*) 
    FROM green_taxi_nov_2025 
    WHERE lpep_pickup_datetime >= :start_date 
      AND lpep_pickup_datetime < :end_date
      AND trip_distance <= :distance
""")

with engine.connect() as conn:
    result = conn.execute(query, {"start_date": "2025-11-01", "end_date": "2025-12-01", "distance": 1.0})
    count = result.scalar()
    print(count)
```
Note: I've been told that this is the most efficient way to choose by date with timestamp columns.

## Question 4. Longest trip for each day
Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

- 2025-11-14
- 2025-11-20
- 2025-11-23
- 2025-11-25

### Answer
2025-11-14
### Query
```python
query = text("""
    SELECT lpep_pickup_datetime 
    FROM green_taxi_nov_2025 
    WHERE trip_distance < :distance
    ORDER BY trip_distance DESC
    LIMIT 1
""")

with engine.connect() as conn:
    result = conn.execute(query, {"distance": 100.0})
    pickup_date = result.scalar()
    print(pickup_date)
```