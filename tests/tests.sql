Create or replace function 
    test_expression() RETURNS boolean
AS $$
declare
a boolean;
begin

raise notice '-----------------------------------';
raise notice '|          THRESHOLD 1            |';
raise notice '-----------------------------------';
if (
        (select add_transport_type('TMW','tramway',100,2)) AND
        (select add_transport_type('BUS','bus',50,4)) AND
        (select add_transport_type('RER','train',350,5)) AND
        (select add_transport_type('MTR','metro',300,3))
    ) then
    raise notice '********** TESTS 1 OK **********';
else
    raise notice '********* TESTS 1 FAIL *********';
end if;

if(
    (select add_zone('zone_1',100)) AND
    (select add_zone('zone_2',40.5)) AND
    (select add_zone('zone_3',52.7)) AND
    (select add_zone('zone_4',42.5)) AND
    (select add_zone('zone_5',78.3))
) then
    raise notice '********** TESTS 2 OK **********';
else
    raise notice '********* TESTS 2 FAIL *********';
end if;

if(
(select add_station(1, 'Chateau de Vincennes', 'Vincennes', 2, 'MTR')) AND
(select add_station(2, 'Berault', 'Vincennes', 2, 'MTR')) AND
(select add_station(3, 'Saint-mandé', 'Vincennes', 2, 'MTR'))
) then
    raise notice '********** TESTS 3 OK **********';
else
    raise notice '********* TESTS 3 FAIL *********';
end if;


if(
(select add_station(4, 'Avron', 'Paris', 1, 'MTR')) AND
(select add_station(5, 'Alexandre Dumas', 'Paris', 1, 'MTR')) AND
(select add_station(6, 'Père Lachaise', 'Paris', 1, 'MTR'))
) then
    raise notice '********** TESTS 4 OK **********';
else
    raise notice '********* TESTS 4 FAIL *********';
end if;


if(
(select add_station(7, 'Saint-maur', 'Saint-Maur', 5, 'RER')) AND
(select add_station(8, 'Joinville', 'Joinville', 4, 'RER')) AND
(select add_station(9, 'Nogent sur marne', 'Nogent', 3, 'RER')) AND
(select add_station(10, 'Fontenay sous bois', 'Fontenay', 3, 'RER')) AND
(select add_station(11, 'Porte d italie', 'Villejuif', 2, 'RER'))
) then
    raise notice '********** TESTS 5 OK **********';
else
    raise notice '********* TESTS 5 FAIL *********';
end if;

if (
(select add_line('RRA','RER')) AND
(select add_line('MT1','MTR')) AND
(select add_line('MT2','MTR'))
) then
    raise notice '********** TESTS 6 OK **********';
else
    raise notice '********* TESTS 6 FAIL *********';
end if;

if(
(select add_station_to_line(1, 'MT1',1)) AND
(select add_station_to_line(2, 'MT1',2)) AND
(select add_station_to_line(3, 'MT1',3))
) then
    raise notice '********** TESTS 7 OK **********';
else
    raise notice '********* TESTS 7 FAIL *********';
end if;

if (
(select add_station_to_line(4, 'MT2',1)) AND
(select add_station_to_line(5, 'MT2',2)) AND
(select add_station_to_line(6, 'MT2',3))
) then
    raise notice '********** TESTS 8 OK **********';
else
    raise notice '********* TESTS 8 FAIL *********';
end if;

if (
(select add_station_to_line(7, 'RRA',1)) AND
(select add_station_to_line(8, 'RRA',2)) AND
(select add_station_to_line(9, 'RRA',3)) AND
(select add_station_to_line(10, 'RRA',4)) AND
(select add_station_to_line(11, 'RRA',5))
) then
    raise notice '********** TESTS 9 OK **********';
else
    raise notice '********* TESTS 9 FAIL *********';
end if;

if (
((select get_price_station(1)) = 40.5) AND
((select get_price_station(9)) = 52.7) AND
((select get_price_station(8)) = 42.5) AND
((select get_price_station(7)) = 78.3)
) then
    raise notice '********* TESTS 10  OK *********';
else
    raise notice '******** TESTS 10 FAIL ********';
end if;

if (
((select get_cost_travel(1,2)) = 40.5) AND
((select get_cost_travel(1,4)) = 140.5) AND
((select get_cost_travel(6,7)) = 314) AND
((select get_cost_travel(8,9)) = 95.2)
) then
    raise notice '********* TESTS 11  OK *********';
else
    raise notice '********* TESTS 11 FAIL ********';
end if;

raise notice '-----------------------------------';
raise notice '|          THRESHOLD 2            |';
raise notice '-----------------------------------';
if (
(select add_person('Valeera', 'Siffeh', 'v.siffeh@hotmail.fr', '0600000000','23 avenue galilée', 'Champigny', '94200')) AND
(select add_person('Jaina', 'Ouisarde', 'j.ouisarde@outlook.fr', '0611111111','12 boulevard perroquet', 'Vincennes', '94500')) AND
(select add_person('Uther', 'Pahladain', 'u.pah@hotmail.fr', '0622222222','1 impasse galilée', 'Saint maur', '94100')) AND
(select add_person('Anduin', 'Prieste', 'anduinlecho94@gmail.com', '0733333333','3bis rue dark', 'Vincennes', '94500')) AND
(select add_person('Rexxar', 'Eunte', 'r.eunte@hotmail.fr', '0744444444','7 avenue de gaule', 'Joinville', '94200')) 
) then
    raise notice '********** TESTS 12 OK *********';
else
    raise notice '********* TESTS 12 FAIL ********';
end if;

if (
(select add_offer('AAAAA','Imagine r', 300, 12, 1,5)) AND
(select add_offer('AAAAA','La copieuse', 300, 12, 1,5)) = false AND
(select add_offer('BBBBB','Offre pigeon', 1000, 1, 1,2)) AND
(select add_offer('CCCCC','Offre généreuse', 10, 24, 1,4))
) then
    raise notice '********** TESTS 13 OK *********';
else
    raise notice '********* TESTS 13 FAIL ********';
end if;


return true; 
end; $$ language plpgsql;

select test_expression();
