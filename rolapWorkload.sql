-- q1 - Sale[year=2013, category='Bikes'].revenue

select sum(s.revenue)
from rolap.salebyyearandcategory s
join rolap.year y on s.yearid = y.yearid
join rolap.category c on s.categoryid = c.categoryid
where y.year = 2013
and c.category = 'Bikes';


-- q2 - Sale[category, year].revenue

select c.category,
    y.year,
    sum(s.revenue)
from rolap.salebyyearandcategory s
join rolap.year y on s.yearid = y.yearid
join rolap.category c on s.categoryid = c.categoryid
group by c.category, y.year
order by c.category, y.year;


-- q3 - Sale[date>=18/12/2012 AND date<=25/12/2012, revenue>=1500, country='United Kingdom'].product

select p.exid as productid, p.name as product
from rolap.salebycountry s
join rolap.product p on s.productid = p.productid
join rolap.country c on s.countryid = c.countryid
join rolap.date d on s.dateid = d.dateid
where c.name = 'United Kingdom'
and d.date between ('2012-12-25'::date - '1 week'::interval) and '2012-12-25'::date
group by p.exid, p.name
having sum(s.revenue) >= 1500;


-- q4 Sale[product='Mountain-200 Silver, 42', date, year=2013, quantity>=5].city

select d.date, c.name as city
from rolap.sale s
join rolap.product p on s.productid = p.productid
join rolap.date d on s.dateid = d.dateid
join rolap.year y on d.yearid = y.yearid
join rolap.city c on s.cityid = c.cityid
where p.name = 'Mountain-200 Silver, 42'
and year = 2013
group by d.date, c.name
having sum(s.quantity) >= 5;


-- q5 Sales[currency, year].revenue

select c.currencycode, y.year, sum(revenue)
from rolap.sale s
join rolap.date d on s.dateid = d.dateid
join rolap.year y on d.yearid = y.yearid
join rolap.currency c on s.currencyid = c.currencyid
group by c.currencycode, y.year;


-- q6 Sale[country, ship-method].quantity

select c.name as country, sm.name as shipmethod, sum(quantity)
from rolap.salebycountry s
join rolap.country c on s.countryid = c.countryid
join rolap.shipmethod sm on s.shipmethodid = sm.shipmethodid
group by c.name, sm.name
order by c.name, sm.name;


-- q7 Sale[year, sales-person, category='Bikes'].quantity

select y.year as year,
    sp.name as fullname,
    sum(s.revenue) as bikesold
from rolap.salebyyearandcategory s
join rolap.year y on s.yearid = y.yearid
join rolap.category c on s.categoryid = c.categoryid
join rolap.customer cu on s.customerid = cu.customerid
join rolap.salesperson sp on cu.salespersonid = sp.salespersonid
where sp.name <> 'no salesperson'
group by y.year, fullname
order by y.year, bikesold desc;


-- q8 Sale[year, store, category='Bikes', quantity>=200].quantity

select y.year as year,
    cu.store as store,
    sum(s.quantity) as bikesold
from rolap.salebyyearandcategory s
join rolap.year y on s.yearid = y.yearid
join rolap.category c on s.categoryid = c.categoryid
join rolap.customer cu on s.customerid = cu.customerid
where cu.store <> 'no store'
and c.category = 'Bikes'
group by y.year, store
having sum(quantity) >= 200
order by y.year, bikesold desc;


-- q9 Sale[store, category='Bikes', quantity>=200].quantity

select cu.store as store,
    sum(s.quantity) as bikesold
from rolap.salebyyearandcategory s
join rolap.category c on s.categoryid = c.categoryid
join rolap.customer cu on s.customerid = cu.customerid
where cu.store <> 'no store'
and c.category = 'Bikes'
group by store
having sum(quantity) >= 200
order by bikesold desc;
