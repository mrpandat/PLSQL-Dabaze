select add_transport_type('TMW','tramway',100,2);
select add_transport_type('BUS','bus',50,4);
select add_transport_type('RER','train',350,5);
select add_transport_type('MTR','metro',300,3);


select add_zone('zone_1',100);
select add_zone('zone_2',40.5);
select add_zone('zone_3',52.7);
select add_zone('zone_4',42.5);
select add_zone('zone_5',78.3);

select add_station(1, 'Chateau de Vincennes', 'Vincennes', 2, 'MTR');
select add_station(2, 'Berault', 'Vincennes', 2, 'MTR');
select add_station(3, 'Saint-mandé', 'Vincennes', 2, 'MTR');

select add_station(4, 'Avron', 'Paris', 1, 'MTR');
select add_station(5, 'Alexandre Dumas', 'Paris', 1, 'MTR');
select add_station(6, 'Père Lachaise', 'Paris', 1, 'MTR');


select add_station(7, 'Saint-maur', 'Saint-Maur', 5, 'RER');
select add_station(8, 'Joinville', 'Joinville', 4, 'RER');
select add_station(9, 'Nogent sur marne', 'Nogent', 3, 'RER');
select add_station(10, 'Fontenay sous bois', 'Fontenay', 3, 'RER');
select add_station(11, 'Porte d italie', 'Villejuif', 2, 'RER');

select add_line('RRA','RER');
select add_line('MT1','MTR');
select add_line('MT2','MTR');

select add_station_to_line(1, 'MT1',1);
select add_station_to_line(2, 'MT1',2);
select add_station_to_line(3, 'MT1',3);

select add_station_to_line(4, 'MT2',1);
select add_station_to_line(5, 'MT2',2);
select add_station_to_line(6, 'MT2',3);

select add_station_to_line(7, 'RRA',1);
select add_station_to_line(8, 'RRA',2);
select add_station_to_line(9, 'RRA',3);
select add_station_to_line(10, 'RRA',4);
select add_station_to_line(11, 'RRA',5);
