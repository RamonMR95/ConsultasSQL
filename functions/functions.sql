/* EJERCICIO 1
DELIMITER //
CREATE FUNCTION contar_albaranes(fecha DATE)
RETURNS INT
BEGIN
  DECLARE counter INT;
  SELECT COUNT(*)
    FROM ALBARAN
    WHERE year(Fecha_Alb) = year(fecha)
    INTO counter;
  RETURN counter;
END //
DELIMITER ;


SELECT contar_albaranes('2015-01-10') as 'Nº de albaranes';
*/

/* EJERCICIO 2
DELIMITER //
CREATE FUNCTION getAge(id VARCHAR(9))
RETURNS INT
BEGIN
  DECLARE age INT;
  SELECT FLOOR(DATEDIFF(CURDATE(), Fecha_Nac) / 365)
  FROM CLIENTE
  WHERE DNI = id
  INTO age;
  RETURN age;
END //
DELIMITER ;

SELECT getAge('33333333C') as 'Edad';
SELECT getAge('11111111A') as 'Edad';
 */

/* EJERCICIO 3
DELIMITER //
CREATE FUNCTION valorTotal(articulo VARCHAR(7))
RETURNS INT
BEGIN
  DECLARE valor INT;
  SELECT (Precio * Stock)
  FROM ARTICULO
  WHERE Cod_Art like articulo
  INTO valor;
  RETURN valor;
END //
DELIMITER ;

SELECT valorTotal('ART-120') AS 'Valor total del articulo';
 */

/* EJERCICIO 4
DELIMITER //
CREATE FUNCTION importeTotal(id VARCHAR(9))
RETURNS INT
BEGIN
  DECLARE valor INT;
  SELECT Importe
  FROM FACTURA
  WHERE DNI like id
  INTO valor;
  RETURN valor;
END //
DELIMITER ;

SELECT importeTotal('11111111A') AS 'Importe total cliente 1';
SELECT importeTotal('22222222B') AS 'Importe total cliente 1';
*/

/* EJERCICIO 5
DELIMITER //
CREATE FUNCTION informeStock(articulo VARCHAR(7), umbral INT(9))
RETURNS CHAR
BEGIN
  DECLARE count INT;
  SELECT Stock
  FROM ARTICULO
  WHERE Cod_Art like articulo
  INTO count;

  IF count > umbral THEN
    RETURN 'N';
  ELSE
    RETURN 'Y';
  END IF;

END //
DELIMITER ;

SELECT informeStock('ART-10', 60)  AS 'Rotura Stock';
*/

/* EJERCICIO 6
DELIMITER //
CREATE FUNCTION verificarFactura(factura VARCHAR(9))
RETURNS CHAR
BEGIN
  DECLARE impFactura INT;
  DECLARE impFacturaAlbaran INT;
  DECLARE response CHAR;

  SELECT Importe
  FROM FACTURA
  WHERE Cod_Fac like factura
  INTO impFactura;

  SELECT Importe
  FROM FACTURA F
  INNER JOIN ALBARAN A ON A.Cod_Fac = F.Cod_Fac
  WHERE F.Cod_Fac like factura
  INTO impFacturaAlbaran;

  IF impFactura = impFacturaAlbaran THEN
    SET response = 'Y';
  ELSE
    SET response = 'N';
  END IF;

  RETURN response;

END //
DELIMITER ;

SELECT verificarFactura('F-0002') AS 'Concordancia';
 */
