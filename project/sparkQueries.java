import java.util.Map;
import java.util.LinkedHashMap;

import org.apache.spark.api.java.function.MapFunction;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Encoders;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.Column;
import org.apache.spark.sql.SparkSession;
import static org.apache.spark.sql.functions.col;
import static org.apache.spark.sql.functions.sum;
import static org.apache.spark.sql.functions.avg;
import static org.apache.spark.sql.functions.round;
import static org.apache.spark.sql.functions.rank; 
import static org.apache.spark.sql.functions.date_format;
import org.apache.spark.sql.expressions.Window;
import org.apache.spark.sql.expressions.WindowSpec;
import java.lang.Long;


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
            .agg(sum(col("quantity")).as("numshipped"))
            .sort(col("country.name"), col("shipmethod.name"))
            .select(col("country.name").as("country"), col("shipmethod.name").as("shipmethod"), col("numshipped"));

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


        WindowSpec emptyWindow = Window.partitionBy();

        WindowSpec q10w1 = Window.partitionBy("country", "shipmethod");
        WindowSpec q10w2 = Window.partitionBy("country");
        Column percentage = round(sum("numshipped").over(q10w1).divide(sum("numshipped").over(q10w2)).multiply(100),2).as("percentage");
        Dataset<Row> q10 = q6
            .sort("country", "shipmethod")
            .select(col("country"), col("shipmethod"), percentage);

        results.put("q10", q10);


        Dataset<Row> q11tmp = saleCategoryYearDF
            .join(customerDF, "customerId")
            .filter("customer.store <> 'no store'")
            .groupBy("store")
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .select("store", "totrevenue")
            .sort(col("totrevenue").desc());
        Column surplus = round(col("totrevenue").minus(avg("totrevenue").over(emptyWindow)), 2).as("surplus");
        WindowSpec q11w = Window.orderBy(col("totrevenue").desc());
        Column storeRank = rank().over(q11w).as("storeRank");
        Dataset<Row> q11 = q11tmp
            .select(col("store"), col("totrevenue"), surplus, storeRank)
            .limit(5);

        results.put("q11", q11);


        Dataset<Row> q12tmp = saleCategoryYearDF
            .join(customerDF, "customerid")
            .join(salespersonDF, "salespersonid")
            .filter("salesperson.name <> 'no salesperson'")
            .groupBy("salesperson.name", "salespersonid")
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .sort(col("totrevenue").desc())
            .select(col("salesperson.name").as("salesperson"), col("salespersonid"), col("totrevenue"))
            .limit(3);
        WindowSpec q12w = Window.partitionBy("salesperson").orderBy(col("totrevenue").desc(), col("year")).rowsBetween(Long.MIN_VALUE, 0);
        Dataset<Row> q12 = q12tmp
            .join(customerDF, "salespersonid")
            .join(saleCategoryYearDF, "customerid")
            .join(yearDF, "yearId")
            .groupBy("year", "salesperson", "totrevenue")
            .agg(round(sum("revenue"),2).as("yearrevenue"), round(sum(sum("revenue")).over(q12w),2).as("partialtot"))
            .sort(col("totrevenue").desc(), col("year"));

        results.put("q12", q12);


        Dataset<Row> q13tmp = saleCategoryYearDF
            .join(cityDF, "cityid")
            .filter("city.name <> 'no city'")
            .groupBy("cityid", "city.name")
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .sort(col("totrevenue").desc())
            .select(col("cityid"), col("city.name").as("city"), col("totrevenue"))
            .limit(1);
        WindowSpec q13w = Window.partitionBy("city").orderBy(col("totrevenue").desc(), col("month")).rowsBetween(-3, 0);
        Dataset<Row> q13 = q13tmp
            .join(saleDF, "cityid")
            .join(dateDF, "dateid")
            .groupBy("month", "city", "totrevenue")
            .agg(round(sum("revenue"),2).as("monthlyrevenue"), round(sum(sum("revenue")).over(q13w),2).as("partialtot"))
            .sort("month")
            .select("month", "city", "monthlyrevenue", "partialtot");

        results.put("q13", q13);


        Dataset<Row> q14 = saleCountryDF
            .join(dateDF, "dateid")
            .join(yearDF, "yearId")
            .join(countryDF, "countryId")
            .filter("country.name == 'United States'")
            .groupBy("year")
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .sort(col("totrevenue").desc())
            .select("year", "totrevenue")
            .limit(1);

        results.put("q14", q14);


        Dataset<Row> q15 = saleCategoryYearDF
            .join(yearDF, "yearId")
            .join(cityDF, "cityid")
            .join(countryDF, "countryid")
            .join(customerDF, "customerid")
            .join(categoryDF, "categoryid")
            .filter("country.name == 'United States' and customer.store <> 'no store' and category='Bikes'")
            .groupBy("store", "year")
            .agg(round(sum("quantity"),2).as("bikesold"))
            .groupBy("year")
            .agg(round(avg("bikesold"),0).as("avgbikesold"))
            .sort("year");

        results.put("q15", q15);


        WindowSpec q16w = Window.partitionBy("year").orderBy(col("bikesold").desc());
        Dataset<Row> q16 = saleCategoryYearDF
            .join(yearDF, "yearId")
            .join(customerDF, "customerid")
            .join(categoryDF, "categoryid")
            .filter("customer.store <> 'no store' and category='Bikes'")
            .groupBy("store", "year")
            .agg(round(sum("quantity"),2).as("bikesold"))
            .groupBy("year", "store", "bikesold")
            .agg(rank().over(q16w).as("position"))
            .filter("position = 1")
            .sort("year")
            .select("year", "store", "bikesold");

        results.put("q16", q16);

        
        WindowSpec q17w = Window.partitionBy("year").orderBy(col("bikesold").desc());
        Dataset<Row> q17tmp = saleCountryDF
            .join(countryDF, "countryid")
            .groupBy("name")
            .agg(round(sum("revenue"),2).as("totrevenue"));
        double[] quantiles = {0.5};
        Double median = q17tmp.stat().approxQuantile("totrevenue", quantiles, 0)[0];
        Dataset<Row> q17 = q17tmp
            .filter(col("totrevenue").geq(median));

        results.put("q17", q17);
        

        WindowSpec q18w = Window.partitionBy("year").orderBy(col("bikesold").desc());
        Dataset<Row> q18 = saleCountryDF
            .join(countryDF, "countryid")
            .join(dateDF, "dateid")
            .join(yearDF, "yearId")
            .join(productDF, "productid")
            .join(categoryDF, "categoryid")
            .filter("category='Bikes'")
            .groupBy("product.name", "year")
            .agg(sum(col("quantity")).as("bikesold"))
            .groupBy("year", "product.name", "bikesold")
            .agg(rank().over(q18w).as("position"))
            .filter("position <= 3")
            .sort(col("year"), col("bikesold").desc())
            .select(col("year"), col("product.name").as("product"), col("bikesold"));

        results.put("q18", q18);


        WindowSpec q19w = Window.partitionBy("country.name").orderBy(col("totrevenue").desc());
        Dataset<Row> q19 = saleCountryDF
            .join(countryDF, "countryid")
            .join(dateDF, "dateid")
            .groupBy("country.name", "datet.datets")
            .agg(round(sum(col("revenue")),2).as("totrevenue"))
            .groupBy("country.name", "datet.datets", "totrevenue")
            .agg(rank().over(q19w).as("position"))
            .filter("position <= 3")
            .sort("country.name", "position");

        results.put("q19", q19);


        WindowSpec q20w = Window.partitionBy("dayofweek");
        Dataset<Row> q20 = saleCountryDF
            .join(countryDF, "countryid")
            .join(dateDF, "dateid")
            .groupBy(date_format(col("datet.datets"), "u").as("dayofweeknum"), date_format(col("datet.datets"), "E").as("dayofweek"))
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .groupBy("dayofweek", "dayofweeknum", "totrevenue")
            .agg(round(sum("totrevenue").over(q20w).divide(sum("totrevenue").over(emptyWindow)).multiply(100),2).as("percentage"))
            .sort("dayofweeknum")
            .select("dayofweek", "percentage");

        results.put("q20", q20);


        Dataset<Row> q21 = saleCategoryYearDF
            .join(cityDF, "cityid")
            .groupBy("city.name")
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .sort(col("totrevenue").desc())
            .limit(5);

        results.put("q21", q21);


        WindowSpec q22w = Window.partitionBy("category").orderBy(col("totrevenue").desc());
        Dataset<Row> q22 = saleCountryDF
            .join(productDF, "productid")
            .join(categoryDF, "categoryid")
            .groupBy(col("product.name").as("product"), col("category.category"))
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .groupBy("category", "product", "totrevenue")
            .agg(rank().over(q22w).as("rank"))
            .filter("rank <= 3");

        results.put("q22", q22);


        WindowSpec q23w1 = Window.partitionBy().orderBy(col("totrevenue").desc());
        WindowSpec q23w2 = Window.partitionBy("store").orderBy(col("totquantity").desc());
        Dataset<Row> q23 = saleDF
            .join(customerDF, "customerid")
            .filter("store <> 'no store'")
            .groupBy("customer.store")
            .agg(round(sum("revenue"),2).as("totrevenue"))
            .groupBy("store", "totrevenue")
            .agg(rank().over(q23w1).as("customer_rank"))
            .filter("customer_rank <= 4")
            .join(customerDF, "store")
            .join(saleDF, "customerid")
            .join(productDF, "productid")
            .groupBy(col("product.name").as("product"), col("store"))
            .agg(sum("quantity").as("totquantity"))
            .groupBy("store", "product", "totquantity")
            .agg(rank().over(q23w2).as("product_rank"))
            .filter("product_rank <= 4");

        results.put("q23", q23);


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
