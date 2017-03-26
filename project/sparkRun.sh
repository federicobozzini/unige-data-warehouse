#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CP=/opt/spark-2.0.1-bin-hadoop2.7/jars/spark-core_2.11-2.0.1.jar:/opt/spark-2.0.1-bin-hadoop2.7/jars/spark-sql_2.11-2.0.1.jar:/opt/spark-2.0.1-bin-hadoop2.7/jars/spark-hive_2.11-2.0.1.jar:/opt/spark-2.0.1-bin-hadoop2.7/jars/scala-library-2.11.8.jar:/opt/spark-2.0.1-bin-hadoop2.7/jars/spark-catalyst_2.11-2.0.1.jar

DRIVERS=/home/student/postgresql-9.4.1212.jre6.jar

cd $DIR

 javac -cp $CP SparkQueries.java && jar cf sparkqueries.jar . && spark-submit --driver-class-path $DRIVERS --jars $DRIVERS --class SparkQueries sparkqueries.jar