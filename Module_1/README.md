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

## Note: SQL queries have been run in Jupyter notebook...
...connected to database with the **sqlalchemy** library. See the [EDA notebook](./Taxi_EDA.ipynb) for details.

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

## Question 5. Biggest pickup zone
Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

- East Harlem North
- East Harlem South
- Morningside Heights
- Forest Hills
### Answer
East Harlem North
### Query
```python
query = text("""
    SELECT t.zone, sum(g.fare_amount) as total_amount
    FROM green_taxi_nov_2025 g 
    INNER JOIN taxi_zones t ON g.pulocationid = t.locationid    
    WHERE 
        g.lpep_pickup_datetime >= :start_date
    AND g.lpep_pickup_datetime < :next_date
    GROUP BY t.zone
    ORDER BY total_amount DESC
""")
df_temp = pd.read_sql(query, engine, params={"start_date": "2025-11-18", "next_date": "2025-11-19"})
df_temp.head()
```
Note: I've been told that this is the most efficient way to choose by date with timestamp columns.

## Question 6. Largest tip
For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's tip , not trip. We need the name of the zone, not the ID.

- JFK Airport
- Yorkville West
- East Harlem North
- LaGuardia Airport

### Answer
Yorkville West
### Query
```python
query = text("""
    WITH east_harlem_pickups AS (
        SELECT t.zone, g.pulocationid, g.dolocationid, g.tip_amount, g.lpep_pickup_datetime
    FROM green_taxi_nov_2025 g 
    INNER JOIN taxi_zones t ON g.pulocationid = t.locationid    
    WHERE 
        t.zone = 'East Harlem North'
    )
    SELECT t.zone, e.tip_amount, e.lpep_pickup_datetime
    FROM east_harlem_pickups e 
    INNER JOIN taxi_zones t ON e.dolocationid = t.locationid    
    ORDER BY e.tip_amount DESC
    LIMIT 20         
""")
df_temp = pd.read_sql(query, engine)
df_temp.head()
```
## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform.
Copy the files from the course repo
[here](../../../01-docker-terraform/terraform/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.

### Steps
1. Terraform installed in the GitHub Codespace.
2. Created Google Cloud project **datatalks-de-zoomcamp-2026**.
3. Created service account **petteri-terraform** with Viewer role.
4. Created and downloaded JSON key for the service account and added the file to the Codespace.
5. Added path to the JSON key to .gitignore. 
6. Installed gcloud in the Codespace venv (see install_gcloud.sh). I really should get to grips with devcontainers, though...

## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

### Answer
- terraform init, terraform apply -auto-approve, terraform destroy
### Explanation
- terraform init: workflow part 1
- terraform apply -auto-approve: updates the infra without interactive prompts
- terraform destroy: deletes every resource managed by the Terraform project
