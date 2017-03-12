-- currency, insertion --
insert into rolap.currency (currencycode, name)
select currencycode, name 
from sales.currency;


-- year, insertion -- 
insert into rolap.year (year)
select generate_series(
    2001,
    2020
);

-- date, insertion --
insert into rolap.date (date, month, yearid, holiday)
select date as date,
    (extract (month from date) || ' ' || extract (year from date)) as month,
    (
        select yearid 
        from rolap.year
        where year = extract (year from date)
    ) as yearid,
    false as holiday
from (select generate_series(
    '1-1-2001'::date,
    '12-31-2020'::date, '1 day'::interval
) as date) as generator;


-- shipmethod, insertion --
insert into rolap.shipmethod (name, exid)
select name, shipmethodid
from purchasing.shipmethod;

-- country, insertion --
insert into rolap.country (name, exid)
select name, countryregioncode
from person.countryregion
union
select 'no country', null;

--  city, insertion --
insert into rolap.city (name, province, countryid)
select distinct (a.city || ', ' || s.stateprovincecode) as name,
    s.name as province,
    (
        select countryid
        from rolap.country
        where country.exid = s.countryregioncode
    ) as countryid
from person.address a
join person.stateprovince s on a.stateprovinceid = s.stateprovinceid;

--  salesperson, insertion --
insert into rolap.salesperson (name, territory, countryid, exid)
select p.firstname || ' ' || p.lastname,
    t.name,
    (
        select countryid
        from rolap.country
        where country.exid = t.countryregioncode
    ) as countryid,
    s.businessentityid
from sales.salesperson s
join person.person p on s.businessentityid = p.businessentityid
left join sales.salesterritory t on s.territoryid = t.territoryid
union
select 'no salesperson', null, null, null;

-- salesperson, fixing salesperson with no territory associated --
update rolap.salesperson
set territory = 'no territory',
countryid = (
    select countryid
    from rolap.country
    where country.exid is null
    )
where territory is null;

-- customer, insertion --
insert into rolap.customer (name, store, salespersonid, exid)
select p.firstname || ' ' || p.lastname,
    s.name,
    (
        select salespersonid
        from rolap.salesperson
        where salesperson.exid = s.salespersonid
    ) as salespersonid,
    c.customerid
from sales.customer c
left join person.person p on c.customerid = p.businessentityid
left join sales.store s on c.storeid = s.businessentityid;

-- customer, fixing customers with no store associated --
update rolap.customer
set store = 'no store',
salespersonid = (
    select salespersonid
    from rolap.salesperson
    where salesperson.exid is null
    )
where store is null;

-- category, insertion --
insert into rolap.category (category, exid)
select c.name, c.productcategoryid
from production.productcategory c
union 
select 'no category', null;

-- product, insertion --
insert into rolap.product (name, subcategory, fromts, tots, categoryid, exid)
select p.name,
    sc.name,
    now(),
    null,
    (
        select categoryid
        from rolap.category
        where category.exid = sc.productcategoryid
    ) as categoryid,
    p.productid
from production.product p
left join production.productsubcategory sc on p.productsubcategoryid = sc.productsubcategoryid; 

-- product, fixing product with no subcategory subcategory --
update rolap.product
set subcategory = 'no subcategory',
categoryid = (
    select categoryid
    from rolap.category
    where category.exid is null
    )
where subcategory is null;

-- product, set master --
update rolap.product
set master = productid;

-- sale, insertion --
insert into rolap.sale (
    dateid, 
    customerid, 
    currencyid, 
    shipmethodid, 
    productid, 
    cityid, 
    quantity,
    price,
    revenue)
select date.dateid,
    customer.customerid,
    currency.currencyid,
    sm.shipmethodid,
    product.productid,
    city.cityid,
    d.orderqty,
    d.unitprice,
    round(d.unitprice * (1 - d.unitpricediscount) * d.orderqty * coalesce(cu.averagerate, 1),2) as revenue
from sales.salesorderheader h
left join sales.salesorderdetail d on h.salesorderid = d.salesorderid
left join person.address a on h.shiptoaddressid = a.addressid
left join person.stateprovince s on a.stateprovinceid = s.stateprovinceid
left join rolap.shipmethod sm on h.shipmethodid = sm.exid
left join rolap.city city on (a.city || ', ' || s.stateprovincecode) = city.name
left join rolap.date on date.date = h.orderdate
left join rolap.customer customer on h.customerid = customer.exid
left join sales.currencyrate cu on h.currencyrateid = cu.currencyrateid
left join rolap.currency currency on cu.tocurrencycode = currency.currencycode
left join rolap.product product on d.productid = product.exid;

-- sale, fixing missing currencies by using USD --
update rolap.sale
set currencyid = (
    select currencyid
    from rolap.currency
    where currencycode = 'USD'
)
where currencyid is null;
