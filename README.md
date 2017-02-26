# dw-project

## 1 - Operational data sources inspection and proling

To import the data I wrote the initDb.sh script.

The script streamlines the database initialization process and solves the following error I have encountered:

- the database "student" may not exist in postgres. If it does not exist, it is created.

- some CSV files contained some empty lines that gave errors when imported by Postgres. The empty lines are therefore removed

- the EOLs of the CVS files were CTRLF. This may be a problem on the linux server. I coverted the EOLS of the files to LF. 

- the AdventureworksDb.sql file imports the files using the space as a separator, while the values in the CSV files are separated by Tabs. I fixed the sql script. 

## 2 - Conceptual design

I decided to analysize one fact: Sales.

I started the process by analysing the ER schema (AdventureWorkdsDbDiagram) and then I decided dimensions ad measures for the fact.

### Sale Fact

The Sale Fact most interesting measures are quantity, unit price and revenue.

The most interesting dimension root I've found are Product, Customer, City and Date, Salesperson, Currency and Ship-method.


#### Dimensions

Here I present an overview of the dimensions of the Sale fact:

- product
    - subcategory
        - category
- ship-method
- currency
- salesperson
    - territory
        - country
- customer
     - store
         - salesperson
             - territory
                 - country
- city
    - province
        - country
- date
    - month
        - year

Customer and Salesperson share part of the dimension hierarchy.
The same happens with SalesPerson, customer and city that share the country attribute.

---
##### Dynamicity

Product and its categorization may be dynamic. There may be a change in how a product is classified but this should happen quite unfrequently.

SalesPerson may move to a different territory and I expect this to be something to be careful about. I consider instead unlikely that a territory is assigned to a different country.

Customer may move to a different store quite often and the store may be assigned to a different salesperson.

City, province and country are dimensions that I expect to have only a small chanceto change.

Date is fixed.

### Workload

I present here a list of logical queries:

#### q1

The sum of all revenues for the year 2013 for the product category "Bikes"

Sale[category = 'Bikes', year=2013].revenue

#### q2

The list of the sums of all revenues for all the years divided by product category

Sale[category, year].revenue

#### q3

The list of all products of X category that generated a revenue greater than 200 during the week before Christmas of 2012 in the UK

Sale[date>=18/12/2012 AND date<=25/12/2012, revenue> 200, country='UK'].product

#### q4

The list of all cities where the product 'Mountain-200 Silver, 42' has been sold at least 5 times in the same date in 2013

Sale[product='Mountain-200 Silver, 42', date, year=2013, quantity>=5].city

#### q5

The average revenue in 2011 for all the currencies

Sale[currency, year = 2011].revenue

##### Assumptions

- I assume that the sales.salesorderdetail.unitprice is the unit price *before* the discount (sales.salesorderdetail.unitpricediscount) application.

- When considering the measure "revenue" I always mean the actual revenue value converted in USD.

- As for the dimension "city", attribute city-name is  "city-name, state-province" due to the ambiguity name we have with the city name only. I assume there can be no two cities with the same name inside the same province.