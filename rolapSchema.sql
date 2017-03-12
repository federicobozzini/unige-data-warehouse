drop schema if exists rolap cascade;

create schema rolap
    create table year (
        yearid serial,
        year int,
        primary key (yearid)
    )
    create table date (
        dateid serial,
        date timestamp,
        month varchar(20),
        yearid int,
        holiday boolean,
        primary key (dateid),
        foreign key (yearid) references year (yearid)
    )
    create table category (
        categoryid serial,
        category varchar(100),
        exid int,
        primary key (categoryid)
    )
    -- 'from' field renamed 'fromts', since 'from' is sql keyword -- 
    -- 'to' field renamed 'tots', since 'to' is not is valid column name --
    create table product (
        productid serial,
        name varchar(100),
        subcategory varchar(100),
        categoryid int,
        fromts timestamp,
        tots timestamp,
        master int,
        exid int,
        primary key (productid),
        foreign key (master) references product (productid),
        foreign key (categoryid) references category (categoryid)
    )
    create table currency (
        currencyid serial,
        currencycode char(3),
        name varchar(100),
        primary key (currencyid)
    )
    create table shipmethod (
        shipmethodid serial,
        name varchar(100),
        exid int,
        primary key (shipmethodid)
    )
    create table country (
        countryid serial,
        name varchar(100),
        exid varchar(100),
        primary key (countryid)
    )
    create table city (
        cityid serial,
        name varchar(100),
        province varchar(100),
        countryid int,
        primary key (cityid),
        foreign key (countryid) references country (countryid)
    )
    create table salesperson (
        salespersonid serial,
        name varchar(100),
        primary key (salespersonid),
        territory varchar(100),
        countryid int,
        exid int,
        foreign key (countryid) references country (countryid)
    )
    create table customer (
        customerid serial,
        name varchar(100),
        store varchar(100),
        salespersonid int,
        exid int,
        primary key (customerid),
        foreign key (salespersonid) references salesperson (salespersonid)
    )
    create table sale (
        dateid int,
        customerid int,
        currencyid int,
        shipmethodid int,
        productid int,
        cityid int,
        quantity int,
        price numeric,
        revenue numeric,
        foreign key (dateid) references date (dateid),
        foreign key (customerid) references customer (customerid),
        foreign key (currencyid) references currency (currencyid),
        foreign key (shipmethodid) references shipmethod (shipmethodid),
        foreign key (productid) references product (productid),
        foreign key (cityid) references city (cityid)
    )