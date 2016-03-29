DROP TABLE IF EXISTS subscription CASCADE;
DROP TABLE IF EXISTS journey CASCADE;
DROP TABLE IF EXISTS station_line CASCADE;
DROP TABLE IF EXISTS station CASCADE;
DROP TABLE IF EXISTS line CASCADE;
DROP TABLE IF EXISTS transport CASCADE;
DROP TABLE IF EXISTS billing CASCADE;
DROP TABLE IF EXISTS contract CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS town_zipcode CASCADE;
DROP TABLE IF EXISTS town CASCADE;
DROP TABLE IF EXISTS offer CASCADE;
DROP TABLE IF EXISTS zone CASCADE;
DROP TABLE IF EXISTS zipcode CASCADE;
DROP TABLE IF EXISTS service CASCADE;
DROP TABLE IF EXISTS subscription_status CASCADE;

CREATE TABLE transport (
  id           SERIAL      NOT NULL PRIMARY KEY,
  name         VARCHAR(32) NOT NULL,
  capacity     INT         NOT NULL,
  avg_interval INT         NOT NULL,
  code         VARCHAR(3) UNIQUE
);

CREATE TABLE line (
  id           SERIAL  NOT NULL PRIMARY KEY,
  code         CHAR(3) NOT NULL UNIQUE,
  transport_id SERIAL REFERENCES transport (id)
);

CREATE TABLE town (
  id   SERIAL      NOT NULL PRIMARY KEY,
  name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE zone (
  id    SERIAL NOT NULL PRIMARY KEY,
  price FLOAT,
  name  VARCHAR(32) UNIQUE
);

CREATE TABLE station (
  id           INT         NOT NULL PRIMARY KEY,
  name         VARCHAR(64) NOT NULL UNIQUE,
  transport_id SERIAL REFERENCES transport (id),
  town_id      SERIAL REFERENCES town (id),
  zone_id      SERIAL REFERENCES zone (id)
);

CREATE TABLE zipcode (
  id   SERIAL NOT NULL PRIMARY KEY,
  code VARCHAR(5)
);

CREATE TABLE town_zipcode (
  id         SERIAL NOT NULL PRIMARY KEY,
  id_town    SERIAL REFERENCES town (id),
  id_zipcode SERIAL REFERENCES zipcode (id),
  UNIQUE (id_town, id_zipcode)
);


CREATE TABLE customer (
  id              SERIAL       NOT NULL PRIMARY KEY,
  firstname       VARCHAR(32)  NOT NULL,
  lastname        VARCHAR(32)  NOT NULL,
  email           VARCHAR(128) NOT NULL UNIQUE,
  phone           CHAR(10)     NOT NULL UNIQUE,
  address         TEXT         NOT NULL,
  town_zipcode_id SERIAL REFERENCES town_zipcode (id)
);

CREATE TABLE journey (
  id               SERIAL NOT NULL PRIMARY KEY,
  begining         DATE   NOT NULL,
  ending           DATE   NOT NULL,
  start_station_id SERIAL REFERENCES station (id),
  end_station_id   SERIAL REFERENCES station (id),
  customer_id      SERIAL REFERENCES customer (id)
);

CREATE TABLE billing (
  id          SERIAL  NOT NULL PRIMARY KEY,
  price       INT     NOT NULL,
  month       INT     NOT NULL,
  year        INT     NOT NULL,
  paid        BOOLEAN NOT NULL,
  customer_id SERIAL REFERENCES customer (id)
);


CREATE TABLE employee (
  id          SERIAL  NOT NULL PRIMARY KEY,
  login       VARCHAR(8) NOT NULL UNIQUE,
  customer_id SERIAL REFERENCES customer (id)
);

CREATE TABLE service (
  id       SERIAL NOT NULL PRIMARY KEY,
  name     VARCHAR(32) UNIQUE,
  discount INT
);


CREATE TABLE contract (
  id          SERIAL NOT NULL PRIMARY KEY,
  hire_date   DATE   NOT NULL,
  end_date   DATE,
  employee_id SERIAL REFERENCES employee (id),
  service_id  SERIAL REFERENCES service (id)
);


CREATE TABLE offer (
  id           SERIAL      NOT NULL PRIMARY KEY,
  code         VARCHAR(5)  NOT NULL UNIQUE,
  name         VARCHAR(32) NOT NULL,
  price        FLOAT       NOT NULL,
  duration     INT         NOT NULL,
  zone_to_id   SERIAL REFERENCES zone (id),
  zone_from_id SERIAL REFERENCES zone (id)
);

/*
CREATE TABLE subscription_status(
    id serial not null primary key,
    name varchar(32) unique not null
);
*/
CREATE TABLE subscription (
  id          SERIAL NOT NULL PRIMARY KEY,
  begin       DATE   NOT NULL,
  number      INT    NOT NULL UNIQUE,
  status      VARCHAR(32),
  customer_id SERIAL REFERENCES customer (id),
  offer_id    SERIAL REFERENCES offer (id)
);


CREATE TABLE station_line (
  id         SERIAL NOT NULL PRIMARY KEY,
  id_station SERIAL REFERENCES station (id),
  id_line    SERIAL REFERENCES line (id),
  position   INT    NOT NULL,
  UNIQUE (position, id_line)
);

