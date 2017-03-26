package exercise0SparkSql;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import java.util.Arrays;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.apache.spark.api.java.function.MapFunction;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Encoders;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import static org.apache.spark.sql.functions.col;


public class SparkSql {
    public static void main(String[] args) throws Exception {
        
        String warehouseLocation = "/user/hive/warehouse";
        SparkSession spark = SparkSession
        .builder()
        .appName("Java Spark Hive Example")
        .config("spark.sql.warehouse.dir", warehouseLocation)
        .enableHiveSupport()
        .getOrCreate();
        
        // not used, kept as example
        Dataset<Row> jdbcDF = spark.read()
        .format("jdbc")
        .option("url", "jdbc:postgresql:Adventureworks")
        .option("dbtable", "rolap.sale")
        .option("user", "student")
        .option("password", "foobar")
        .load();
        
        Dataset<Row> ordersDF = spark.read()
        .format("csv")
        .option("header", "true")
        .option("schemaInfer","true")
        .option("nullValue", "")
        .csv("./exercise0SparkSql/GlobalSuperstoreOrders2016.csv");
        
        Dataset<Row> ass1 = ordersDF.filter(col("Order Priority").equalTo("High"));
        Dataset<Row> ass2 = ordersDF.filter(col("Order Date").between("2014-11-01", "2015-02-28"));
        Dataset<Row> ass3 = ass2.sort(col("Profit").desc()).limit(5);

        ass1.show();
        ass2.show();
        ass3.show();
        
    };
};
