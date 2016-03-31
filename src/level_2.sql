CREATE OR REPLACE FUNCTION
  get_or_create_town(
  _name VARCHAR(32)
)
  RETURNS INT
AS $$
DECLARE
  town_id INT := (SELECT id
                  FROM town
                  WHERE town.name = _name);
BEGIN
  IF town_id IS NULL
  THEN
    INSERT INTO town (name) VALUES (_name);
  END IF;
  town_id := (SELECT id
              FROM town
              WHERE town.name = _name);
  RETURN town_id;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  get_or_create_zipcode(
  _code VARCHAR(5)
)
  RETURNS INT
AS $$
DECLARE
  _zipcode_id INT := (SELECT id
                      FROM zipcode
                      WHERE zipcode.code = _code);
BEGIN
  IF _zipcode_id IS NULL
  THEN
    INSERT INTO zipcode (code) VALUES (_code);
  END IF;
  _zipcode_id := (SELECT id
                  FROM zipcode
                  WHERE zipcode.code = _code);
  RETURN _zipcode_id;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  add_person(
  _firstname VARCHAR(32), _lastname VARCHAR(32), _email VARCHAR(128),
  _phone     VARCHAR(10), _address TEXT, _town VARCHAR(32),
  _zipcode   VARCHAR(5))
  RETURNS BOOLEAN
AS $$
DECLARE
  tid  INT :=(SELECT get_or_create_town(_town));
  zid  INT :=(SELECT get_or_create_zipcode(_zipcode));

  tzid INT := (SELECT id
               FROM town_zipcode
               WHERE town_zipcode.id_zipcode = zid AND town_zipcode.id_town = tid);
BEGIN

  IF tzid IS NULL
  THEN
    INSERT INTO town_zipcode (id_town, id_zipcode)
    VALUES (tid, zid);
  END IF;
  tzid := (SELECT id
           FROM town_zipcode
           WHERE town_zipcode.id_zipcode = zid AND town_zipcode.id_town = tid);


  INSERT INTO customer (firstname, lastname, email, phone, address, town_zipcode_id)
  VALUES (_firstname, _lastname, _email, _phone, _address, tzid);
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  add_offer(
  _code     VARCHAR(5), _name VARCHAR(32), _price FLOAT,
  _nb_month INT, zone_from INT, zone_to INT)
  RETURNS BOOLEAN
AS $$ BEGIN
  _price := round(_price::NUMERIC, 2);
  IF _nb_month <= 0
     OR (SELECT id
         FROM zone
         WHERE zone.id = zone_from) IS NULL
     OR (SELECT id
         FROM zone
         WHERE zone.id = zone_to) IS NULL
  THEN
    RETURN FALSE;
  END IF;
  INSERT INTO offer (code, name, price, duration, zone_from_id, zone_to_id)
  VALUES (_code, _name, _price, _nb_month, zone_from, zone_to);
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;

END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  customer_can_subscribe(_email VARCHAR(128))
  RETURNS BOOLEAN
AS $$
BEGIN
  IF (
       SELECT status
       FROM subscription
         JOIN customer ON customer.id = subscription.customer_id
       WHERE customer.email = _email AND (subscription.status = 'Incomplete' OR subscription.status = 'Pending')) IS
     NULL
  THEN
    RETURN TRUE;
  END IF;
  RETURN FALSE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  add_subscription(_num INT, _email VARCHAR(128), _code VARCHAR(5), _date_sub DATE)
  RETURNS BOOLEAN
AS $$
DECLARE
  _user_id  INT := (SELECT id
                    FROM customer
                    WHERE _email = customer.email);
  _offer_id INT := (SELECT id
                    FROM offer
                    WHERE _code = offer.code);
BEGIN
  IF _user_id IS NULL OR _offer_id IS NULL OR (SELECT customer_can_subscribe(_email)) = FALSE
  THEN
    RETURN FALSE;
  END IF;
  INSERT INTO subscription (begin, number, status, customer_id, offer_id)
  VALUES (_date_sub, _num, 'Incomplete', _user_id, _offer_id);
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  update_status(
  _num        INT,
  _new_status VARCHAR(32))
  RETURNS BOOLEAN
