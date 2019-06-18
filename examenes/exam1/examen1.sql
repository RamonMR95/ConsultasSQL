USE CatalogoFarmacia;

/* EJERCICIO 1 */ -- OK
-- 1- ¿Qué vendedor ha realizado un pedido en el que no hay artículos (fármacos)?

SELECT v.nombre
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
WHERE id_pedido NOT IN (SELECT id_pedido
                        FROM detalles_pedido);



/* EJERCICIO 2 */ -- OK
-- Hay dos clientes en la BD que comparten tlfno (tienen el mismo número) ¿De qué provincias son? */
-- NOTA: da la respuesta con los nombres de las provincias separados por una coma y sin espacios en
-- blanco adicionales.

SELECT pro.nombre
FROM provincia pro
INNER JOIN cliente c ON pro.id_provincia = c.Provincia
WHERE c.tlfno IN (SELECT tlfno
                  FROM cliente
                  GROUP BY tlfno
                  HAVING COUNT(tlfno) = 2);


/* EJERCICIO 3 */
-- Indica el nombre el nombre del fármaco que aparece en más pedidos indicando el número de pedidos en el
-- que aparece.
-- NOTA: da la respuesta con el nombre del fármaco separado por una coma y sin espacios del número de
-- pedidos en los que aparece. Ejemplo:
-- ASPIRINA,45

SELECT f.nombre, COUNT(dp.id_dp) AS 'Nº Ventas'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
GROUP BY f.nombre
HAVING COUNT(dp.id_dp) >= ALL (SELECT COUNT(dp.id_dp)
                              FROM detalles_pedido dp
                              INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                              GROUP BY f.nombre);


/* EJERCICIO 4 */ -- OK
-- ¿En qué fecha se realizó el pedido con un mayor número de unidades totales (cantidad) de fármacos?
-- Da la respuesta en formato yyyy-mm-dd

SELECT f_pedido
FROM pedido p
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
GROUP BY dp.id_pedido
HAVING SUM(cantidad) >= ALL (SELECT SUM(cantidad)
                            FROM detalles_pedido dp
                            INNER JOIN pedido p USING(id_pedido)
                            GROUP BY dp.id_pedido);


/* EJERCICIO 5 */
-- ¿Cuántos productos tienen más de un fabricante (mismo nombre de fármaco pero diferente fabricante)?

SELECT COUNT(*)
FROM (SELECT f.nombre, COUNT(DISTINCT f.fabricante)
      FROM farmaco f
      GROUP BY f.nombre
      HAVING COUNT(DISTINCT f.fabricante)  > 1 ) AS T;


/* EJERCICIO 6 */
-- Indica el id de los clientes que han realizado algún pedido que incluya más de 18 unidades
-- del fármaco ENEMOL.

SELECT id_cliente
FROM pedido p
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE cantidad > 18 AND f.Nombre like 'ENEMOL';


/* EJERCICIO 7 */ -- OK
-- Nombre de los fármacos vendidos a clientes de Madrid y no de Barcelona entre el 1 y el 3
-- de enero de 2017.

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




/* EJERCICIO 8 */ -- OK
-- Indica el código de dos letras (cod_pais) del pais que no tiene abreviatura ni empresas
-- farmacéuticas (fabricantes);
SELECT cod_pais
FROM pais p
WHERE abreviatura like ""
  AND id_pais NOT IN (SELECT pais
                      FROM fabricante);


/* EJERCICIO 9  */
-- Indica cuántos Supositorios (Formato_Simple 'Supositorio') han vendido los fabricantes cuyo
-- nombre comienza por PHARMA en la ccaa de 'CASTILLA Y LEON'

SELECT SUM(dp.cantidad)
FROM farmaco f
INNER JOIN fabricante fa ON f.Fabricante = fa.id_fabricante
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido USING(id_pedido)
INNER JOIN cliente c USING(id_cliente)
INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
INNER JOIN ccaa ON pro.id_ca = ccaa.id_ca
WHERE f.Formato_Simple LIKE 'Supositorio'
  AND fa.nombre LIKE 'PHARMA%'
  AND ccaa.nombre LIKE 'CASTILLA Y LEON';



 /* EJERCICIO 10  */ -- OK
 -- ¿Cuántos clientes no han realizado ningún pedido?

 SELECT COUNT(id_cliente) AS "Numero de clientes"
 FROM cliente
 WHERE id_cliente NOT IN (SELECT id_cliente
                          FROM pedido);



/* EJERCICIO 11 */ -- OK
-- Suponiendo un stock inicial de mil unidades del fármaco más vendido indica con una consulta el
-- nombre de dicho fármaco y cuántas unidades quedarían ahora en stock. NOTA: aunque no es lo más
-- correcto se permite hacer uso de LIMIT 1 en este ejercicio.


SELECT f.nombre, (1000 - SUM(dp.cantidad)) AS 'Unidades Restantes'
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
GROUP BY f.Codigo
HAVING SUM(dp.cantidad) >= ALL (SELECT SUM(dp.cantidad)
                                FROM detalles_pedido dp
                                GROUP BY dp.id_producto);


