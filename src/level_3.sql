CREATE OR REPLACE FUNCTION
  add_service(_name VARCHAR(32), _discount INT)
  RETURNS BOOLEAN
AS $$ BEGIN
  IF _discount NOT BETWEEN 0 AND 100
  THEN
    RETURN FALSE;
  END IF;
  INSERT INTO service (name, discount) VALUES (_name, _discount);
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  new_login(_lastname VARCHAR(64), _firstname VARCHAR(64))
  RETURNS VARCHAR(9)
AS $$
DECLARE
  _login  VARCHAR(7) := concat(substr(_lastname, 0, 7), '_');
  _nlogin VARCHAR(9);
  a       INT := 97;
BEGIN
  IF (SELECT employee.login
      FROM employee
      WHERE employee.login = concat(_login, substr(_firstname, 0, 2))) IS NULL
  THEN
    RETURN lower(concat(_login, substr(_firstname, 0, 2)));
  END IF;
  WHILE a <= 122 LOOP
    _nlogin := concat(_login, chr(a));
    IF (SELECT employee.login
        FROM employee
        WHERE employee.login = _nlogin) IS NULL
    THEN
      RETURN lower(_nlogin);
    END IF;
    a := a + 1;
  END LOOP;

  RETURN '';
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  add_contract(_email VARCHAR(128), _date_beginning DATE, _service VARCHAR(32))
  RETURNS BOOLEAN
AS $$
DECLARE
  _firstname VARCHAR(64) := (SELECT firstname
                             FROM customer
                             WHERE customer.email = _email
  );
  _lastname  VARCHAR(64) := (SELECT lastname
                             FROM customer
                             WHERE customer.email = _email
  );
  _cid       INT := (SELECT id
                     FROM customer
                     WHERE customer.email = _email
                     LIMIT 1);
  _login     VARCHAR(9) := new_login(_lastname, _firstname);
  _eid       INT := 0;
  _sid       INT := (SELECT id
                     FROM service
                     WHERE service.name = _service);
BEGIN
  IF _login = ''
  THEN
    RETURN FALSE;
  END IF;
  IF (SELECT contract.id
      FROM contract
        JOIN employee ON contract.employee_id = employee.id
        JOIN customer ON employee.customer_id = customer.id
      WHERE customer.email = _email AND
            (_date_beginning < contract.end_date OR contract.end_date IS NULL OR _date_beginning < contract.hire_date)
     ) IS NOT NULL
  THEN
    RETURN FALSE;
  END IF;
  IF (SELECT customer_id
      FROM employee
      WHERE customer_id = _cid) IS NULL
  THEN
    INSERT INTO employee (login, customer_id) VALUES (_login, _cid);
  END IF;
  _eid := (SELECT id
           FROM employee
           WHERE _login = employee.login);
  INSERT INTO contract (hire_date, end_date, employee_id, service_id)
  VALUES (_date_beginning, NULL, _eid, _sid);

  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE ;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  end_contract(_email VARCHAR(128), _date_end DATE)
  RETURNS BOOLEAN
AS $$
DECLARE
  _cid INT := (SELECT contract.id
               FROM contract
                 JOIN employee ON contract.employee_id = employee.id
                 JOIN customer ON employee.customer_id = customer.id
               WHERE customer.email = _email AND _date_end >= contract.hire_date
  );
BEGIN
  IF _cid IS NULL
  THEN
    RETURN FALSE;
  END IF;
  UPDATE contract
  SET end_date = _date_end
  WHERE contract.id = _cid;
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE ;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  update_service(_name VARCHAR(32), _discount INT)
  RETURNS BOOLEAN
AS $$ BEGIN
  IF _discount NOT BETWEEN 0 AND 100
  THEN
    RETURN FALSE;
  END IF;
  UPDATE service
  SET discount = _discount
  WHERE service.name = _name;
  RETURN TRUE;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE VIEW view_employees AS
  SELECT
    customer.lastname,
    customer.firstname,
    employee.login AS login,
    service.name   AS service
  FROM customer
    JOIN employee ON customer.id = employee.customer_id
    JOIN contract ON employee.id = contract.employee_id
    JOIN service ON contract.service_id = service.id
  ORDER BY lastname, firstname, login;

CREATE OR REPLACE VIEW view_nb_employees_per_service AS
  SELECT
    service.name,
    count(employee.login)
  FROM service
    LEFT JOIN contract ON service.id = contract.service_id
    LEFT JOIN employee ON contract.employee_id = employee.id
  GROUP BY service.name
  ORDER BY service.name;

CREATE OR REPLACE FUNCTION
  list_login_employee(_date_service DATE)
  RETURNS SETOF VARCHAR(8)
AS $$ BEGIN
  RETURN QUERY (SELECT employee.login
                FROM employee
                  JOIN contract ON employee.id = contract.employee_id
                  JOIN service ON contract.service_id = service.id
                WHERE (_date_service > contract.hire_date AND contract.end_date IS NULL) OR
                      (_date_service BETWEEN contract.hire_date AND contract.end_date)
                ORDER BY employee.login);
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
  list_not_employee(_date_service DATE)
  RETURNS TABLE(lastname VARCHAR(32), firstname VARCHAR(32), has_worked TEXT)
AS $$ BEGIN
  RETURN QUERY (
    SELECT
      customer.lastname,
      customer.firstname,
      CASE
      WHEN (contract.hire_date IS NOT NULL AND _date_service > contract.hire_date)
        THEN 'YES'
      ELSE 'NO'
      END
        AS has_worked
    FROM customer
      LEFT JOIN employee ON customer.id = employee.customer_id
      LEFT JOIN contract ON employee.id = contract.employee_id
    ORDER BY lastname, firstname
  );
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  list_subscription_history(_email VARCHAR(128))
  RETURNS TABLE(type TEXT, name VARCHAR, start_date DATE, duration INTERVAL)
AS $$ BEGIN
  RETURN QUERY (SELECT *
                FROM (SELECT
                        'sub'                                            AS type,
                        offer.name,
                        subscription.begin                               AS start_date,
                        concat(offer.duration * 30, ' days') :: INTERVAL AS duration
                      FROM customer
                        JOIN subscription ON customer.id = subscription.customer_id
                        JOIN offer ON subscription.offer_id = offer.id
                      WHERE customer.email = _email
                      UNION

                      SELECT
                        'ctr',
                        service.name,
                        contract.hire_date,
                        CASE WHEN contract.end_date IS NULL
                          THEN NULL
                        WHEN contract.end_date IS NOT NULL
                          THEN concat(contract.end_date - contract.hire_date, ' days') :: INTERVAL
                        END
                      FROM employee
                        JOIN contract ON employee.id = contract.employee_id
                        JOIN service ON contract.service_id = service.id
                        JOIN customer ON employee.customer_id = customer.id
                      WHERE customer.email = _email

                     ) AS s1
                ORDER BY start_date
  );
END; $$
LANGUAGE plpgsql;
