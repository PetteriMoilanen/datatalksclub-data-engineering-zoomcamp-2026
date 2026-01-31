# Solutions to Module 2 homework - Kestra stuff

## Things I've done:

- Created [my own version of the Kestra flow](module2_gc_setup.yaml) to create the GC bucket and BQ dataset and another to delete them. The service account credentials are handled with Kestra secrets as described [here.](https://kestra.io/docs/how-to-guides/google-credentials)
- Created [my own version of the Kestra flow](module2_taxi_ELT.yaml) for taxi data ELT for a single year and month. Creds with Kestra secrets as in the previous one and added csv file size logging for question 1.
- For questions 3-5, created
    - a [row counter flow](module2_row_count.yaml) that counts the rows of a single csv file (- the header row).
    - a [main flow](module2_taxi_color_year_month_row_count.yaml) that either runs the row counter for a specific color/year/month if month given or loops all the months if not.
    
    Counts are logged so they can be viewed in Kestra UI.

## Questions and answers:

#### 1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

**Answer:** 128.3 MiB (or 134481400 bytes according to logs)

#### 2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv`
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

**Answer:** green_tripdata_2020-04.csv

No explanation needed, I think. Also the filename in the previous question's run logs agrees.

#### 3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- 13,537.299
- 24,648,499
- 18,324,219
- 29,430,127

**Answer:** 24,648,499

#### 4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- 5,327,301
- 936,199
- 1,734,051
- 1,342,034

**Answer:** 1,734,051

#### 5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

**Answer:** 1,925,152

#### 6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  

**Answer:** Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration

Source: https://kestra.io/plugins/core/trigger/io.kestra.plugin.core.trigger.schedule#properties_timezone-body
