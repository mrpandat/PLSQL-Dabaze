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
	station int,
	line varchar(3),
	pos int
) returns boolean
AS $$ begin
/* revoir la table station_line */
EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql;


/****
Create or replace function 

AS $$ begin

EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql;










**/
