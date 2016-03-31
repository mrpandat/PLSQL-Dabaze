CREATE OR REPLACE FUNCTION
  test_expression()
  RETURNS BOOLEAN
AS $$
DECLARE
  a BOOLEAN;
BEGIN

  RAISE NOTICE '-----------------------------------';
  RAISE NOTICE '|          THRESHOLD 1            |';
  RAISE NOTICE '-----------------------------------';
  IF (
    (SELECT add_transport_type('TMW', 'tramway', 100, 2)) AND
    (SELECT add_transport_type('BUS', 'bus', 50, 4)) AND
    (SELECT add_transport_type('RER', 'train', 350, 5)) AND
    (SELECT add_transport_type('MTR', 'metro', 300, 3)) AND
    (SELECT add_transport_type('LOL', '', 300, 3)) = FALSE
  )
  THEN
    RAISE NOTICE '********** TESTS 1 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 1 FAIL *********';
  END IF;

  IF (
    (SELECT add_zone('zone_1', 100)) AND
    (SELECT add_zone('zone_2', 40.5)) AND
    (SELECT add_zone('zone_3', 52.7)) AND
    (SELECT add_zone('zone_4', 42.5)) AND
    (SELECT add_zone('zone_5', 78.3)) AND
    (SELECT add_zone('zone_42', 0.00333)) = FALSE

  )
  THEN
    RAISE NOTICE '********** TESTS 2 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 2 FAIL *********';
  END IF;

  IF (
    (SELECT add_station(1, 'Chateau de Vincennes', 'Vincennes', 2, 'MTR')) AND
    (SELECT add_station(2, 'Berault', 'Vincennes', 2, 'MTR')) AND
    (SELECT add_station(3, 'Saint-mandé', 'Vincennes', 2, 'MTR'))
  )
  THEN
    RAISE NOTICE '********** TESTS 3 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 3 FAIL *********';
  END IF;


  IF (
    (SELECT add_station(4, 'Avron', 'Paris', 1, 'MTR')) AND
    (SELECT add_station(5, 'Alexandre Dumas', 'Paris', 1, 'MTR')) AND
    (SELECT add_station(6, 'Père Lachaise', 'Paris', 1, 'MTR'))
  )
  THEN
    RAISE NOTICE '********** TESTS 4 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 4 FAIL *********';
  END IF;


  IF (
    (SELECT add_station(7, 'Saint-maur', 'Saint-Maur', 5, 'RER')) AND
    (SELECT add_station(8, 'Joinville', 'Joinville', 4, 'RER')) AND
    (SELECT add_station(9, 'Nogent sur marne', 'Nogent', 3, 'RER')) AND
    (SELECT add_station(10, 'Fontenay sous bois', 'Fontenay', 3, 'RER')) AND
    (SELECT add_station(11, 'Porte d italie', 'Villejuif', 2, 'RER'))
  )
  THEN
    RAISE NOTICE '********** TESTS 5 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 5 FAIL *********';
  END IF;

  IF (
    (SELECT add_line('RRA', 'RER')) AND
    (SELECT add_line('MT1', 'MTR')) AND
    (SELECT add_line('MT2', 'MTR'))
  )
  THEN
    RAISE NOTICE '********** TESTS 6 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 6 FAIL *********';
  END IF;

  IF (
    (SELECT add_station_to_line(1, 'MT1', 1)) AND
    (SELECT add_station_to_line(2, 'MT1', 2)) AND
    (SELECT add_station_to_line(3, 'MT1', 3))
  )
  THEN
    RAISE NOTICE '********** TESTS 7 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 7 FAIL *********';
  END IF;

  IF (
    (SELECT add_station_to_line(4, 'MT2', 1)) AND
    (SELECT add_station_to_line(5, 'MT2', 2)) AND
    (SELECT add_station_to_line(6, 'MT2', 3))
  )
  THEN
    RAISE NOTICE '********** TESTS 8 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 8 FAIL *********';
  END IF;

  IF (
    (SELECT add_station_to_line(7, 'RRA', 1)) AND
    (SELECT add_station_to_line(8, 'RRA', 2)) AND
    (SELECT add_station_to_line(9, 'RRA', 3)) AND
    (SELECT add_station_to_line(10, 'RRA', 4)) AND
    (SELECT add_station_to_line(11, 'RRA', 5))
  )
  THEN
    RAISE NOTICE '********** TESTS 9 OK **********';
  ELSE
    RAISE NOTICE '********* TESTS 9 FAIL *********';
  END IF;

  IF (
    ((SELECT get_price_station(1)) = 40.5) AND
    ((SELECT get_price_station(9)) = 52.7) AND
    ((SELECT get_price_station(8)) = 42.5) AND
    ((SELECT get_price_station(7)) = 78.3)
  )
  THEN
    RAISE NOTICE '********* TESTS 10  OK *********';
  ELSE
    RAISE NOTICE '******** TESTS 10 FAIL ********';
  END IF;

  IF (
    ((SELECT get_cost_travel(1, 2)) = 40.5) AND
    ((SELECT get_cost_travel(1, 4)) = 140.5) AND
    ((SELECT get_cost_travel(6, 7)) = 314) AND
    ((SELECT get_cost_travel(8, 9)) = 95.2)
  )
  THEN
    RAISE NOTICE '********* TESTS 11  OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 11 FAIL ********';
  END IF;

  RAISE NOTICE '-----------------------------------';
  RAISE NOTICE '|          THRESHOLD 2            |';
  RAISE NOTICE '-----------------------------------';
  IF (
    (SELECT
       add_person('Valeera', 'Siffeh', 'v.siffeh@hotmail.fr', '0600000000', '23 avenue galilée', 'Champigny', '94200'))
    AND
    (SELECT
       add_person('Jaina', 'Ouisarde', 'j.ouisarde@outlook.fr', '0611111111', '12 boulevard perroquet', 'Vincennes',
                  '94500')) AND
    (SELECT
       add_person('Uther', 'Pahladain', 'u.pah@hotmail.fr', '0622222222', '1 impasse galilée', 'Saint maur', '94100'))
    AND
    (SELECT
       add_person('Anduin', 'Prieste', 'anduinlecho94@gmail.com', '0733333333', '3bis rue dark', 'Vincennes', '94500'))
    AND
    (SELECT
       add_person('Rexxar', 'Eunte', 'r.eunte@hotmail.fr', '0744444444', '7 avenue de gaule', 'Joinville', '94200'))
    AND
    (SELECT
       add_person('Malfurion', 'Drod', 'd.malf@hotmail.fr', '0755555555', '7 avenue de gaule', 'Joinville', '94200'))
  )
  THEN
    RAISE NOTICE '********** TESTS 12 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 12 FAIL ********';
  END IF;

  IF (
    (SELECT add_offer('AAAAA', 'Imagine r', 300, 12, 1, 5)) AND
    (SELECT add_offer('AAAAA', 'La copieuse', 300, 12, 1, 5)) = FALSE AND
    (SELECT add_offer('BBBBB', 'Offre pigeon', 1000, 1, 1, 2)) AND
    (SELECT add_offer('CCCCC', 'Offre généreuse', 10, 24, 1, 4))
  )
  THEN
    RAISE NOTICE '********** TESTS 13 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 13 FAIL ********';
  END IF;

  IF (
    (SELECT add_subscription(2, 'j.ouisarde@outlook.fr', 'AAAAA', '01/02/2014')) AND
    (SELECT add_subscription(2, 'r.eunte@hotmail.fr', 'AAAAA', '03/03/2015') = FALSE) AND
    (SELECT add_subscription(3, 'anduinlecho94@gmail.com', 'BBBBB', '04/10/2015')) AND
    (SELECT add_subscription(4, 'anduinlecho94@gmail.com', 'CCCCC', '04/10/2015') = FALSE) AND
    (SELECT add_subscription(5, 'r.eunte@hotmail.fr', 'AAAAA', '03/03/2015')) AND
    (SELECT add_subscription(6, 'u.pah@hotmail.fr', 'CCCCC', '24/12/2017'))
  )
  THEN
    RAISE NOTICE '********** TESTS 14 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 14 FAIL ********';
  END IF;

  IF (
    (SELECT update_status(1, 'Registered')) AND
    (SELECT update_status(1, 'Regizstered')) = FALSE AND
    (SELECT update_status(2, 'Incomplete')) AND
    (SELECT update_status(5, 'Registered'))
  )
  THEN
    RAISE NOTICE '********** TESTS 15 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 15 FAIL ********';
  END IF;


  IF (
    (SELECT update_offer_price('AAAAA', 250)) AND
    (SELECT update_offer_price('BBBBB', -250)) = FALSE AND
    (SELECT update_offer_price('zgpoijzeop', 250)) = FALSE AND
    (SELECT update_offer_price('CCCCC', 0))
  )
  THEN
    RAISE NOTICE '********** TESTS 16 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 16 FAIL ********';
  END IF;

  RAISE NOTICE '-----------------------------------';
  RAISE NOTICE '|          THRESHOLD 3            |';
  RAISE NOTICE '-----------------------------------';


  IF (
    (SELECT add_service('Sécurité', 10)) AND
    (SELECT add_service('Conduite', 50)) AND
    (SELECT add_service('Le désert', 25)) AND
    (SELECT add_service('Conduite', 10)) = FALSE AND
    (SELECT add_service('la magie', 101)) = FALSE AND
    (SELECT add_service('Informatique', 30))
  )
  THEN
    RAISE NOTICE '********** TESTS 17 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 17 FAIL ********';
  END IF;

  IF (
    (SELECT add_contract('anduinlecho94@gmail.com', '12/08/2015', 'Informatique')) AND
    (SELECT add_contract('anduinlecho94@gmail.com', '12/08/1994', 'Informatique')) = FALSE AND
    (SELECT add_contract('v.siffeh@hotmail.fr', '11/04/2016', 'Conduite')) AND
    (SELECT add_contract('r.eunte@hotmail.fr', '12/08/1994', 'Sécurité'))
  )
  THEN
    RAISE NOTICE '********** TESTS 18 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 18 FAIL ********';
  END IF;

  IF (
    (SELECT end_contract('anduinlecho94@gmail.com', '12/08/1900')) = FALSE AND
    (SELECT end_contract('anduinlecho94@gmail.com', '12/08/2018')) AND
    (SELECT end_contract('anduinlecho94@gmail.com', '12/08/2018')) AND
    (SELECT end_contract('r.eunte@hotmail.fr', '12/08/2015'))
  )
  THEN
    RAISE NOTICE '********** TESTS 19 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 19 FAIL ********';
  END IF;

  IF (
    (SELECT update_service('Informatique', 10)) AND
    (SELECT update_service('Informatique', 101)) = FALSE AND
    (SELECT update_service('Conduite', 40))
  )
  THEN
    RAISE NOTICE '********** TESTS 20 OK *********';
  ELSE
    RAISE NOTICE '********* TESTS 20 FAIL ********';
  END IF;

  RETURN TRUE;
END; $$ LANGUAGE plpgsql;

SELECT test_expression();
