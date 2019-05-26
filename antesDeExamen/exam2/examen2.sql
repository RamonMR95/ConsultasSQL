/* EJERCICIO 1
-- Hay dos clientes en la BD que comparten tlfno (tienen el mismo número) ¿De qué provincias son?
-- NOTA: da la respuesta con los nombres de las provincias separados por una coma y sin espacios en blanco adicionales

SELECT pro.nombre
FROM provincia pro
INNER JOIN cliente c ON pro.id_provincia = c.Provincia
WHERE c.tlfno IN (SELECT tlfno
                  FROM cliente
                  GROUP BY tlfno
                  HAVING COUNT(tlfno) = 2);

+---------+
| nombre  |
+---------+
| SEGOVIA |
| SEVILLA |
+---------+
 */

/* EJERCICIO 2
-- Indica cuántos Supositorios (Formato_Simple 'Supositorio') han vendido los fabricantes cuyo nombre comienza por PHARMA en la ccaa de 'CASTILLA Y LEON'.

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

+----------+
| Cantidad |
+----------+
|       60 |
+----------+
*/

/* EJERCICIO 3
 -- Hallar los nombres de los fármacos cuyo precio ha sido rebajado respecto al que aparece en las facturas emitidas. (Su precio actual de venta según el campo Precio de la tabla fármacos es inferior al que aparece en la tabla detalles_pedido.
 -- Da los nombres separados por comas y sin ningún espacio en blanco adicional.
SELECT DISTINCT f.Nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
WHERE f.precio < dp.precio;
+----------------+
| Nombre         |
+----------------+
| CIPROFLOXACINO |
+----------------+
*/

 /* EJERCICIO 4
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
+---------------+
| nombre        |
+---------------+
| Steve Wozniak |
+---------------+
*/


 /* EJERCICIO 5
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
                    WHERE pro.nombre like 'BARCELONA')
  AND f_pedido BETWEEN '2017-01-01' AND '2017-01-03';
+--------------+
| nombre       |
+--------------+
| PANTOMICINA  |
| HIPERFLEX TU |
+--------------+
*/

/* EJERCICIO 6
-- Suponiendo un stock inicial de mil unidades del fármaco más vendido indica con una consulta el nombre de dicho fármaco
-- y cuántas unidades quedarían ahora en stock. NOTA: aunque no es lo más correcto se permite hacer uso de LIMIT 1 en este ejercicio.
SELECT f.nombre, (1000 - COUNT(id_producto)) AS 'Unidades Restantes'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
GROUP BY id_producto
ORDER BY COUNT(id_producto) DESC
LIMIT 1;
+----------+--------------------+
| nombre   | Unidades Restantes |
+----------+--------------------+
| PATECTOR |                922 |
+----------+--------------------+
*/

/* EJERCICIO 7
-- Hallar para cada cliente nacido antes de 1978 el coste total del pedido de mayor importe para cada uno de esos clientes
*/

/* EJERCICIO 8
-- ¿Fecha de nacimiento del vendedor que ha realizado el pedido en el que hay la mayor cantidad vendida de medicamentos FOLINATO DE CALCIO?
-- Indicar la fecha en formato YYYY-MM-DD preferentemente. En caso de que haya más de un valor de respuesta expresarlos separados por comas y sin espacios en blanco adicionales.
-- Nota: hay varios fármacos con este nombre y hay que incluirlos a todos.

SELECT v.f_nac
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE f.nombre like 'FOLINATO DE CALCIO' AND dp.cantidad >= all (SELECT dp.cantidad
                                                                FROM detalles_pedido dp
                                                                INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
                                                                INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                                                                WHERE f.nombre like 'FOLINATO DE CALCIO');

+------------+
| f_nac      |
+------------+
| 1973-03-26 |
| 1944-08-17 |
+------------+
*/

/* EJERCICIO 9 */
SELECT MAX(cantidad)
FROM detalles_pedido dp
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
INNER JOIN pais pa ON fa.pais = pa.id_pais
WHERE DATEDIFF(f.Fecha_Registro, '2016-08-01') > 0
  AND dp.id_producto  IN (SELECT f.Codigo
                            FROM farmaco f
                            INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                            INNER JOIN pais pa ON fa.pais = pa.id_pais
                            WHERE pa.nombre not like 'RUMANIA')
GROUP BY dp.id_dp
HAVING COUNT(dp.id_pedido) = 1;
