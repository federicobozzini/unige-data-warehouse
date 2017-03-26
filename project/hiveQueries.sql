-- q1 - Sale[year=2013, category='Bikes'].revenue

select sum(s.revenue)
from salebyyearandcategory s
join year y on s.yearid = y.yearid
join category c on s.categoryid = c.categoryid
where y.year = 2013
and c.category = 'Bikes';


-- q2 - Sale[category, year].revenue

select c.category,
    y.year,
    round(sum(s.revenue),2)
from salebyyearandcategory s
join year y on s.yearid = y.yearid
join category c on s.categoryid = c.categoryid
group by c.category, y.year
order by c.category, y.year;


-- q3 - Sale[date>=18/12/2012 AND date<=25/12/2012, revenue>=1500, country='United Kingdom'].product

select p.exid as productid, p.name as product
from salebycountry s
join product p on s.productid = p.productid
join country c on s.countryid = c.countryid
join datet d on s.dateid = d.dateid
where c.name = 'United Kingdom'
and d.datets >= cast(to_date(from_unixtime(unix_timestamp('2012-12-18', 'yyyy-MM-dd'))) as date)
and d.datets <= cast(to_date(from_unixtime(unix_timestamp('2012-12-25', 'yyyy-MM-dd'))) as date)
group by p.exid, p.name
having sum(s.revenue) >= 1500;


-- q4 Sale[product='Mountain-200 Silver, 42', date, year=2013, quantity>=5].city

select distinct city
from (
    select c.name as city
    from sale s
    join product p on s.productid = p.productid
    join datet d on s.dateid = d.dateid
    join year y on d.yearid = y.yearid
    join city c on s.cityid = c.cityid
    where p.name = 'Mountain-200 Silver, 42'
    and year = 2013
    group by d.datets, c.name
    having sum(s.quantity) >= 8
    order by city
) tmp;


-- q5 Sales[currency, year].revenue

select c.currencycode, y.year, round(sum(revenue),2)
from salebycountry s
join datet d on s.dateid = d.dateid
join year y on d.yearid = y.yearid
join currency c on s.currencyid = c.currencyid
group by c.currencycode, y.year;


-- q6 Sale[country, ship-method].quantity

select c.name as country, sm.name as shipmethod, sum(quantity)
from salebycountry s
join country c on s.countryid = c.countryid
join shipmethod sm on s.shipmethodid = sm.shipmethodid
group by c.name, sm.name
order by c.name, sm.name;


-- q7 Sale[year, sales-person, category='Bikes'].quantity

select y.year as year,
    sp.name as fullname,
    sum(s.quantity) as bikesold
from salebyyearandcategory s
join year y on s.yearid = y.yearid
join category c on s.categoryid = c.categoryid
join customer cu on s.customerid = cu.customerid
join salesperson sp on cu.salespersonid = sp.salespersonid
where sp.name <> 'no salesperson'
and c.category = 'Bikes'
group by year, sp.name
order by year, bikesold desc;


-- q8 Sale[year, store, category='Bikes', quantity>=200].quantity

select y.year as year,
    cu.store as store,
    sum(s.quantity) as bikesold
from salebyyearandcategory s
join year y on s.yearid = y.yearid
join category c on s.categoryid = c.categoryid
join customer cu on s.customerid = cu.customerid
where cu.store <> 'no store'
and c.category = 'Bikes'
group by year, store
having sum(quantity) >= 200
order by year, bikesold desc;


-- q9 Sale[store, category='Bikes', quantity>=200].quantity

select cu.store as store,
    sum(s.quantity) as bikesold
from salebyyearandcategory s
join category c on s.categoryid = c.categoryid
join customer cu on s.customerid = cu.customerid
where cu.store <> 'no store'
and c.category = 'Bikes'
group by store
having sum(quantity) >= 200
order by bikesold desc;


-- q10 -- 

select tmp.country as country, 
    tmp.shipmethod as shipmethod,
    round(100.0 * sum(sumquantity) over (partition by tmp.country, tmp.shipmethod)/ sum(sumquantity) over (partition by tmp.country), 2) 
from (
    select c.name as country, 
        sm.name as shipmethod,
        sum(s.quantity) as sumquantity
    from salebycountry s
    join country c on s.countryid = c.countryid
    join shipmethod sm on s.shipmethodid = sm.shipmethodid
    group by c.name, sm.name
    order by c.name, sm.name
    ) tmp
order by country, shipmethod;


