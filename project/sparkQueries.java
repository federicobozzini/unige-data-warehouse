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
import static org.apache.spark.sql.functions.sum;
import static org.apache.spark.sql.functions.round;


public class SparkQueries {

    private static SparkSession spark;
    public static void main(String[] args) throws Exception {
        
        spark = SparkSession
        .builder()
        .appName("Java Spark Hive Example")
        .getOrCreate();

        spark.sparkContext().setLogLevel("ERROR");
        
        Dataset<Row> saleDF = loadDataframe("sale");
        Dataset<Row> saleCategoryYearDF = loadDataframe("salebyyearandcategory");
        Dataset<Row> saleCountryDF = loadDataframe("salebycountry");
        Dataset<Row> categoryDF = loadDataframe("category");
        Dataset<Row> yearDF = loadDataframe("year");
        Dataset<Row> productDF = loadDataframe("product");
        Dataset<Row> countryDF = loadDataframe("country");
        Dataset<Row> dateDF = loadDataframe("datet");
        Dataset<Row> cityDF = loadDataframe("city");
        Dataset<Row> currencyDF = loadDataframe("currency");
        Dataset<Row> shipmethodDF = loadDataframe("shipmethod");
        Dataset<Row> customerDF = loadDataframe("customer");
        Dataset<Row> salespersonDF = loadDataframe("salesperson");
        
        Dataset<Row> q1 = saleCategoryYearDF
            .join(categoryDF, "categoryId")
            .join(yearDF, "yearId")
            .filter("year=2013 AND category='Bikes'")
            .agg(round(sum(col("revenue")), 2).as("totrevenue"));

        Dataset<Row> q2 = saleCategoryYearDF
            .join(categoryDF, "categoryId")
            .join(yearDF, "yearId")
            .groupBy(col("category"), col("year"))
            .agg(round(sum(col("revenue")), 2).as("totrevenue"))
            .sort(col("category"), col("year"));

        Dataset<Row> q3 = saleCountryDF
            .join(dateDF, "dateId")
            .join(countryDF, "countryId")
            .join(productDF, "productId")
            .filter(col("country.name").equalTo("United Kingdom"))
            .filter(col("datet.datets").between("2012-12-18", "2012-12-25"))
            .groupBy(col("product.exid"), col("product.name"))
            .agg(round(sum(col("revenue")), 2).as("totrevenue"))
            .where(col("totrevenue").geq(1500))
            .select(col("product.exid"), col("product.name"));

        Dataset<Row> q4 = saleDF
            .join(cityDF, "cityId")
            .join(countryDF, "countryId")
            .join(productDF, "productId")
            .join(dateDF, "dateId")
            .join(yearDF, "yearId")
            .filter("year=2013 AND product.name='Mountain-200 Silver, 42'")
            .groupBy(col("datet.datets"), col("city.name"))
            .agg(sum(col("quantity")).as("numsold"))
            .where(col("numsold").geq(8))
            .sort(col("city.name"))
            .select(col("city.name")).as("city")
            .distinct();

        Dataset<Row> q5 = saleCountryDF
            .join(currencyDF, "currencyId")
            .join(productDF, "productId")
            .join(dateDF, "dateId")
            .join(yearDF, "yearId")
            .groupBy(col("currencycode"), col("year"))
            .agg(round(sum(col("revenue")), 2).as("totrevenue"))
            .sort(col("currencycode"), col("year"));

        Dataset<Row> q6 = saleCountryDF
            .join(countryDF, "countryId")
            .join(shipmethodDF, "shipmethodId")
            .groupBy(col("country.name"), col("shipmethod.name"))
            .agg(sum(col("quantity")).as("numsold"))
            .sort(col("country.name"), col("shipmethod.name"));

        Dataset<Row> q7 = saleCategoryYearDF
            .join(categoryDF, "categoryId")
            .join(yearDF, "yearId")
            .join(customerDF, "customerId")
            .join(salespersonDF, "salespersonId")
            .filter("salesperson.name <> 'no salesperson' AND category='Bikes'")
            .groupBy(col("year"), col("salesperson.name"))
            .agg(sum(col("quantity")).as("bikesold"))
            .sort(col("year"), col("bikesold").desc());

        Dataset<Row> q8 = saleCategoryYearDF
            .join(cityDF, "cityId")
            .join(countryDF, "countryId")
            .join(categoryDF, "categoryId")
            .join(yearDF, "yearId")
            .join(customerDF, "customerId")
            .filter("customer.store <> 'no store' AND category='Bikes'")
            .groupBy(col("year"), col("customer.store"))
            .agg(sum(col("quantity")).as("bikesold"))
            .where("bikesold >= 200")
            .sort(col("year"), col("bikesold").desc());

        Dataset<Row> q9 = saleCategoryYearDF
            .join(cityDF, "cityId")
            .join(countryDF, "countryId")
            .join(categoryDF, "categoryId")
            .join(customerDF, "customerId")
            .filter("customer.store <> 'no store' AND category='Bikes'")
            .groupBy(col("customer.store"))
            .agg(sum(col("quantity")).as("bikesold"))
            .where("bikesold >= 200")
            .sort(col("bikesold").desc());

        
        System.out.println("q1");
        q1.show();
        System.out.println("q2");
        q2.show();
        System.out.println("q3");
        q3.show();
        System.out.println("q4");
        q4.show();
        System.out.println("q5");
        q5.show();
        System.out.println("q6");
        q6.show();
        System.out.println("q7");
        q7.show();
        System.out.println("q8");
        q8.show();
        System.out.println("q9");
        q9.show();
        
    };

    private static Dataset<Row> loadDataframe(String tableName) {
        return spark.read()
            .format("jdbc")
            .option("url", "jdbc:postgresql:Adventureworks")
            .option("dbtable", "rolap." + tableName)
            .option("user", "student")
            .option("password", "foobar")
            .load()
            .as(tableName);
    };
};
