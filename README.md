Using Spark UI in AWS Glue
---

# Pre-requisites:

1. Install [Docker (Windows)](https://docs.docker.com/desktop/windows/install/)
2. AWS_ACCESS_KEY_ID
3. AWS_SECRET_ACCESS_KEY


# Spark UI

## Build Docker Image

1. Download the `Dockerfile` and `pom.xml`.
2. You'll need your:
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
3. In the directory of the `Dockerfile` and `pom.xml`, run
    `docker build -t glue/sparkui:latest .`

## Start the Spark History Server

1. Run the commands below:
    - Make sure to change the value of the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
    - Make sure to also change the `S3_PATH` (__Note: for the prefix, use `s3a` instead of `s3`__, e.g)
        - s3a://my-bucket/spark-ui

    `docker run -it -e SPARK_HISTORY_OPTS="-Dspark.history.fs.logDirectory=S3_PATH -Dspark.hadoop.fs.s3a.access.key=AWS_ACCESS_KEY_ID -Dspark.hadoop.fs.s3a.secret.key=AWS_SECRET_ACCESS_KEY" -p 18080:18080 glue/sparkui:latest "/opt/spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer"`

## View the Spark UI using your browser

1. Open [http://localhost:18080](http://localhost:18080) in your browser.