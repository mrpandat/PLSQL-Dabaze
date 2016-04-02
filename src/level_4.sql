CREATE OR REPLACE FUNCTION
  add_journey(
  _email         VARCHAR(128),
  _time_start    TIMESTAMP,
  _time_end      TIMESTAMP,
  _station_start INT,
  _station_end   INT)
  RETURNS BOOLEAN
AS $$
DECLARE
  jid INT := (SELECT journey.id
              FROM journey
                JOIN customer ON journey.customer_id = customer.id
              WHERE customer.email = _email AND _time_start BETWEEN journey.begining AND journey.ending);
  cid INT := (SELECT id
              FROM customer
              WHERE _email = customer.email);
BEGIN
  IF jid IS NOT NULL OR extract(DAY FROM _time_start - _time_end) != 0
  THEN
    RETURN FALSE;
  END IF;

  INSERT INTO journey (begining, ending, start_station_id, end_station_id, customer_id)
  VALUES (_time_start, _time_end, _station_start, _station_end, cid);
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE ;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  get_journeys_price(month INT, year INT, offer INT)
  RETURNS FLOAT
AS $$ BEGIN

  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  get_offer_price(month INT, year INT, _email VARCHAR(64))
  RETURNS FLOAT
AS $$
DECLARE
  a INT := (SELECT
              /*customer.email,
              offer.name,
              concat(extract(YEAR FROM subscription.begin), extract(MONTH FROM subscription.begin)),
              subscription.status, */ CASE WHEN employee.login IS NULL
      THEN
        offer.price
                          WHEN employee.login IS NOT NULL
                                          THEN
                                            (offer.price * (100 - service.discount)) / 100
                          END
            FROM customer
              JOIN subscription ON customer.id = subscription.customer_id
              JOIN offer ON subscription.offer_id = offer.id
              JOIN employee ON customer.id = employee.customer_id
              JOIN contract ON employee.id = contract.employee_id
              JOIN service ON contract.service_id = service.id
            WHERE customer.email = _email);
BEGIN
  return a;
END; $$ LANGUAGE plpgsql;
