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
end; $$ language plpgsql
