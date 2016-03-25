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
	tid int :=(select get_or_create_town(_town));
	zid int :=(select get_or_create_zipcode(_zipcode));

	tzid int:= (select id from town_zipcode where town_zipcode.id_zipcode = zid and town_zipcode.id_town = tid);
begin
	
    if tzid is NULL then
		insert into town_zipcode(id_town,id_zipcode)
		values (tid,zid);
	end if;
	tzid := (select id from town_zipcode where town_zipcode.id_zipcode = zid and town_zipcode.id_town = tid);
	

    insert into customer(firstname, lastname, email, phone, address, town_zipcode_id)
	values (_firstname, _lastname, _email, _phone, _address, tzid);
	return true;
    EXCEPTION
        WHEN others THEN
            RETURN false;
end; $$ language plpgsql;


Create or replace function 
add_offer(
_code VARCHAR(5), _name VARCHAR(32), _price FLOAT,
_nb_month INT, zone_from INT, zone_to INT)
RETURNS BOOLEAN
AS $$ begin
    if _nb_month <= 0
     OR (select id from zone where zone.id = zone_from) is null 
     OR (select id from zone where zone.id = zone_to) is null
    then
        return false;
    end if;
    insert into offer(code,name, price, duration, zone_from_id, zone_to_id)
    values (_code, _name, _price, _nb_month, zone_from, zone_to);
    return true;
EXCEPTION
    WHEN others THEN
        RETURN false;

end; $$ language plpgsql;


create or replace function 
add_subscription(_num INT, _email VARCHAR(128), _code VARCHAR(5), _date_sub DATE)
 RETURNS BOOLEAN
as $$ 
declare
    user_id int := (select id from customer where _email = customer.email);
    offer_id int := (select id from offer where _code = offer.code);
begin
    if user_id is null then
        return false;
    end if;    
    return true;
exception
    when others then
        return false;
end; $$ language plpgsql;

/****
create or replace function 

as $$ begin

exception
    when others then
        return false;
end; $$ language plpgsql;
**/
