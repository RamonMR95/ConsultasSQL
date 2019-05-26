/* EJERCICIO 1
SELECT *
FROM CLIENTE
WHERE FLOOR(DATEDIFF(now(), Fecha_Nac) / 365) >  20;

+-----------+--------+-----------------+------------+------------------------+------------+
| DNI       | Nombre | Apellidos       | Fecha_Nac  | Direccion              | Cod_Postal |
+-----------+--------+-----------------+------------+------------------------+------------+
| 11111111A | Jose   | Perez Perez     | 1974-08-01 | C/Lepanto nº25 5ºB     | 30001      |
| 22222222B | Maria  | Sanchez Sanchez | 1985-03-25 | C/Cervantes nº1 2ºA    | 30001      |
| 33333333C | Pedro  | Martinez Lopez  | 1995-06-10 | C/Medina nº15 1ºC      | 30009      |
| 44444444D | Juan   | Flores Puerta   | 1991-04-12 | C/Velazquez nº20 4ºD   | 30008      |
+-----------+--------+-----------------+------------+------------------------+------------+
*/


/* EJERCICIO 2
SELECT *
FROM CLIENTE
WHERE FLOOR(DATEDIFF(now(), Fecha_Nac) / 365) >  35 AND Cod_Postal like '30001';

+-----------+--------+-------------+------------+----------------------+------------+
| DNI       | Nombre | Apellidos   | Fecha_Nac  | Direccion            | Cod_Postal |
+-----------+--------+-------------+------------+----------------------+------------+
| 11111111A | Jose   | Perez Perez | 1974-08-01 | C/Lepanto nº25 5ºB   | 30001      |
+-----------+--------+-------------+------------+----------------------+------------+
*/


/* EJERCICIO 3
SELECT Cod_Postal, COUNT(DNI) as 'Numero Clientes'
FROM CLIENTE
GROUP BY Cod_Postal;

+------------+-----------------+
| Cod_Postal | Numero Clientes |
+------------+-----------------+
| 30001      |               2 |
| 30008      |               1 |
| 30009      |               1 |
+------------+-----------------+
*/

 /* EJERCICIO 4
 SELECT DISTINCT Cod_Postal
 FROM CLIENTE
 WHERE Cod_Postal IN (SELECT Cod_Postal
                      FROM COMERCIAL);

+------------+
| Cod_Postal |
+------------+
| 30008      |
| 30001      |
| 30009      |
+------------+
*/

/* EJERCICIO 5
SELECT ROUND(AVG(Stock), 2) AS 'MEDIA'
FROM ARTICULO;

+-------+
| MEDIA |
+-------+
| 84.00 |
+-------+

*/

/* EJERCICIO 6
SELECT ROUND(AVG(Precio), 2) AS 'MEDIA'
FROM ARTICULO A INNER JOIN ALBARAN AL ON A.Cod_Art=AL.Cod_Art
WHERE Fecha_Alb BETWEEN '2014-01-01' AND '2014-12-31';

+--------+
| MEDIA  |
+--------+
| 260.00 |
+--------+
*/

/* EJERCICIO 7
SELECT Cod_Art, Descripcion
FROM ARTICULO
WHERE Precio > (SELECT avg(Precio)
                    FROM ARTICULO);

+---------+--------------------+
| Cod_Art | Descripcion        |
+---------+--------------------+
| ART-100 | SAI 1500VA-Salicru |
| ART-250 | Condensador RJW    |
+---------+--------------------+
*/

/* EJERCICIO 8
SELECT SUM(Precio * Stock) AS 'VALOR TOTAL'
FROM ARTICULO;

+-------------+
| VALOR TOTAL |
+-------------+
|       27300 |
+-------------+
*/

/* EJERCICIO 9
SELECT SUM(Importe) AS 'Facturación Total'
FROM FACTURA
WHERE YEAR(Fecha_Fac) = '2012';

+--------------------+
| Facturación Total  |
+--------------------+
|               5100 |
+--------------------+
*/

/* EJERCICIO 10
SELECT Cod_Postal, SUM(Importe) AS 'Facturación Total'
FROM FACTURA F INNER JOIN CLIENTE C ON F.DNI = C.DNI
GROUP BY Cod_Postal;

+------------+--------------------+
| Cod_Postal | Facturación Total  |
+------------+--------------------+
| 30001      |               9000 |
| 30008      |               3020 |
| 30009      |               2500 |
+------------+--------------------+
 */

 /* EJERCICIO 11
 SELECT SUM(Importe) AS 'Facturacion Total',YEAR(Fecha_Fac) AS 'YEAR'
 FROM FACTURA
 GROUP BY YEAR(Fecha_Fac);

 +--------------------+------+
| Facturación Total  | YEAR |
+--------------------+------+
|               5100 | 2012 |
|               6400 | 2013 |
|                520 | 2014 |
|               2500 | 2015 |
+--------------------+------+
*/

/* EJERCICIO 12
SELECT Cod_Fac, COUNT(Cod_Alb) AS 'Numero de Albaranes'
FROM ALBARAN
GROUP BY Cod_Fac;

+---------+---------------------+
| Cod_Fac | Numero de Albaranes |
+---------+---------------------+
| F-0001  |                   2 |
| F-0002  |                   1 |
| F-0003  |                   3 |
| F-0004  |                   1 |
| F-0005  |                   1 |
| F-0006  |                   1 |
| F-0007  |                   2 |
| F-0008  |                   1 |
+---------+---------------------+
*/