/* EJERCICIO 12  */
-- ¿Qué fármacos cuya primera letra de su nombre es la T ha vendido Steve Wozniak en Diciembre
-- de 2016 y nunca ha vendido Paul Allen?
-- Da el resultado separado por comas y sin espacios en blanco salvo los que puedan ir
-- incluidos en el propio nombre del fármaco.

SELECT DISTINCT f.nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p USING(id_pedido)
INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
WHERE v.nombre LIKE 'Steve Wozniak'
  AND f_pedido BETWEEN '2016-12-01' AND '2016-12-31'
  AND f.nombre NOT IN (SELECT f.nombre
                        FROM farmaco f
                        INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
                        INNER JOIN pedido p USING(id_pedido)
                        INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
                        WHERE v.nombre LIKE 'Paul Allen');


/* EJERCICIO 13  */
-- Indica el país donde se han registrado (Fecha_Registro) más medicamentos diferentes
-- desde agosto de 2016 (inclusive)

SELECT pa.nombre, COUNT(f.Codigo)
FROM pais pa
INNER JOIN fabricante fa ON pa.id_pais = fa.pais
INNER JOIN farmaco f ON fa.id_fabricante = f.fabricante
WHERE f.Fecha_Registro >= '2016-08-01'
GROUP BY pa.nombre
HAVING COUNT(f.Codigo) >= ALL (SELECT COUNT(f.Codigo)
                              FROM farmaco f
                              INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                              INNER JOIN pais pa ON fa.pais = pa.id_pais
                              WHERE Fecha_Registro >= '2016-08-01'
                              GROUP BY pa.nombre);

 /* WHERE f.fecha_registro BETWEEN '2016/08/01' AND CURDATE() */

/* EJERCICIO 14 */ -- OK
-- ¿Cuántos fármacos diferentes (distinto nombre) se han vendido con fecha posterior a alguno de
-- los pedidos realizados bien en Ceuta bien en Melilla?

SELECT COUNT(DISTINCT(f.Codigo))
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p USING(id_pedido)
INNER JOIN cliente USING(id_cliente)
WHERE f_pedido >= ANY (SELECT f_pedido
                      FROM pedido p
                      INNER JOIN cliente c USING(id_cliente)
                      INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                      WHERE pro.nombre LIKE 'Ceuta' OR pro.nombre LIKE 'Melilla');


 /* EJERCICIO 15 */
-- Obtener los id de los fabricantes de cuyos fármacos se han realizado pedidos anteriores al
-- año 2009 para todas las provincias de Andalucía.
-- Da las respuestas separadas por comas, sin espacios en blanco y en orden ascendente (no
-- significa que la select tenga que devolverlas así, es simplemente para introducir las
-- respuestas en el cuestionario)..


SELECT DISTINCT f1.fabricante
FROM farmaco f1
WHERE NOT EXISTS(SELECT pr2.id_provincia
                  FROM provincia pr2
                  INNER JOIN ccaa ON ccaa.id_ca = pr2.id_ca
                  WHERE ccaa.nombre LIKE 'ANDALUCIA'
                    AND pr2.id_provincia NOT IN (SELECT pr2.id_provincia
                                                  FROM farmaco f
                                                  INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
                                                  INNER JOIN pedido p USING(id_pedido)
                                                  INNER JOIN cliente c USING(id_cliente)
                                                  INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
                                                  INNER JOIN ccaa ON ccaa.id_ca = pro.id_ca
                                                  WHERE YEAR(f_pedido) = '2009')
                                                    AND ccaa.nombre LIKE 'ANDALUCIA');

/* EJERCICIO 16 */
-- ¿Qué fármacos ha vendido Steve Wozniak en cantidad superior a 80 unidades y no ha
-- vendido nunca ninguna unidad de ellos Paul Allen?

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

/* EJERCICIO 17 */
-- Indica el nombre del empleado que ha vendido menos unidades de AMBROXIL

SELECT v.nombre
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
INNER JOIN detalles_pedido dp USING(id_pedido)
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
WHERE f.nombre LIKE 'AMBROXIL'
GROUP BY v.nombre
HAVING COUNT(dp.id_producto) <= ALL (SELECT COUNT(dp.id_producto)
                                      FROM detalles_pedido dp
                                      INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                                      INNER JOIN pedido p USING(id_pedido)
                                      INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
                                      WHERE f.nombre LIKE 'AMBROXIL'
                                      GROUP BY v.nombre);




/* EJERCICIO 18 */
-- ¿Qué vendedores han vendido los fármacos cuyo nombre comienza por 'ALE' en
-- todas las provincias?


/* EJERCICIO 19 */
-- ¿De qué provincias se han realizado los mismos o más pedidos que incluyan fármacos
-- que se vendan en Formato_Simple 'Supositorio' que fármacos en Formato_Simple 'Parche'
-- en cualquier otra provincia?

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

/* EJERCICIO 20 */
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
