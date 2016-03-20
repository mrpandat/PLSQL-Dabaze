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
add_station(
	id int,
	name varchar(64),
	town varchar(32),
	zone int,
	type varchar(3)
)
AS $$ begin
_
EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql


/****
Create or replace function 

AS $$ begin

EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql

**/