AS $$ BEGIN
  IF _new_status != 'Registered' AND _new_status != 'Pending' AND _new_status != 'Incomplete'
  THEN
    RETURN FALSE;
  END IF;
  UPDATE subscription
  SET status = _new_status
  WHERE subscription.number = _num;
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  update_offer_price(_offer_code VARCHAR(5), _price FLOAT)
  RETURNS BOOLEAN
AS $$ BEGIN
  _price := round(_price::NUMERIC, 2);
  IF _price < 0 OR (SELECT code
                    FROM offer
                    WHERE offer.code = _offer_code) IS NULL
  THEN
    RETURN FALSE;
  END IF;
  UPDATE offer
  SET price = _price
  WHERE offer.code = _offer_code;
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW view_user_small_name AS
  SELECT
    lastname,
    firstname
  FROM customer
  WHERE length(lastname) <= 4
  ORDER BY lastname, firstname;

CREATE OR REPLACE VIEW view_user_subscription AS
  SELECT
    concat(customer.lastname, ' ', customer.firstname) AS user,
    offer.name                                         AS offer
  FROM customer
    JOIN subscription ON customer.id = subscription.customer_id
    JOIN offer ON subscription.offer_id = offer.id;

CREATE OR REPLACE VIEW view_unloved_offers AS
  SELECT offer.name AS offer
  FROM offer
    LEFT JOIN subscription ON offer.id = subscription.offer_id
  WHERE subscription.id IS NULL;

CREATE OR REPLACE VIEW view_pending_subscriptions AS
  SELECT
    customer.lastname,
    customer.firstname
  FROM subscription
    JOIN customer ON subscription.customer_id = customer.id
  WHERE subscription.status = 'Pending';

CREATE OR REPLACE VIEW view_old_subscription AS
  SELECT
    customer.lastname,
    customer.firstname,
    offer.name AS subscription,
    subscription.status
  FROM subscription
    JOIN customer ON subscription.customer_id = customer.id
    JOIN offer ON subscription.offer_id = offer.id
  WHERE extract(YEAR FROM age(now(), subscription.begin :: TIMESTAMP)) >= 1;


CREATE OR REPLACE FUNCTION
  list_station_near_user(_user VARCHAR(128))
  RETURNS SETOF VARCHAR(64)
AS $$ BEGIN
  RETURN QUERY (
    SELECT DISTINCT lower(station.name) :: VARCHAR(64) AS station_name
    FROM customer
      JOIN town_zipcode ON customer.town_zipcode_id = town_zipcode.id
      JOIN town ON town_zipcode.id_town = town.id
      JOIN station ON town.id = station.town_id
    WHERE _user = customer.email
    ORDER BY station_name
  );
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  list_subscribers(_code_offer VARCHAR(5))
  RETURNS SETOF VARCHAR(65)
AS $$ BEGIN
  RETURN QUERY (
    SELECT DISTINCT concat(customer.firstname, ' ', customer.lastname) :: VARCHAR(65) AS full_name
    FROM customer
      JOIN subscription ON customer.id = subscription.customer_id
      JOIN offer ON subscription.offer_id = offer.id
    WHERE _code_offer = offer.code
    ORDER BY full_name
  );
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  list_subscription(_email VARCHAR(128), _date DATE)
  RETURNS SETOF VARCHAR(5)
AS $$ BEGIN
  RETURN QUERY (
    SELECT offer.code AS offer_code
    FROM offer
      JOIN subscription ON offer.id = subscription.offer_id
      JOIN customer ON subscription.customer_id = customer.id
    WHERE subscription.status = 'Registered'
          AND customer.email = _email
          AND subscription.begin = _date
    ORDER BY offer.code);
END; $$ LANGUAGE plpgsql;

/****
create or replace function 

as $$ begin

exception
    when others then
        return false;
end; $$ language plpgsql;

**/
