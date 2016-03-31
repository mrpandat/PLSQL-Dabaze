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
  jid int := (SELECT journey.id from journey join customer on journey.customer_id = customer.id
    WHERE customer.email = _email AND _time_start BETWEEN journey.begining AND journey.ending);
  cid int := (SELECT id from customer WHERE _email= customer.email);
BEGIN
  if jid is not null OR extract(day FROM _time_start - _time_end) != 0  THEN
    RETURN false;
  END IF;

  INSERT INTO journey(begining,ending, start_station_id, end_station_id, customer_id)
    VALUES(_time_start, _time_end, _station_start, _station_end, cid);
  return true;

END; $$ LANGUAGE plpgsql;


/****
Create or replace function

AS $$ begin

EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql;
**/