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
get_or_create_zipcode(
        _code varchar(5)
) returns int
AS $$
declare
_zipcode_id int := (select id from zipcode where zipcode.code = _code);
begin
        if _zipcode_id is NULL then
                insert into zipcode(code) values (_code);
        end if;
        _zipcode_id := (select id from zipcode where zipcode.code = _code);
        return _zipcode_id;
        EXCEPTION
                WHEN others THEN
                        RETURN false;
end; $$ language plpgsql;



Create or replace function 
add_person (
	_firstname VARCHAR (32) , _lastname VARCHAR (32) , _email VARCHAR (128) , 
	_phone VARCHAR (10) , _address TEXT , _town VARCHAR (32) ,
	_zipcode VARCHAR (5))
 RETURNS BOOLEAN 
AS $$
declare
	a int :=(select get_or_create_town(_town));
	b int :=(select get_or_create_zipcode(_zipcode));
	c int :=(select id_zipcode from town_zipcode where town_zipcode.id_zipcode = a);
	d int;
begin
	if c is NULL then
		insert into town_zipcode(id_town,id_zipcode)
		values (a,b);
	end if;
	d := (select id from town_zipcode where town_zipcode.id_zipcode = b and town_zipcode.id_town = a);
	insert into customer(firstname, lastname, email, phone, address, town_zipcode_id)
	values (_firstname, _lastname, _email, _phone, _address, d);
	return true;
end; $$ language plpgsql;



/****
Create or replace function 

AS $$ begin

EXCEPTION
    WHEN others THEN
        RETURN false;
end; $$ language plpgsql;
**/
