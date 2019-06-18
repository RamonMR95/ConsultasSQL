/* EJERCICIO 1 */ -- OK
-- Hay dos clientes en la BD que comparten tlfno (tienen el mismo número) ¿De
-- qué provincias son?
-- NOTA: da la respuesta con los nombres de las provincias separados por una coma
-- y sin espacios en blanco adicionales

SELECT pro.nombre
FROM provincia pro
INNER JOIN cliente c ON pro.id_provincia = c.Provincia
WHERE c.tlfno IN (SELECT tlfno
                  FROM cliente
                  GROUP BY tlfno
                  HAVING COUNT(tlfno) = 2);

/*
+---------+
| nombre  |
+---------+
| SEGOVIA |
| SEVILLA |
+---------+
*/

/* EJERCICIO 2 */
-- Indica cuántos Supositorios (Formato_Simple 'Supositorio') han vendido los
-- fabricantes cuyo nombre comienza por PHARMA en la ccaa de 'CASTILLA Y LEON'.

SELECT SUM(cantidad) 'Cantidad'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN provincia pro ON pro.id_provincia = c.Provincia
INNER JOIN ccaa ON ccaa.id_ca = pro.id_ca
WHERE f.Formato_Simple like 'Supositorio'
  AND fa.nombre like 'PHARMA%'
  AND ccaa.Nombre like 'CASTILLA Y LEON';

/*
+----------+
| Cantidad |
+----------+
|       60 |
+----------+
*/