-- q11 --

select store, 
    revenue as revenue,
    round(revenue - avg(revenue) over (), 2) as surplus, 
    rank() over (order by revenue desc)
from (
    select cu.store as store, sum(revenue) as revenue
    from salebyyearandcategory s
    join customer cu on s.customerid = cu.customerid
    where cu.store <> 'no store'
    group by cu.store
) tmp
limit 5;


-- q12 --

select year, salesperson, revenue, partialtot
from (
    select y.year, 
        salesperson, 
        round(sum(revenue), 2) as revenue,
        round(sum(sum(revenue)) over (partition by salesperson order by sp.totrevenue desc, year rows unbounded preceding), 2) as partialtot,
        totrevenue
    from salebyyearandcategory s
    join year y on y.yearid = s.yearid
    join customer cu on s.customerid = cu.customerid
    join (
        select sp.salespersonid, sp.name as salesperson, sum(revenue) as totrevenue
        from salebyyearandcategory s2
        join customer cu2 on s2.customerid = cu2.customerid
        join salesperson sp on cu2.salespersonid = sp.salespersonid
        where sp.name <> 'no salesperson'
        group by sp.salespersonid, sp.name
        order by totrevenue desc
        limit 3
    )  sp on cu.salespersonid = sp.salespersonid
    group by y.year, salesperson, totrevenue
    order by totrevenue desc, year
) tmp;


-- q13 --

select d.month, 
    city, 
    sum(revenue) as revenue,
    round(sum(sum(revenue)) over (partition by city order by totrevenue desc, d.month rows 3 preceding), 2) as totrevenue
from sale s
join datet d on s.dateid = d.dateid
join (
    select c2.cityid, c2.name as city, sum(revenue) as totrevenue
    from salebyyearandcategory s2
    join city c2 on s2.cityid = c2.cityid
    where c2.name <> 'no city'
    group by c2.cityid, c2.name
    order by totrevenue desc
    limit 1
)  c on s.cityid = c.cityid
group by d.month, city, totrevenue
order by month;

-- q14 -- 

select year, round(sum(revenue),2) as totrevenue
from salebycountry s 
join country c on s.countryid = c.countryid
join datet d on s.dateid = d.dateid
join year y on d.yearid = y.yearid
where c.name = 'United States'
group by year
order by totrevenue desc
limit 1;


-- q15 --

select year, round(avg(bikesold), 0) as avgbikesold
from (
    select cu.store as store, 
        year as year,
        sum(quantity) as bikesold
    from salebyyearandcategory s
    join customer cu on s.customerid = cu.customerid
    join city ci on s.cityid = ci.cityid
    join country co on co.countryid = ci.countryid
    join year y on s.yearid = y.yearid
    join category c on s.categoryid = c.categoryid
    where co.name = 'United States'
    and c.category = 'Bikes'
    and cu.store <> 'no store'
    group by cu.store, year
) tmp
group by year
order by year;

-- q16 --

select year, store, bikesold
from (
    select year, 
        store, 
        rank() over (partition by year order by bikesold desc) as position,
        bikesold
    from (
        select cu.store as store, 
            year as year,
            sum(quantity) as bikesold
        from salebyyearandcategory s
        join customer cu on s.customerid = cu.customerid
        join year y on s.yearid = y.yearid
        join category c on s.categoryid = c.categoryid
        and c.category = 'Bikes'
        and cu.store <> 'no store'
        group by cu.store, year
    ) tmp2
) tmp
where position = 1
order by year;


-- q17 --

select tmp.country, tmp.totrevenue
from (
    select country, 
    totrevenue, 
    percentile_approx(totrevenue, 0.5) over () as median
    from (
        select name as country, sum(revenue) as totrevenue
        from salebycountry s
        join country c on s.countryid = c.countryid
        group by name
    ) tmp2
) tmp
where tmp.totrevenue > median; 


-- q18 --

select year, product, quantitysold
from (
    select year, 
        product, 
        rank() over (partition by year order by quantitysold desc) as position,
        quantitysold
    from (
        select p.name as product, 
            year as year,
            sum(quantity) as quantitysold
        from salebycountry s
        join datet d on s.dateid = d.dateid
        join year y on d.yearid = y.yearid
        join product p on s.productid = p.productid
        join category c on p.categoryid = c.categoryid
        and c.category = 'Bikes'
        group by p.name, year
    ) tmp2
) tmp
where position <= 3
order by year, quantitysold desc;
