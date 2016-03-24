Create or replace function 
    test_expression() RETURNS boolean
AS $$
begin
if (
        (select add_transport_type('TMW','tramway',100,2)) AND
        (select add_transport_type('BUS','bus',50,4)) AND
        (select add_transport_type('RER','train',350,5)) AND
        (select add_transport_type('MTR','metro',300,3))
    ) then
    raise notice '********** TEST 1 OK **********';
else
    raise notice '********* TEST 1 FAIL *********';
end if;

if(
    (select add_zone('zone_1',100)) AND
    (select add_zone('zone_2',40.5)) AND
    (select add_zone('zone_3',52.7)) AND
    (select add_zone('zone_4',42.5)) AND
    (select add_zone('zone_5',78.3))
) then
    raise notice '********** TEST 2 OK **********';
else
    raise notice '********* TEST 2 FAIL *********';
end if;

if(
(select add_station(1, 'Chateau de Vincennes', 'Vincennes', 2, 'MTR')) AND
(select add_station(2, 'Berault', 'Vincennes', 2, 'MTR')) AND
(select add_station(3, 'Saint-mandé', 'Vincennes', 2, 'MTR'))
) then
    raise notice '********** TEST 3 OK **********';
else
    raise notice '********* TEST 3 FAIL *********';
end if;


if(
(select add_station(4, 'Avron', 'Paris', 1, 'MTR')) AND
(select add_station(5, 'Alexandre Dumas', 'Paris', 1, 'MTR')) AND
(select add_station(6, 'Père Lachaise', 'Paris', 1, 'MTR'))
) then
    raise notice '********** TEST 4 OK **********';
else
    raise notice '********* TEST 4 FAIL *********';
end if;


if(
(select add_station(7, 'Saint-maur', 'Saint-Maur', 5, 'RER')) AND
(select add_station(8, 'Joinville', 'Joinville', 4, 'RER')) AND
(select add_station(9, 'Nogent sur marne', 'Nogent', 3, 'RER')) AND
(select add_station(10, 'Fontenay sous bois', 'Fontenay', 3, 'RER')) AND
(select add_station(11, 'Porte d italie', 'Villejuif', 2, 'RER'))
) then
    raise notice '********** TEST 5 OK **********';
else
    raise notice '********* TEST 5 FAIL *********';
end if;

if (
(select add_line('RRA','RER')) AND
(select add_line('MT1','MTR')) AND
(select add_line('MT2','MTR'))
) then
    raise notice '********** TEST 6 OK **********';
else
    raise notice '********* TEST 6 FAIL *********';
end if;

if(
(select add_station_to_line(1, 'MT1',1)) AND
(select add_station_to_line(2, 'MT1',2)) AND
(select add_station_to_line(3, 'MT1',3))
) then
    raise notice '********** TEST 7 OK **********';
else
    raise notice '********* TEST 7 FAIL *********';
end if;

if (
(select add_station_to_line(4, 'MT2',1)) AND
(select add_station_to_line(5, 'MT2',2)) AND
(select add_station_to_line(6, 'MT2',3))
) then
    raise notice '********** TEST 8 OK **********';
else
    raise notice '********* TEST 8 FAIL *********';
end if;

if (
(select add_station_to_line(7, 'RRA',1)) AND
(select add_station_to_line(8, 'RRA',2)) AND
(select add_station_to_line(9, 'RRA',3)) AND
(select add_station_to_line(10, 'RRA',4)) AND
(select add_station_to_line(11, 'RRA',5))
) then
    raise notice '********** TEST 9 OK **********';
else
    raise notice '********* TEST 9 FAIL *********';
end if;

return true; 
EXCEPTION
     WHEN others THEN
         RETURN false;
end; $$ language plpgsql;

select test_expression();
