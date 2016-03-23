

/* sure */

drop table if exists subscription cascade;
drop table if exists journey cascade;
drop table if exists station_line cascade;
drop table if exists station cascade;
drop table if exists line cascade;
drop table if exists transport cascade;
drop table if exists billing cascade;
drop table if exists contract cascade;
drop table if exists employee cascade;
drop table if exists customer cascade;
drop table if exists town_zipcode cascade;
drop table if exists town cascade;
drop table if exists offer cascade;
drop table if exists zone cascade;

drop table if exists zipcode cascade;
drop table if exists service cascade;
drop table if exists subscription_status cascade;



CREATE TABLE transport(
    id serial not null primary key,
    name varchar(32) not null,
    capacity int not null,
    avg_interval int not null,
    code varchar(3) unique
);

CREATE TABLE line(
    id serial not null primary key,
    code char(3) not null unique,
    transport_id serial references transport(id)
);

CREATE TABLE town(
    id serial not null primary key,
    name varchar(64) not null unique
);

CREATE TABLE zone(
    id serial not null primary key,
    price float,
    name varchar(32) unique
);

CREATE TABLE station(
    id int not null primary key,
    name varchar(64) not null unique,
    transport_id serial references transport(id),
    town_id serial references town(id),
    zone_id serial references zone(id)
);

CREATE TABLE customer(
    id serial not null primary key,
    firstname varchar(32) not null,
    lastname varchar(32) not null,
    email varchar(128) not null,
    phone char(10) not null,
    town_id serial references town(id)
);

CREATE TABLE journey(
    id serial not null primary key,
    begining date not null,
    ending date not null,
    start_station_id serial references station(id),
    end_station_id serial references station(id),
    customer_id serial references customer(id)
);

CREATE TABLE billing(
    id serial not null primary key,
    price int not null,
    month int not null,
    year int not null,
    paid boolean not null,
    customer_id serial references customer(id)
);

CREATE TABLE zipcode(
    id int not null primary key
);

CREATE TABLE town_zipcode(
    id serial not null primary key,
    id_town serial references town(id),
    id_zipcode serial references zipcode(id)
);

CREATE TABLE employee(
    id serial not null primary key,
    login char(8) not null unique,
    customer_id serial references customer(id)
);

CREATE TABLE service(
    id serial not null primary key,
    name varchar(32) unique,
    discount int
);


CREATE TABLE contract(
    id serial not null primary key,
    departure date,
    hire_date date not null,
    employee_id serial references employee(id),
    service_id serial references service(id)
);


CREATE TABLE offer(
    id serial not null primary key,
    code char(5),
    name varchar(32),
    price int,
    duration int,
    highest_zone_id serial references zone(id),
    lowest_zone_id serial references zone(id)
);

CREATE TABLE subscription_status(
    id serial not null primary key,
    name varchar(32) unique
);

CREATE TABLE subscription(
    id serial not null primary key,
    begin date,
    status_id serial references subscription_status(id),
    customer_id serial references customer(id),
    offer_id serial references offer(id)
);


CREATE TABLE station_line(
    id serial not null primary key,
    id_station serial references station(id),
    id_line serial references line(id),
    position int,
    unique(position, id_line)
);

