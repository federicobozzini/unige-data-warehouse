-- q1 - Sale[year=2013, category='Bikes'].revenue

select round(sum(d.unitprice * (1 - d.unitpricediscount) * d.orderqty * coalesce(c.averagerate, 1)),2) as revenue
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
where extract(year from h.orderdate) = 2013
and pc.name = 'Bikes';


-- q2 - Sale[category, year].revenue

select pc.name as category,
    extract(year from h.orderdate) as year, 
    round(sum(d.unitprice * (1 - d.unitpricediscount) * d.orderqty * coalesce(c.averagerate, 1)),2) as revenue
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
group by category, year 
order by category, year;


-- q3 - Sale[date>=18/12/2012 AND date<=25/12/2012, revenue>=1500, country='United Kingdom'].product

select distinct p.productid, p.name
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
join sales.salesterritory t on h.territoryid = t.territoryid
join person.countryregion country on country.countryregioncode = t.countryregioncode
where country.name = 'United Kingdom'
and h.orderdate between ('2012-12-25'::date - '1 week'::interval) and '2012-12-25'::date
group by country.countryregioncode, p.productid, p.name
having sum(d.unitprice * (1 - d.unitpricediscount) * d.orderqty * coalesce(c.averagerate, 1)) >= 1500


-- q4 Sale[product='Mountain-200 Silver, 42', date, year=2013, quantity>=5].city

select distinct h.orderdate, (a.city || ', ' || s.stateprovincecode) as city
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
join person.address a on h.shiptoaddressid = a.addressid
join person.stateprovince s on a.stateprovinceid = s.stateprovinceid
where p.name = 'Mountain-200 Silver, 42'
and extract(year from h.orderdate) = 2013
group by city, s.stateprovincecode, h.orderdate
having sum(d.orderqty) >= 5;


-- q5 Sales[currency, year].revenue

select coalesce(c.tocurrencycode, 'USD') as currency, 
    extract(year from h.orderdate) as year,
    round(sum(d.unitprice * (1 - d.unitpricediscount) * d.orderqty * coalesce(c.averagerate, 1)),2)
from sales.salesorderheader h
left join sales.salesorderdetail d on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
group by currency, year
order by currency, year;


-- q6 Sale[country, ship-method].quantity

select country.name as countryname,
    sm.name as shipmethodname,
    sum (d.orderqty) as quantity
from sales.salesorderheader h
left join sales.salesorderdetail d on h.salesorderid = d.salesorderid
join person.address a on h.shiptoaddressid = a.addressid
join person.stateprovince s on a.stateprovinceid = s.stateprovinceid
join purchasing.shipmethod sm on h.shipmethodid = sm.shipmethodid
join person.countryregion country on country.countryregioncode = s.countryregioncode
group by countryname, shipmethodname
order by countryname, shipmethodname;


-- q7 Sale[year, sales-person, category='Bikes'].quantity

select extract(year from h.orderdate) as year, 
    pe.firstname || ' ' || pe.lastname as fullname, 
    sum(d.orderqty) as bikesold
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
right join sales.customer cu on h.customerid = cu.customerid
right join sales.store st on cu.storeid = st.businessentityid
right join sales.salesperson sp on st.salespersonid = sp.businessentityid
right join person.person pe on sp.businessentityid = pe.businessentityid
where pc.name = 'Bikes'
group by year, pe.businessentityid, fullname
order by year, bikesold desc;


-- q8 Sale[year, store, category='Bikes', quantity>=200].quantity

select extract(year from h.orderdate) as year, 
    st.name as name, 
    sum(d.orderqty) as bikesold
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
right join sales.customer cu on h.customerid = cu.customerid
right join sales.store st on cu.storeid = st.businessentityid
right join sales.salesperson sp on st.salespersonid = sp.businessentityid
right join person.person pe on sp.businessentityid = pe.businessentityid
where pc.name = 'Bikes'
group by year, st.businessentityid, st.name
having sum(d.orderqty) >= 200
order by year, bikesold desc;


-- q9 Sale[store, category='Bikes', quantity>=200].quantity

select st.name as name, 
    sum(d.orderqty) as bikesold
from production.product p 
right join sales.salesorderdetail d on p.productid = d.productid 
join sales.salesorderheader h on h.salesorderid = d.salesorderid
left join sales.currencyrate c on h.currencyrateid = c.currencyrateid
left join production.productsubcategory ps on p.productsubcategoryid = ps.productsubcategoryid
left join production.productcategory pc on ps.productcategoryid = pc.productcategoryid
right join sales.customer cu on h.customerid = cu.customerid
right join sales.store st on cu.storeid = st.businessentityid
right join sales.salesperson sp on st.salespersonid = sp.businessentityid
right join person.person pe on sp.businessentityid = pe.businessentityid
where pc.name = 'Bikes'
group by st.businessentityid, st.name
having sum(d.orderqty) >= 200
order by bikesold desc;
