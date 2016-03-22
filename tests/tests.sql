select add_transport_type('TMW','tramway',100,2);
select add_transport_type('BUS','bus',50,4);
select add_transport_type('RER','train',500,5);
select add_transport_type('MTR','metro',300,3);


select add_zone('zone_1',100);
select add_zone('zone_2',40.5);
select add_zone('zone_3',52.7);
select add_zone('zone_4',42.5);
select add_zone('zone_5',78.3);

select add_station(1, 'Chateau de Vincennes', 'Vincennes', 1, 'MTR');
select add_station(2, 'Berault', 'Vincennes', 1, 'MTR');
select add_station(3, 'Saint-mandé', 'Vincennes', 1, 'MTR');

select add_line('RRA','RER');
select add_line('MT1','MTR');
select add_line('MT2','MTR');
