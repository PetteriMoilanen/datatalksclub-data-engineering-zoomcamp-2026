# Solutions to Module 2 homework - Kestra stuff

## Things I've done:

- Created [my own version of the Kestra flow](module2_gc_setup.yaml) to create the GC bucket and BQ dataset and another to delete them. The service account credentials are handled with Kestra secrets as described [here.](https://kestra.io/docs/how-to-guides/google-credentials)
- Created [my own version of the Kestra flow](module2_taxi_ELT.yaml) for taxi data ELT for a single year and month.

## Questions and answers:

#### 1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

**Answer:** 