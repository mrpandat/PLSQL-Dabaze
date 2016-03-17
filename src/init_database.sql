drop table if exists zipcode;
drop table if exists town;
drop table if exists station;
drop table if exists line;
drop table if exists transport;
drop table if exists journey;
drop table if exists customer;
drop table if exists billing;
drop table if exists employee;
drop table if exists contract;
drop table if exists service;
drop table if exists subscription;
drop table if exists subscription_status;
drop table if exists offer;
drop table if exists fare_zone;
drop table if exists station_line;
drop table if exists town_zipcode;

CREATE TABLE zipcode(
    id int not null primary key
);
CREATE TABLE town(
    id serial not null primary key,
    name varchar(64) not null
);
CREATE TABLE station(
    id serial not null primary key,
    name varchar(64) not null
);
CREATE TABLE line(
    id serial not null primary key,
    code char(3) not null
);
CREATE TABLE transport(
    id serial not null primary key,
    name varchar(32) not null,
    max_person int not null,
    duration int not null
);
CREATE TABLE journey(
    id serial not null primary key,
    begining date not null,
    ending date not null
);
CREATE TABLE customer(
    id serial not null primary key,
    firstname varchar(32) not null,
    lastname varchar(32) not null,
    email varchar(128) not null,
    phone char(10) not null
);

CREATE TABLE billing(
    id serial not null primary key,
    price int not null,
    month int not null,
    year int not null,
    paid boolean not null
);

CREATE TABLE employee(
    id serial not null primary key,
    login char(8) not null
);

CREATE TABLE contract(
    id serial not null primary key,
    departure date,
    hire_date date not null
);

CREATE TABLE service(
    id serial not null primary key,
    name varchar(32)
);

CREATE TABLE subscription(
    id serial not null primary key
);

CREATE TABLE subscription_status(
    id serial not null primary key
);
CREATE TABLE offer(
    id serial not null primary key,
    code char(5)
);
CREATE TABLE fare_zone(
    id serial not null primary key
);
CREATE TABLE station_line(
    id serial not null primary key
);
CREATE TABLE town_zipcode(
    id serial not null primary key
);