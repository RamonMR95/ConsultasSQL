/* EJERCICIO 1 */
DELIMITER //
CREATE PROCEDURE ej1(IN v_cantidad INT)
BEGIN
  DECLARE v_stock INT(10);
  DECLARE v_cod VARCHAR(8);
  DECLARE fin INT DEFAULT 0;

  DECLARE c_stock CURSOR FOR
    SELECT cod_art, stock
    FROM ARTICULO;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
  OPEN c_stock;

  getStock : LOOP
  FETCH c_stock INTO v_cod, v_stock;
  IF fin = 1 THEN
    LEAVE getStock;
  END IF;

  IF v_stock <= 10 THEN
    UPDATE ARTICULO
      SET stock = v_stock + v_cantidad
      WHERE cod_art = v_cod;
  ELSEIF v_stock > 100 THEN
    UPDATE ARTICULO
      SET stock = v_stock + (2 * v_cantidad)
      WHERE cod_art = v_cod;
  END IF;
  END LOOP getStock;
  CLOSE c_stock;
END //
DELIMITER ;


/* EJERCICIO 2 */
DELIMITER //
CREATE PROCEDURE ej2(IN stock_minimo INT)
BEGIN
  DECLARE v_stock INT(9);
  DECLARE v_cod VARCHAR(30);
  DECLARE pedir INT(8);
  DECLARE fin INT(9) DEFAULT 0;
  DECLARE stock_art CURSOR FOR
    SELECT stock, cod_art
    FROM ARTICULO;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

  OPEN stock_art;
  getArts : LOOP
  FETCH stock_art INTO v_stock, v_cod;
  IF fin = 1 THEN
    LEAVE getArts;
  END IF;

  IF v_stock < stock_minimo THEN
    SET pedir = (stock_minimo +10) - v_stock;
  ELSE SET pedir =  NULL;
  END IF;

  SELECT pedir, v_cod;
  END LOOP getArts;

  CLOSE stock_art;
  END //
DELIMITER ;


/* EJERCICIO 3 */
DELIMITER //
CREATE PROCEDURE ej3()
BEGIN
  DECLARE v_edad INT(10);
  DECLARE v_nombre VARCHAR(10);
  DECLARE v_fecha DATE;
  DECLARE fin INTEGER(10) DEFAULT 0;
  DECLARE v_mostrar VARCHAR(15);
  DECLARE cursor_edad CURSOR FOR
    SELECT Nombre, Fecha_Nac
    FROM CLIENTE;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
  OPEN cursor_edad;

  get_edad : LOOP
  FETCH cursor_edad INTO v_nombre, v_fecha;
  SELECT TIMESTAMPDIFF(year, v_fecha, CURDATE())
  INTO v_edad;

  IF fin = 1 THEN
    LEAVE get_edad;
  END IF;

  IF v_edad < 30 THEN
    SET v_mostrar = 'ADOLESCENTE';
  ELSEIF v_edad > 30 && v_edad < 60 THEN
    SET v_mostrar = 'ADULTO';
  ELSEIF v_edad > 60 THEN
    SET v_mostrar = 'JUBILADO';
  END IF;

  SELECT v_nombre, v_mostrar, v_edad;
  END LOOP get_edad;
  CLOSE cursor_edad;
END //
DELIMITER ;


/* EJERCICIO 4 */
DELIMITER //
CREATE PROCEDURE ej4()
BEGIN
  DECLARE v_direccion VARCHAR(150);
  DECLARE v_DNI VARCHAR(9);
  DECLARE fin INT DEFAULT 0;
  DECLARE cliente_direccion CURSOR FOR
    SELECT direccion, DNI
    FROM CLIENTE;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
  OPEN cliente_direccion;

  get_cliente : LOOP
  FETCH cliente_direccion INTO v_direccion, v_DNI;
  IF fin = 1 THEN
    LEAVE get_cliente;
  END IF;

  IF v_direccion = "C/Lepanto nº25 5ºB" THEN
    UPDATE CLIENTE
      SET direccion = "C/ La Iglesia"
      WHERE DNI = v_DNI;
  ELSEIF v_direccion= "C/Cervantes nº1 2ºA" THEN
    UPDATE CLIENTE
      SET direccion = "Avda Mediterraneo"
      WHERE DNI = v_DNI;
  END IF;
  END LOOP get_cliente;
  CLOSE cliente_direccion;