/* EJERCICIO 3 */
 -- Hallar los nombres de los fármacos cuyo precio ha sido rebajado respecto al que aparece
 -- en las facturas emitidas. (Su precio actual de venta según el campo Precio de la tabla
 -- fármacos es inferior al que aparece en la tabla detalles_pedido.
 -- Da los nombres separados por comas y sin ningún espacio en blanco adicional.

SELECT DISTINCT f.Nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
WHERE f.precio < dp.precio;

/*
+----------------+
| Nombre         |
+----------------+
| CIPROFLOXACINO |
+----------------+
*/

 /* EJERCICIO 4 */ -- OK
 -- ¿Qué vendedor ha realizado el pedido en el que hay la mayor cantidad vendida de CITOFER?

SELECT v.nombre
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE f.nombre like 'CITOFER'
AND cantidad =  (SELECT max(cantidad)
                FROM detalles_pedido dp
                INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                WHERE f.nombre like 'CITOFER');
 /*
+---------------+
| nombre        |
+---------------+
| Steve Wozniak |
+---------------+
*/


 /* EJERCICIO 5 */
-- Nombre de los fármacos vendidos a clientes de Madrid y no de Barcelona entre el 1 y el 3 de enero de 2017

SELECT f.nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
WHERE pro.nombre like 'MADRID'
  AND f.nombre NOT IN (SELECT f.nombre
                    FROM farmaco f
                    INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
                    INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
                    INNER JOIN cliente c ON p.id_cliente = c.id_cliente
                    INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                    WHERE pro.nombre like 'BARCELONA'
						AND f_pedido BETWEEN '2017-01-01' AND '2017-01-03')
  AND f_pedido BETWEEN '2017-01-01' AND '2017-01-03'


/* EJERCICIO 6 */
-- Suponiendo un stock inicial de mil unidades del fármaco más vendido indica con
-- una consulta el nombre de dicho fármaco y cuántas unidades quedarían ahora en
-- stock. NOTA: aunque no es lo más correcto se permite hacer uso de LIMIT 1 en este ejercicio.

SELECT f.nombre, (1000 - SUM(dp.cantidad)) AS 'Unidades Restantes'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
GROUP BY f.Codigo
HAVING SUM(dp.cantidad) >= ALL (SELECT SUM(dp.cantidad)
                                FROM detalles_pedido dp
                                GROUP BY dp.id_producto);

/* EJERCICIO 7 */
-- Hallar para cada cliente nacido antes de 1978 el coste total del pedido de mayor
-- importe para cada uno de esos clientes

SELECT c.id_cliente, MAX(dp.Precio)
FROM cliente c
INNER JOIN pedido p USING (id_cliente)
INNER JOIN detalles_pedido dp USING(id_pedido)
WHERE DATEDIFF(f_nac, '1978-01-01') < 0
GROUP BY c.id_cliente


/* EJERCICIO 8 */
-- ¿Fecha de nacimiento del vendedor que ha realizado el pedido en el que hay la mayor
-- cantidad vendida de medicamentos FOLINATO DE CALCIO? Indicar la fecha en formato
-- YYYY-MM-DD preferentemente. En caso de que haya más de un valor de respuesta expresarlos
-- separados por comas y sin espacios en blanco adicionales.
-- Nota: hay varios fármacos con este nombre y hay que incluirlos a todos.

SELECT v.f_nac
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE f.nombre LIKE 'FOLINATO DE CALCIO'
  AND dp.cantidad >= ALL (SELECT dp.cantidad
                          FROM detalles_pedido dp
                          INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
                          INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                          WHERE f.nombre LIKE 'FOLINATO DE CALCIO');
/*
+------------+
| f_nac      |
+------------+
| 1973-03-26 |
| 1944-08-17 |
+------------+
*/

/* EJERCICIO 9 */ -- CHECKEAR
-- Número más alto de unidades (cantidad) solicitadas en un único pedido de los fármacos fabricados
--  en 'RUSIA' (el fabricante es de Rusia) desde agosto de 2016 hasta la fecha actual y no han
-- sido nunca fabricados en 'RUMANIA'.

SELECT cantidad, pa.nombre
FROM detalles_pedido dp
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
INNER JOIN pais pa ON fa.pais = pa.id_pais
WHERE DATEDIFF(f.Fecha_Registro, '2016-08-01') > 0
  AND pa.nombre LIKE 'RUSIA'
  AND dp.id_producto  NOT IN (SELECT f.Codigo
                            FROM farmaco f
                            INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                            INNER JOIN pais pa ON fa.pais = pa.id_pais
                            WHERE pa.nombre LIKE 'RUMANIA')
  AND cantidad >= ALL(SELECT MAX(cantidad)
                            FROM detalles_pedido dp
                            INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                            INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                            INNER JOIN pais pa ON fa.pais = pa.id_pais
                            WHERE DATEDIFF(f.Fecha_Registro, '2016-08-01') > 0
                              AND pa.nombre LIKE 'RUSIA'
                              AND dp.id_producto  NOT IN (SELECT f.Codigo
                                                        FROM farmaco f
                                                        INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                                                        INNER JOIN pais pa ON fa.pais = pa.id_pais
                                                        WHERE pa.nombre LIKE 'RUMANIA')
                            GROUP BY id_dp
                            HAVING COUNT(id_pedido) = 1)
GROUP BY dp.id_dp


/* EJERCICIO 10 */ -- OK
-- ¿En qué ccaa no ha vendido nada Steven Jobs en 2017?

SELECT ccaa.nombre
FROM ccaa
WHERE ccaa.id_ca NOT IN (SELECT pro.id_ca
                          FROM provincia pro
                          INNER JOIN cliente c ON pro.id_provincia = c.Provincia
                          INNER JOIN pedido p USING (id_cliente)
                          INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
                          WHERE v.nombre LIKE 'Steven Jobs'
                            AND YEAR(p.f_pedido) = 2017);

/* EJERCICIO 11 */
-- Los clientes que han comprado 'SEX-UP' también han comprado... Indicar en una consulta el nombre del
-- producto (o productos si más de uno ha sido comprado en el mismo máximo número de pedidos) más comprado
-- por los clientes que han comprado 'SEX-UP' entendiendo por más comprado el que aparece en más pedidos
-- de los clientes que han adquirido 'SEX-UP' (no aquel producto del que más unidades se han vendido).
-- Da el resultado con los productos separados por comas si hay más de uno.




/* EJERCICIO 12 */
-- ¿Cuántos fabricantes diferentes (distinto nombre) han vendido algún fármaco con fecha
-- posterior a alguno de los pedidos realizados bien en Murcia bien en Almeria?

SELECT COUNT(DISTINCT(fa.nombre))
FROM fabricante fa
INNER JOIN farmaco f ON fa.id_fabricante = f.fabricante
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p USING(id_pedido)
INNER JOIN cliente USING(id_cliente)
WHERE f_pedido >= ANY (SELECT f_pedido
                      FROM pedido p
                      INNER JOIN cliente c USING(id_cliente)
                      INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                      WHERE pro.nombre LIKE 'Murcia' OR pro.nombre LIKE 'Almeria');


/* EJERCICIO 13 */
-- Indica el nombre del fabricante con mayor número de artículos vendidos (fabricados por él) y la cantidad
-- total de fármacos vendidos.

SELECT fa.nombre, COUNT(id_producto) AS 'Nº Articulos Vendidos'
FROM fabricante fa
INNER JOIN farmaco f ON fa.id_fabricante = f.fabricante
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
GROUP BY fa.nombre
HAVING COUNT(id_producto) >= ALL  (SELECT COUNT(id_producto)
                                  FROM detalles_pedido dp
                                  INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                                  INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                                  GROUP BY fa.nombre);

/* EJERCICIO 14 */
-- ¿De qué provincias se han realizado los mismos o más pedidos que incluyan fármacos que se vendan en
-- Formato_Simple 'Supositorio' que fármacos en Formato_Simple 'Parche' en cualquier otra provincia?

SELECT pro.nombre
FROM provincia pro
INNER JOIN cliente c ON pro.id_provincia = c.Provincia
INNER JOIN pedido p USING(id_cliente)
INNER JOIN detalles_pedido dp USING(id_pedido)
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE f.Formato_Simple LIKE 'Supositorio'
GROUP BY pro.nombre
HAVING COUNT(dp.id_producto) >= ALL (SELECT COUNT(dp.id_producto)
                                    FROM detalles_pedido dp
                                    INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                                    INNER JOIN pedido p USING(id_pedido)
                                    INNER JOIN cliente c USING(id_cliente)
                                    INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                                    WHERE f.Formato_Simple LIKE 'Parche'
                                    GROUP BY pro.nombre);

/* EJERCICIO 15 */
-- ¿Qué países tienen más fabricantes que alguno de los siguientes: JAPON, MAURICIO, DINAMARCA?

SELECT pa.nombre
FROM pais pa
INNER JOIN fabricante fa ON pa.id_pais = fa.pais
GROUP BY pa.nombre
HAVING COUNT(id_fabricante) >= ANY (SELECT COUNT(id_fabricante)
                                    FROM fabricante fa
                                    INNER JOIN pais pa ON pa.id_pais = fa.pais
                                    WHERE pa.nombre LIKE 'JAPON'
                                      OR pa.nombre LIKE 'MAURICIO'
                                      OR pa.nombre LIKE 'DINAMARCA'
                                    GROUP BY pa.nombre);

/* EJERCICIO 16 */
-- Hallar el nombre del empleado que ha realizado pedido de menor coste de todos los realizados.

SELECT v.nombre
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
WHERE (cantidad * precio ) = (SELECT MIN(cantidad * precio)
                              FROM detalles_pedido dp);

/* EJERCICIO 17 */
-- Mostrar el nombre del país o países donde hay más de un fabricante cuyo nombre incluya 'FARMA'
-- (como parte del nombre del fabricante) y su país sea alguno de los países de los vendedores.

SELECT pa.nombre
FROM pais pa
WHERE pa.id_pais IN (SELECT pa.id_pais
                    FROM pais pa INNER JOIN fabricante fa ON pa.id_pais = fa.pais
                    WHERE fa.nombre LIKE "%FARMA%"
                    GROUP BY pa.id_pais
                    HAVING COUNT(pa.id_pais) > 1)
                      AND pa.id_pais IN (SELECT v.pais
                                        FROM vendedor v);

/* EJERCICIO 18 */ -- OK
-- ¿Cuántos fármacos diferentes (distinto nombre) se han vendido con fecha posterior a alguno
-- de los pedidos realizados bien en Ceuta bien en Melilla?

SELECT COUNT(DISTINCT(f.nombre))
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p USING(id_pedido)
WHERE f_pedido >= ANY (SELECT f_pedido
                        FROM pedido p
                        INNER JOIN cliente c USING(id_cliente)
                        INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                        WHERE pro.nombre LIKE 'CEUTA' OR pro.nombre LIKE 'MELILLA');

/* EJERCICIO 19 */
-- ¿Cuántos fármacos diferentes ( distinto nombre) se han vendido con fecha posterior a cualquier
-- pedido realizado bien en Ceuta bien en Melilla?

SELECT COUNT(DISTINCT(f.nombre))
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p USING(id_pedido)
WHERE f_pedido >= ALL (SELECT f_pedido
                        FROM pedido p
                        INNER JOIN cliente c USING(id_cliente)
                        INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                        WHERE pro.nombre LIKE 'CEUTA' OR pro.nombre LIKE 'MELILLA');

/* EJERCICIO 20 */ -- OK
-- Indica la cantidad total de unidades vendidas del fármaco que ha visto aumentado su precio
-- en 10 céntimos (El precio que aparece en el fármaco en la tabla fármaco es 10 céntimos
-- superior al que aparece en detalles pedido)

SELECT SUM(dp.cantidad)
FROM detalles_pedido dp
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE f.Precio = dp.Precio + 0.10
GROUP BY dp.id_producto;
