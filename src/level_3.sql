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
  RETURNS CHAR(9)
AS $$
DECLARE
  _login  VARCHAR(7) := concat(substr(_lastname, 0, 7), '_');
  _nlogin CHAR(9);
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
  _login     CHAR(9) := new_login(_lastname, _firstname);
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
      WHERE customer.email = _email AND (now() > contract.end_date OR contract.end_date IS NULL)
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
               WHERE customer.email = _email AND contract.end_date IS NULL AND _date_end >= contract.hire_date
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
    RETURN FALSE;
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

/****
create or replace function

as $$ begin
exception
    when others then
        return false;
end; $$
language plpgsql;

**/