END //
DELIMITER ;


/*
1.- create procedure ej1(IN v_cantidad INT) BEGIN DECLARE v_stock int(10); DECLARE v_cod VARCHAR(8); DECLARE fin INT DEFAULT 0; DECLARE c_stock CURSOR FOR SELECT cod_art,stock FROM articulo; DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1; OPEN c_stock; get_stock:LOOP FETCH c_stock INTO v_cod,v_stock; IF fin=1 THEN  LEAVE get_stock; END IF; IF v_stock<=10 THEN UPDATE articulo SET stock=v_stock+v_cantidad WHERE cod_art=v_cod; ELSEIF v_stock>100 THEN UPDATE articulo SET stock=v_stock+v_cantidad*2 WHERE cod_art=v_cod;  END IF; END LOOP get_stock; CLOSE c_stock; END//
2.- CREATE PROCEDURE ej2(stock_minimo integer) BEGIN DECLARE v_stock INT; declare v_cod VARCHAR(30); declare pedir int; DECLARE fin INTEGER DEFAULT 0; DECLARE stock_art CURSOR FOR   SELECT stock,cod_art FROM articulo; DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1; OPEN stock_art; get_arts: LOOP   FETCH stock_art INTO v_stock,v_cod ; IF fin=1 THEN LEAVE get_arts; END IF;  IF v_stock < stock_minimo THEN     set pedir = (stock_minimo+10)-v_stock; else  set pedir = NULL; END IF; SELECT pedir,v_cod;  END LOOP get_arts; CLOSE stock_art; END//

3.- DELIMITER |
CREATE PROCEDURE ejercicio3 ()  BEGIN  DECLARE v_edad INTEGER(10);  DECLARE v_nombre VARCHAR(10);  DECLARE v_fecha DATE;  DECLARE v_fin INTEGER DEFAULT 0;  DECLARE v_mostrar VARCHAR(10);  DECLARE cursor_edad CURSOR FOR SELECT nombre,fecha_nac FROM Cliente;  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin=1;  OPEN cursor_edad;  get_edad: LOOP  FETCH cursor_edad INTO v_nombre,v_fecha;  SELECT TIMESTAMPDIFF(year,v_fecha,CURDATE()) INTO v_edad;  IF v_fin = 1 THEN  LEAVE get_edad;  END IF;  IF v_edad > 30 && v_edad < 60 THEN  SET v_mostrar = 'Adulto';  ELSEIF v_edad < 30 THEN  SET v_mostrar = 'Joven'; ELSE  SET v_mostrar = 'Jubilado'; END IF; SELECT v_nombre,v_mostrar,v_edad; END LOOP get_edad;  CLOSE cursor_edad;  END|
4.- CREATE PROCEDURE cambiar_calle() BEGIN DECLARE v_DIRECCION VARCHAR(150); DECLARE v_DNI VARCHAR(30); DECLARE fin INTEGER DEFAULT 0; DECLARE  cliente_direccion CURSOR FOR   select DIRECCION,DNI from cliente ; DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1; OPEN cliente_direccion; get_client: LOOP  FETCH cliente_direccion INTO v_DIRECCION,v_DNI ; IF fin=1 THEN LEAVE get_client; END IF;  if v_DIRECCION = "Carril La Iglesia" THEN     UPDATE cliente SET direccion = "C/ La Iglesia" WHERE DNI = v_DNI;   elseif  v_DIRECCION = "C/ Almudena" THEN  UPDATE cliente SET direccion = "Avda Mediterráneo" WHERE DNI = v_DNI;   END IF; END LOOP get_client; CLOSE cliente_direccion; END//
 */
