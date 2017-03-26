import java.util.Map;
import java.util.LinkedHashMap;

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

        Map<String, Dataset<Row>> results = new LinkedHashMap<String, Dataset<Row>>();
        
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

        results.put("q1", q1);

        Dataset<Row> q2 = saleCategoryYearDF
            .join(categoryDF, "categoryId")
            .join(yearDF, "yearId")
            .groupBy(col("category"), col("year"))
            .agg(round(sum(col("revenue")), 2).as("totrevenue"))
            .sort(col("category"), col("year"));

        results.put("q2", q2);

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

        results.put("q3", q3);

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

        results.put("q4", q4);

        Dataset<Row> q5 = saleCountryDF
            .join(currencyDF, "currencyId")
            .join(productDF, "productId")
            .join(dateDF, "dateId")
            .join(yearDF, "yearId")
            .groupBy(col("currencycode"), col("year"))
            .agg(round(sum(col("revenue")), 2).as("totrevenue"))
            .sort(col("currencycode"), col("year"));

        results.put("q5", q5);

        Dataset<Row> q6 = saleCountryDF
            .join(countryDF, "countryId")
            .join(shipmethodDF, "shipmethodId")
            .groupBy(col("country.name"), col("shipmethod.name"))
            .agg(sum(col("quantity")).as("numsold"))
            .sort(col("country.name"), col("shipmethod.name"));

        results.put("q6", q6);

        Dataset<Row> q7 = saleCategoryYearDF
            .join(categoryDF, "categoryId")
            .join(yearDF, "yearId")
            .join(customerDF, "customerId")
            .join(salespersonDF, "salespersonId")
            .filter("salesperson.name <> 'no salesperson' AND category='Bikes'")
            .groupBy(col("year"), col("salesperson.name"))
            .agg(sum(col("quantity")).as("bikesold"))
            .sort(col("year"), col("bikesold").desc());

        results.put("q7", q7);

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

        results.put("q8", q8);

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

        results.put("q9", q9);

        results.forEach((k,v) -> {
            System.out.println(k);
            v.show();
        });
        
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
