Create or replace function 
add_transport_type(
	code VARCHAR(3),
	name VARCHAR(32),
	capacity INT,
	avg_interval INT)
RETURNS BOOLEAN AS $$ begin

	insert into transport(code, name, capacity, avg_interval)
	values(code, name, capacity, avg_interval);

return true;

EXCEPTION
    WHEN others THEN
        RETURN false;
end;$$ language plpgsql;

Create or replace function 
add_zone(
	name VARCHAR(32),
	price FLOAT)
returns boolean

AS $$ begin

	insert into zone(price, name)
	values(price, name);

	return true;
	EXCEPTION
		WHEN others THEN
        		RETURN false;

end; $$ language plpgsql;

Create or replace function
get_or_create_town( 
	_name varchar(32)
) returns int
AS $$ 
declare
town_id int := (select id from town where town.name = _name);
begin
	if town_id is NULL then
		insert into town(name) values (_name);
	end if;
	town_id := (select id from town where town.name = _name);
	return town_id;
	EXCEPTION
    		WHEN others THEN
        		RETURN false;
end; $$ language plpgsql;


Create or replace function 
add_station(
	_id int,
	_name varchar(64),
	_town varchar(32),
	_zone int,
	_type varchar(3)
) returns boolean 
AS $$
declare
town_id int := (select get_or_create_town(_town));
type_id int := (select id from transport where transport.code = _type);
begin
	insert into station(id,town_id, zone_id, name, transport_id)
	values(_id,town_id,_zone,_name,type_id);
	return true;

	EXCEPTION
    		WHEN others THEN
        		RETURN false;

end; $$ language plpgsql;


Create or replace function 
add_line(
	_code varchar(3),
	_type varchar(3)
) returns boolean
AS $$ 
declare
	_transport_id int := (select id from transport where transport.code = _type);
begin
	insert into line(transport_id, code)
	values(_transport_id, _code);
	return true;

EXCEPTION
    WHEN others THEN
        RETURN false;

end; $$ language plpgsql;

Create or replace function 
add_station_to_line(
	_station int,
	_line varchar(3),
	_pos int
) returns boolean
AS $$ 
declare
    line_id int := (select id from line where line.code = _line);
begin
    insert into station_line(id_station, id_line, position)
    values(_station, line_id, _pos);
    return true;

EXCEPTION
    WHEN others THEN
        RETURN false;

end; $$ language plpgsql;

Create or replace view view_transport_50_300_users as
select name as transport from transport where capacity between 50 and 300 order by name;

Create or replace view view_stations_from_villejuif as
select station.name from station join town on town.id = station.town_id where lower(town.name) = 'villejuif' order by station.name;

Create or replace view view_stations_zones as
select station.name as station, zone.name as zone from station join zone on station.zone_id = zone.id order by zone.id, station.name;

Create or replace view view_nb_station_type as
select transport.name as type, count(*) as stations from station join transport on station.transport_id = transport.id join zone on station.zone_id = zone.id group by transport.name order by stations DESC, type;

Create or replace view view_line_duration as
select transport.name as type, id_line as line, sum(transport.avg_interval) as minutes from station_line join station on station_line.id_station = station.id join transport on transport.id = station.transport_id group by id_line, transport.name order by type, line;

Create or replace view view_a_station_capacity as 
select station.name as station,transport.capacity as capacity from station join transport on station.transport_id = transport.id where lower(SUBSTRING(station.name, 1, 1))='a' order by station.name, capacity;


Create or replace function 
list_station_in_line(
    _line_code VARCHAR(3)
) returns setof VARCHAR(64)
AS $$ begin

    return QUERY(
        select station.name from station_line 
        join station on station_line.id_station = station.id 
        join line on station_line.id_line = line.id 
        where line.code = _line_code
        order by position ASC
    );
end; $$ language plpgsql;


Create or replace function 
list_types_in_zone(_zone INT)
RETURNS setof VARCHAR(32)
AS $$ begin
    return QUERY(select distinct transport.name from station join transport on station.transport_id = transport.id join zone on station.zone_id = zone.id where zone.id = _zone order by transport.name
);
end; $$ language plpgsql;

Create or replace function 
get_price_station(_station int)
returns float
AS $$ 
declare 
    a float := (select price from station join zone on zone.id = station.zone_id where station.id = _station);
begin
    if (a is not null) then
        return a;
    else
        return 0;
    end if;
EXCEPTION
    WHEN others THEN
        RETURN 0;
end; $$ language plpgsql;

Create or replace function 
get_cost_travel(station_start INT,station_end INT)
RETURNS FLOAT
AS $$
declare
  a float := (select get_price_station(station_start));
  b float := (select get_price_station(station_end));
begin
    if (a = 0 OR b = 0) then
        return 0;
    else
        return a+b;
    end if;
EXCEPTION
    WHEN others THEN
        RETURN 0;
end; $$ language plpgsql;


/****
Create or replace function 

AS $$ begin

EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql;
**/
