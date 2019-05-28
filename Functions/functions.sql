/* EJERCICIO 1 */
DELIMITER //
CREATE FUNCTION contar_albaranes( v_fecha_albaran DATE)
RETURNS INT
BEGIN
  DECLARE counter INT;

  SELECT COUNT(*)
    FROM ALBARAN
    WHERE YEAR(Fecha_Alb) = YEAR(v_fecha_albaran)
    INTO counter;

  RETURN counter;
END //
DELIMITER ;

SELECT contar_albaranes('2014-01-01') AS 'Nº DE ALBARANES';


/* EJERCICIO 2 */
DELIMITER //
CREATE FUNCTION calcular_edad(v_dni VARCHAR(9))
RETURNS INT
BEGIN
  DECLARE v_edad INT(3);

  SELECT TIMESTAMPDIFF(YEAR, Fecha_Nac, CURDATE())
  FROM CLIENTE
  WHERE DNI = v_dni
  INTO v_edad;

  RETURN v_edad;
END //
DELIMITER ;

SELECT calcular_edad('11111111A') AS 'EDAD';


/* EJERCICIO 3 */
DELIMITER //
CREATE FUNCTION valor_total_almacen(v_cod_art VARCHAR(7))
RETURNS INT
BEGIN
  DECLARE v_valor INT;

  SELECT Precio * Stock
  FROM ARTICULO
  WHERE Cod_art = v_cod_art
  INTO v_valor;

  RETURN v_valor;
END //
DELIMITER ;

SELECT valor_total_almacen('ART-120') AS 'Valor Total';
SELECT valor_total_almacen('ART-100') AS 'Valor Total';


/* EJERCICIO 4 */
DELIMITER //
CREATE FUNCTION importe_total_factura(v_dni VARCHAR(9))
RETURNS INT
BEGIN
  DECLARE v_valor INT;

  SELECT SUM(Importe)
  FROM FACTURA
  WHERE DNI = v_dni
  GROUP BY DNI
  INTO v_valor;

  RETURN v_valor;
END //
DELIMITER ;

SELECT importe_total_factura('11111111A') AS 'Importe Total';


/* EJERCICIO 5 */
DELIMITER //
CREATE FUNCTION rotura_stock(v_cod_art VARCHAR(8), v_umbral INT)
RETURNS CHAR
BEGIN
  DECLARE v_stock INT;

  SELECT Stock
  FROM ARTICULO
  WHERE Cod_Art = v_cod_art
  INTO v_stock;

  IF v_stock < v_umbral THEN
    RETURN 'Y';
  ELSE
    RETURN 'N';
  END IF;
END //
DELIMITER ;

SELECT rotura_stock('ART-100', 26) AS 'Rotura de Stock';

/* EJERCICIO 6 */
DELIMITER //
CREATE FUNCTION verificar_factura(v_factura VARCHAR(9))
RETURNS CHAR
BEGIN
  DECLARE v_impFacturaAlbaran INT;
  DECLARE v_impFactura INT;

  SELECT Importe
  FROM FACTURA
  WHERE Cod_Fac like v_factura
  INTO v_impFactura;

  SELECT Importe
  FROM FACTURA F
  INNER JOIN ALBARAN A ON A.Cod_Fac = F.Cod_Fac
  WHERE F.Cod_Fac like v_factura
  GROUP BY F.Cod_Fac
  INTO v_impFacturaAlbaran;

  IF v_impFactura = v_impFacturaAlbaran THEN
    RETURN 'Y';
  ELSE
    RETURN 'N';
  END IF;
END //
DELIMITER ;

SELECT verificar_factura('F-0001') AS 'Concordancia Factura';
SELECT verificar_factura('F-0002') AS 'Concordancia Factura';
SELECT verificar_factura('F-0003') AS 'Concordancia Factura';
SELECT verificar_factura('F-0004') AS 'Concordancia Factura';
SELECT verificar_factura('F-0005') AS 'Concordancia Factura';
SELECT verificar_factura('F-0006') AS 'Concordancia Factura';
SELECT verificar_factura('F-0007') AS 'Concordancia Factura';
SELECT verificar_factura('F-0008') AS 'Concordancia Factura';
