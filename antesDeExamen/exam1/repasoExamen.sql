USE CatalogoFarmacia;

/* 1- ¿Qué vendedor ha realizado un pedido en el que no hay artículos (fármacos)?

  SELECT DISTINCT id_vendedor
  FROM pedido p
  INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
  LEFT JOIN farmaco f ON  dp.id_producto = f.Codigo
  WHERE f.Codigo is null;
*/

/* Hay dos clientes en la BD que comparten tlfno (tienen el mismo número) ¿De qué provincias son?
NOTA: da la respuesta con los nombres de las provincias separados por una coma y sin espacios en blanco adicionales.
SELECT provincia
FROM cliente
GROUP BY tlfno
HAVING COUNT(tlfno) = 2;
*/

/* Indica el nombre el nombre del fármaco que aparece en más pedidos indicando el número de pedidos en el que aparece.
NOTA: da la respuesta con el nombre del fármaco separado por una coma y sin espacios del número de pedidos en los que aparece. Ejemplo:
ASPIRINA,45

SELECT Nombre, COUNT(id_dp) AS 'Nº Ventas'
FROM farmaco
INNER JOIN detalles_pedido ON id_producto = Codigo
GROUP BY id_producto
HAVING COUNT(id_dp) = (SELECT(COUNT(id_pedido))
                              FROM detalles_pedido
                              GROUP BY id_producto
                              ORDER BY COUNT(id_pedido) DESC
                              LIMIT 1);

*/

/* EJERCICIO 4
¿En qué fecha se realizó el pedido con un mayor número de unidades totales (cantidad) de fármacos?
Da la respuesta en formato yyyy-mm-dd

SELECT f_pedido
FROM pedido p
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
GROUP BY dp.id_pedido
ORDER BY SUM(cantidad) DESC
LIMIT 1;

+------------+
| f_pedido   |
+------------+
| 2013-09-22 |
+------------+

*/

/* EJERCICIO 5
¿Cuántos productos tienen más de un fabricante (mismo nombre de fármaco pero diferente fabricante)?
SELECT Codigo
FROM farmaco
GROUP BY Fabricante
HAVING COUNT(Codigo) > 1;
*/

/* EJERCICIO 6
Indica el id de los clientes que han realizado algún pedido que incluya más de 18 unidades del fármaco ENEMOL.
SELECT id_cliente
FROM pedido p
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE cantidad > 18 AND f.Nombre like 'ENEMOL';
*/

/* EJERCICIO 7
Nombre de los fármacos vendidos a clientes de Madrid y no de Barcelona entre el 1 y el 3 de enero de 2017.
SELECT f.Nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN provincia pr ON c.provincia = pr.id_provincia
WHERE pr.nombre like 'MADRID' AND f_pedido BETWEEN '2017-01-01' AND '2017-01-03';
*/

/* EJERCICIO 8

Indica el código de dos letras (cod_pais) del pais que no tiene abreviatura ni empresas farmacéuticas (fabricantes);
SELECT cod_pais
FROM pais p
WHERE abreviatura like "" AND id_pais NOT IN (SELECT pais
                                              FROM fabricante);
*/

/* EJERCICIO 9
Indica cuántos Supositorios (Formato_Simple 'Supositorio') han vendido los fabricantes cuyo nombre comienza por PHARMA en la ccaa de 'CASTILLA Y LEON'
SELECT COUNT(Codigo)
FROM farmaco f
INNER JOIN fabricante fa ON f.Fabricante = fa.id_fabricante
INNER JOIN provincia p ON
WHERE Formato_Simple like 'Supositorio'
  AND f.Fabricante like 'PHARMA%';
 */

 /* EJERCICIO 10
 ¿Cuántos clientes no han realizado ningún pedido?
 SELECT COUNT(id_cliente) AS "Numero de clientes"
 FROM cliente
 WHERE id_cliente NOT IN (SELECT id_cliente
                          FROM pedido);

 */

/* EJERCICIO 11
Suponiendo un stock inicial de mil unidades del fármaco más vendido indica con una consulta el nombre de dicho
fármaco y cuántas unidades quedarían ahora en stock. NOTA: aunque no es lo más correcto se permite hacer uso de LIMIT 1 en este ejercicio.
SELECT Nombre, (1000 - COUNT(Codigo)) 'Stock Restante'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
GROUP BY p.id_pedido
ORDER BY COUNT(Codigo) DESC
LIMIT 1;
*/


/* EJERCICIO 12
¿Qué fármacos cuya primera letra de su nombre es la T ha vendido Steve Wozniak en Diciembre de 2016 y nunca ha vendido Paul Allen?
Da el resultado separado por comas y sin espacios en blanco salvo los que puedan ir incluidos en el propio nombre del fármaco.
SELECT Nombre
FROM farmaco
WHERE Nombre like 'T%' AND
 */

/* EJERCICIO 13
SELECT p.nombre, COUNT(Codigo)
FROM pais p
INNER JOIN fabricante fb ON p.id_pais = fb.pais
INNER JOIN farmaco f ON fb.id_fabricante = f.fabricante
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
WHERE f.Fecha_Registro > '2016-08-01'
GROUP BY dp.id_producto
HAVING COUNT(Codigo) = (SELECT COUNT(Codigo)
                        FROM pais p
                        INNER JOIN fabricante fb ON p.id_pais = fb.pais
                        INNER JOIN farmaco f ON fb.id_fabricante = f.fabricante
                        INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
                        WHERE f.Fecha_Registro > '2016-08-01'
                        GROUP BY dp.id_producto
                        ORDER BY COUNT(Codigo) DESC
                        LIMIT 1
                      );
 */

/* EJERCICIO 14
SELECT COUNT(*) AS 'Farmacos diferentes'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
WHERE f_pedido > any (SELECT f_pedido
                      FROM pedido p
                      INNER JOIN cliente c ON p.id_cliente = c.id_cliente
                      INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                      WHERE pro.nombre like 'CEUTA' OR pro.nombre like 'MELILLA');
 */

 /* EJERCICIO 15
SELECT DISTINCT id_fabricante
FROM fabricante fab
INNER JOIN farmaco fa ON fab.id_fabricante = fa.fabricante
INNER JOIN detalles_pedido dp ON fa.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
INNER JOIN ccaa ON pro.id_ca = ccaa.id_ca
WHERE ccaa.Nombre like 'ANDALUCIA' AND f_pedido < '2009-01-01'
ORDER BY fab.id_fabricante;
*/

/* EJERCICIO 16
SELECT f.nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
WHERE v.nombre like 'Steve Wozniak'
  AND f.nombre NOT IN(SELECT f.nombre
      FROM farmaco f
      INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
      INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
      INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
      WHERE v.nombre LIKE 'Paul Allen')
GROUP BY id_producto
HAVING SUM(cantidad) > 80;
*/
