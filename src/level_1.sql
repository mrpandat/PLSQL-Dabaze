CREATE OR REPLACE FUNCTION
  add_transport_type(
  code         VARCHAR(3),
  name         VARCHAR(32),
  capacity     INT,
  avg_interval INT)
  RETURNS BOOLEAN AS $$ BEGIN
  IF name = ''
  THEN
    RETURN FALSE;
  END IF;
  INSERT INTO transport (code, name, capacity, avg_interval)
  VALUES (code, name, capacity, avg_interval);

  RETURN TRUE;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  add_zone(
  name  VARCHAR(32),
  price FLOAT)
  RETURNS BOOLEAN

AS $$ BEGIN
  price := round(price :: NUMERIC, 2);
  IF price <= 0
  THEN
    RETURN FALSE;
  END IF;
  INSERT INTO zone (price, name)
  VALUES (price, name);

  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;

END; $$ LANGUAGE plpgsql;

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
  add_station(
  _id   INT,
  _name VARCHAR(64),
  _town VARCHAR(32),
  _zone INT,
  _type VARCHAR(3)
)
  RETURNS BOOLEAN
AS $$
DECLARE
  town_id INT := (SELECT get_or_create_town(_town));
  type_id INT := (SELECT id
                  FROM transport
                  WHERE transport.code = _type);
BEGIN
  INSERT INTO station (id, town_id, zone_id, name, transport_id)
  VALUES (_id, town_id, _zone, _name, type_id);
  RETURN TRUE;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;

END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  add_line(
  _code VARCHAR(3),
  _type VARCHAR(3)
)
  RETURNS BOOLEAN
AS $$
DECLARE
  _transport_id INT := (SELECT id
                        FROM transport
                        WHERE transport.code = _type);
BEGIN
  INSERT INTO line (transport_id, code)
  VALUES (_transport_id, _code);
  RETURN TRUE;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;

END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  add_station_to_line(
  _station INT,
  _line    VARCHAR(3),
  _pos     INT
)
  RETURNS BOOLEAN
AS $$
DECLARE
  line_id INT := (SELECT id
                  FROM line
                  WHERE line.code = _line);
BEGIN
  IF _pos <= 0
  THEN
    RETURN FALSE;
  END IF;
  INSERT INTO station_line (id_station, id_line, position)
  VALUES (_station, line_id, _pos);
  RETURN TRUE;

  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;

END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW view_transport_50_300_users AS
  SELECT name AS transport
  FROM transport
  WHERE capacity BETWEEN 50 AND 300
  ORDER BY name;

CREATE OR REPLACE VIEW view_stations_from_villejuif AS
  SELECT station.name
  FROM station
    JOIN town ON town.id = station.town_id
  WHERE lower(town.name) = 'villejuif'
  ORDER BY station.name;

CREATE OR REPLACE VIEW view_stations_zones AS
  SELECT
    station.name AS station,
    zone.name    AS zone
  FROM station
    JOIN zone ON station.zone_id = zone.id
  ORDER BY zone.id, station.name;

CREATE OR REPLACE VIEW view_nb_station_type AS
  SELECT
    transport.name AS type,
    count(*)       AS stations
  FROM station
    JOIN transport ON station.transport_id = transport.id
    JOIN zone ON station.zone_id = zone.id
  GROUP BY transport.name
  ORDER BY stations DESC, type;

CREATE OR REPLACE VIEW view_line_duration AS
  SELECT
    transport.name                                       AS type,
    id_line                                              AS line,
    sum(transport.avg_interval) - transport.avg_interval AS minutes
  FROM line
    LEFT JOIN station_line ON line.id = station_line.id_line
    JOIN station ON station_line.id_station = station.id
    JOIN transport ON transport.id = station.transport_id
  GROUP BY id_line, transport.name, transport.avg_interval
  ORDER BY type, line;

CREATE OR REPLACE VIEW view_a_station_capacity AS
  SELECT
    station.name       AS station,
    transport.capacity AS capacity
  FROM station
    JOIN transport ON station.transport_id = transport.id
  WHERE lower(SUBSTRING(station.name, 1, 1)) = 'a'
  ORDER BY station.name, capacity;


CREATE OR REPLACE FUNCTION
  list_station_in_line(
  _line_code VARCHAR(3)
)
  RETURNS SETOF VARCHAR(64)
AS $$ BEGIN

  RETURN QUERY (
    SELECT station.name
    FROM station_line
      JOIN station ON station_line.id_station = station.id
      JOIN line ON station_line.id_line = line.id
    WHERE line.code = _line_code
    ORDER BY position ASC
  );
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  list_types_in_zone(_zone INT)
  RETURNS SETOF VARCHAR(32)
AS $$ BEGIN
  RETURN QUERY (SELECT DISTINCT transport.name
                FROM station
                  JOIN transport ON station.transport_id = transport.id
                  JOIN zone ON station.zone_id = zone.id
                WHERE zone.id = _zone
                ORDER BY transport.name
  );
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  get_price_station(_station INT)
  RETURNS FLOAT
AS $$
DECLARE
  a FLOAT := (SELECT price
              FROM station
                JOIN zone ON zone.id = station.zone_id
              WHERE station.id = _station);
BEGIN
  IF (a IS NOT NULL)
  THEN
    RETURN a;
  ELSE
    RETURN 0;
  END IF;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  get_cost_travel(station_start INT, station_end INT)
  RETURNS FLOAT
AS $$
DECLARE
  a          FLOAT := (SELECT get_price_station(station_start));
  b          FLOAT := (SELECT get_price_station(station_end));
  zone_s     INT := (SELECT zone_id
                     FROM station
                     WHERE station.id = station_start);
  zone_e     INT := (SELECT zone_id
                     FROM station
                     WHERE station.id = station_end);
  zone_i     INT := 0;
  price      FLOAT := 0;
  price_zone FLOAT := 0;
  zone       INT := 0;
BEGIN
  IF (zone_s > zone_e)
  THEN
    zone_i := zone_e;
    zone_e := zone_s;
    zone_s := zone_i;
  END IF;
  IF (a = 0 OR b = 0)
  THEN
    RETURN 0;
  ELSIF (zone_s = zone_e)
    THEN
      RETURN a;
  END IF;
  FOR price_zone IN
  (SELECT DISTINCT (zone.price)
   FROM station
     JOIN zone ON station.zone_id = zone.id
   WHERE station.zone_id BETWEEN zone_s AND zone_e)
  LOOP
    price := price + price_zone;
  END LOOP;
  RETURN price;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END; $$ LANGUAGE plpgsql;


/****
Create or replace function 

AS $$ begin

EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql;
**/