/* EJERCICIO 13
SELECT *
FROM FACTURA
WHERE Importe = (SELECT MAX(Importe)
                FROM FACTURA);

+---------+-----------+------------+---------+
| Cod_Fac | DNI       | Fecha_Fac  | Importe |
+---------+-----------+------------+---------+
| F-0004  | 22222222B | 2013-09-20 |    3000 |
+---------+-----------+------------+---------+
*/

/* EJERCICIO 14
SELECT Cod_Fac, Importe
FROM FACTURA
ORDER BY Importe DESC
LIMIT 3;

+---------+---------+
| Cod_Fac | Importe |
+---------+---------+
| F-0004  |    3000 |
| F-0001  |    2800 |
| F-0008  |    2500 |
+---------+---------+
*/

/* EJERCICIO 15
SELECT *
FROM FACTURA
ORDER BY Importe DESC
LIMIT 3;

+---------+-----------+------------+---------+
| Cod_Fac | DNI       | Fecha_Fac  | Importe |
+---------+-----------+------------+---------+
| F-0004  | 22222222B | 2013-09-20 |    3000 |
| F-0001  | 11111111A | 2012-02-01 |    2800 |
| F-0008  | 44444444D | 2015-02-04 |    2500 |
+---------+-----------+------------+---------+
*/

/* EJERCICIO 16
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT *
FROM ARTICULO A
INNER JOIN ALBARAN AL ON A.Cod_Art = AL.Cod_Art
GROUP BY A.Cod_Art
HAVING SUM(AL.Cantidad) >=  0.4 * A.Stock;

+---------+------------------------+--------+-------+---------+---------+------------+---------+----------+
| Cod_Art | Descripcion            | Precio | Stock | Cod_Alb | Cod_Fac | Fecha_Alb  | Cod_Art | Cantidad |
+---------+------------------------+--------+-------+---------+---------+------------+---------+----------+
| ART-10  | Elevador potencia      |     60 |    50 | A-0007  | F-0004  | 2013-09-20 | ART-10  |       50 |
| ART-100 | SAI 1500VA-Salicru     |    500 |     8 | A-0003  | F-0002  | 2012-02-15 | ART-100 |        3 |
| ART-120 | Ventilador led enermax |     10 |    55 | A-0002  | F-0001  | 2012-01-20 | ART-120 |       30 |
+---------+------------------------+--------+-------+---------+---------+------------+---------+----------+
*/

/* EJERCICIO 17
SELECT Cod_Alb, A.Cod_Fac, Fecha_Alb, Cod_Art, Cantidad, DNI, Fecha_Fac, Importe
FROM ALBARAN A
INNER JOIN FACTURA F ON A.Cod_Fac = F.Cod_Fac
GROUP BY A.Cod_Alb
ORDER BY Importe DESC
LIMIT 3;

+---------+---------+------------+---------+----------+-----------+------------+---------+
| Cod_Alb | Cod_Fac | Fecha_Alb  | Cod_Art | Cantidad | DNI       | Fecha_Fac  | Importe |
+---------+---------+------------+---------+----------+-----------+------------+---------+
| A-0007  | F-0004  | 2013-09-20 | ART-10  |       50 | 22222222B | 2013-09-20 |    3000 |
| A-0001  | F-0001  | 2012-01-10 | ART-250 |       10 | 11111111A | 2012-02-01 |    2800 |
| A-0002  | F-0001  | 2012-01-20 | ART-120 |       30 | 11111111A | 2012-02-01 |    2800 |
+---------+---------+------------+---------+----------+-----------+------------+---------+
*/

/* EJERCICIO 18
SELECT C.DNI, SUM(Importe) AS 'Facturacion Total'
FROM CLIENTE C
INNER JOIN FACTURA F ON C.DNI = F.DNI
GROUP BY C.DNI;

+-----------+-------------------+
| DNI       | Facturacion Total |
+-----------+-------------------+
| 11111111A |              5100 |
| 22222222B |              3900 |
| 33333333C |              2500 |
| 44444444D |              3020 |
+-----------+-------------------+
*/

/* EJERCICIO 19 // FIXME
CREATE TEMPORARY TABLE TEMP SELECT DNI_Cli, DNI_Comercial FROM VISITA GROUP BY DNI_Cli;

SELECT T.DNI_Comercial, SUM(F.Importe) AS 'Facturacion Total'
FROM TEMP T
INNER JOIN FACTURA F ON T.DNI_Cli = F.DNI
GROUP BY T.DNI_Cli, T.DNI_Comercial;
*/

/* EJERCICIO 20
SELECT DISTINCT A.Cod_Art, A.Descripcion
FROM ARTICULO A
INNER JOIN ALBARAN AL ON A.Cod_Art = AL.Cod_Art
INNER JOIN FACTURA F ON AL.Cod_Fac = F.Cod_Fac
WHERE F.DNI = ALL (SELECT C.DNI FROM CLIENTE C WHERE C.DNI = F.DNI )
 */

/* EJERCICIO 21 */
