/* EJERCICIO 1 */
DELIMITER //
CREATE PROCEDURE checkEdad(IN v_dni VARCHAR(9), OUT r CHAR(1))
BEGIN
	DECLARE AGE INT;
	SELECT TIMESTAMPDIFF(year, CLIENTE.Fecha_Nac, now())
	FROM CLIENTE  WHERE DNI = v_dni INTO AGE;

	IF AGE >= 65 THEN
		SET r = 'Y';
	ELSE
		SET r = 'N';
	END IF;
END //
DELIMITER ;

CALL checkEdad('11111111A', @valor);
SELECT @valor;


/* EJERCICIO 2 */

DELIMITER //
CREATE PROCEDURE insertClientes(IN v_dni VARCHAR(9),
								IN v_nombre VARCHAR(60),
								IN v_apellido VARCHAR(255),
								IN v_fnac DATE,
								IN v_dir VARCHAR(255),
								IN v_cp VARCHAR(6))
BEGIN
	INSERT INTO CLIENTE VALUES (v_dni, v_nombre, v_apellido, v_fnac, v_dir, v_cp);
END //
DELIMITER ;

CALL insertClientes('12345678Z', 'Pepito', 'Martinez', '1995-03-15', 'Calle', '30154');


/* EJERCICIO 3 */
DELIMITER //
CREATE PROCEDURE updateCliente(IN v_dni VARCHAR(9), IN v_nombre VARCHAR(255))
BEGIN
	UPDATE CLIENTE SET Nombre = v_nombre WHERE DNI = v_dni;
END //
DELIMITER ;

CALL updateCliente('12345678Z', 'Pedro');


/* EJERCICIO 4 */
DELIMITER //
CREATE PROCEDURE getNombreApellidos(INOUT v_dni VARCHAR(9))
BEGIN
	SELECT CONCAT(Nombre,' ', Apellidos) AS 'Nombre y Apellidos'
	FROM COMERCIAL
	WHERE DNI = v_dni;
END //
DELIMITER ;

SET @valor = '55555555E';
CALL getNombreApellidos(@valor);


/* EJERCICIO 5 */
ALTER TABLE COMERCIAL
	ADD COLUMN sueldo INT NOT NULL;

UPDATE COMERCIAL
	SET sueldo = 1200  WHERE DNI = '55555555E';

UPDATE COMERCIAL
	SET sueldo = 1100  WHERE DNI = '66666666F';

UPDATE COMERCIAL
	SET sueldo = 1500  WHERE DNI = '77777777G';

UPDATE COMERCIAL
	SET sueldo = 1600  WHERE DNI = '88888888H';

DELIMITER //
CREATE PROCEDURE incrementSalary(IN v_dni VARCHAR(9), INOUT v_sueldo INT)
BEGIN
	UPDATE COMERCIAL c SET c.sueldo = c.sueldo + v_sueldo WHERE DNI like v_dni;

	SELECT sueldo INTO v_sueldo FROM COMERCIAL WHERE DNI = v_dni;
END //
DELIMITER ;

SET @s = 200;
CALL incrementSalary('55555555E', @s);

/* EJERCICIO 6 */
DELIMITER //
CREATE PROCEDURE superiorSaldo(IN n_cuenta BIGINT, IN v_cantidad INT(9), OUT r CHAR)
BEGIN
	DECLARE money INT;
	SELECT saldo
	FROM cuenta
	WHERE numero_cuenta = n_cuenta
	INTO money;

	IF money >= v_cantidad THEN
		SET r = 'Y';
	ELSE
		SET r = 'N';
	END IF;
END //
DELIMITER ;

CALL superiorSaldo(1, 1100, @value);
SELECT @value AS 'Superior al saldo??';
