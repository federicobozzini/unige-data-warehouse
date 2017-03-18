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
