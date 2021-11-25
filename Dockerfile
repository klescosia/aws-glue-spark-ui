FROM amazonlinux:2
FROM amazoncorretto:8
FROM maven:3.6-amazoncorretto-8

RUN yum install -y procps

WORKDIR /tmp/
ADD pom.xml /tmp
RUN curl -o ./spark-2.4.3-bin-without-hadoop.tgz https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-without-hadoop.tgz
RUN tar -xzf spark-2.4.3-bin-without-hadoop.tgz && \
    mv spark-2.4.3-bin-without-hadoop /opt/spark && \
    rm spark-2.4.3-bin-without-hadoop.tgz
RUN mvn dependency:copy-dependencies -DoutputDirectory=/opt/spark/jars/
RUN rm /opt/spark/jars/servlet-api-2.5.jar && \
    rm /opt/spark/jars/jsr305-1.3.9.jar && \
    rm /opt/spark/jars/jersey-*-1.9.jar

RUN echo $'\n\
spark.eventLog.enabled true\n\
spark.history.ui.port 18080\n\
' > /opt/spark/conf/spark-defaults.conf

ENV SPARK_NO_DAEMONIZE TRUE
ENTRYPOINT ["/bin/bash", "-c"]:

# docker run -it -e SPARK_HISTORY_OPTS="-Dspark.history.fs.logDirectory=s3a://delta-lake-ia-test/spark_ui/ -Dspark.hadoop.fs.s3a.access.key=aws_access_key_id -Dspark.hadoop.fs.s3a.secret.key=aws_secret_access_key" -p 18080:18080 glue/sparkui:latest "/opt/spark/bin/spark-class org.apache.spark.deploy.history.HistoryServer"