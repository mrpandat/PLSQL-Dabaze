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
    id serial not null primary key
);
CREATE TABLE town(
    id serial not null primary key
);
CREATE TABLE station(
    id serial not null primary key
);
CREATE TABLE line(
    id serial not null primary key
);
CREATE TABLE transport(
    id serial not null primary key
);
CREATE TABLE journey(
    id serial not null primary key
);
CREATE TABLE customer(
    id serial not null primary key
);
CREATE TABLE billing(
    id serial not null primary key
);
CREATE TABLE employee(
    id serial not null primary key
);
CREATE TABLE contract(
    id serial not null primary key
);
CREATE TABLE service(
    id serial not null primary key
);
CREATE TABLE subscription(
    id serial not null primary key
);
CREATE TABLE subscription_status(
    id serial not null primary key
);
CREATE TABLE offer(
    id serial not null primary key
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