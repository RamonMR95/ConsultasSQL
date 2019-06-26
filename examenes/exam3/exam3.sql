
/*
 *  Examen Junio MYSQL
 *  @author - Ramón Moñino Rubio
 *  Github - RamonMR95
 */

 /* EJERCICIO 1 */
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

/* EJERCICIO 2 */
-- ¿Fecha de nacimiento del vendedor que ha realizado el pedido en el que hay la mayor
-- cantidad vendida de medicamentos FOLINATO DE CALCIO?

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


/* EJERCICIO 3 */
-- Mostrar, ordenado por orden alfabético, el nombre de los fabricantes que tienen su sede en
-- alguno de los países de los cuales proceden los vendedores y que además tengan 'FARMA'
-- como parte de su nombre.

SELECT fa.nombre
FROM fabricante fa
WHERE fa.pais IN (SELECT v.pais
                  FROM vendedor v)
      AND fa.nombre LIKE '%FARMA%'
ORDER BY fa.nombre;

/* EJERCICIO 4 */
-- Mostrar los fármacos cuyo IVA (tabla farmaco) es diferente al IVA que se le ha aplicado en
-- alguno de los pedidos (tabla detalles_pedido).

SELECT f.nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
WHERE f.IVA != dp.IVA;


/* EJERCICIO 5 */
-- Número más alto de unidades (cantidad) solicitadas en un único pedido de los fármacos fabricados
-- en 'RUSIA' (el fabricante es de Rusia) desde agosto de 2016 hasta la fecha actual y no han
-- sido nunca fabricados en 'RUMANIA'.

SELECT SUM(cantidad)
FROM detalles_pedido dp
INNER JOIN farmaco f ON dp.id_producto = f.Codigo
INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
INNER JOIN pedido USING(id_pedido)
INNER JOIN pais pa ON fa.pais = pa.id_pais
WHERE f_pedido > '2016-08-01'
  AND pa.nombre LIKE 'RUSIA'
  AND id_producto NOT IN (SELECT f.Codigo
                          FROM farmaco f
                          INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                          INNER JOIN pais pa ON fa.pais = pa.id_pais
                          WHERE pa.nombre LIKE 'RUMANIA')
GROUP BY dp.id_pedido
HAVING SUM(dp.cantidad) >= ALL (SELECT SUM(dp.cantidad)
                                FROM detalles_pedido dp
                                INNER JOIN farmaco f ON dp.id_producto = f.Codigo
                                INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                                INNER JOIN pedido USING(id_pedido)
                                INNER JOIN pais pa ON fa.pais = pa.id_pais
                                WHERE f_pedido > '2016-08-01'
                                  AND pa.nombre LIKE 'RUSIA'
                                  AND id_producto NOT IN (SELECT f.Codigo
                                                          FROM farmaco f
                                                          INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
                                                          INNER JOIN pais pa ON fa.pais = pa.id_pais
                                                          WHERE pa.nombre LIKE 'RUMANIA')
                                GROUP BY dp.id_pedido);



/* EJERCICIO 6 */
-- ¿Cuántos clientes no han realizado ningún pedido?

SELECT COUNT(id_cliente) AS "Numero de clientes"
FROM cliente
WHERE id_cliente NOT IN (SELECT id_cliente
                         FROM pedido);

/* EJERCICIO 7 */
-- Nombre de los fármacos cuyo nombre finaliza por la letra N vendidos a clientes de Madrid y de Barcelona
-- entre el 1 y el 3 de enero de 2017.

SELECT DISTINCT f.nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN provincia pro ON c.Provincia = pro.id_provincia
WHERE f.nombre LIKE '%N'
	AND (pro.nombre LIKE 'MADRID'
	OR pro.nombre LIKE 'BARCELONA');

/* EJERCICIO 8 */
-- Mostrar el numero de farmacos total sumando los de PFIZER, BAYER y ROCHE que se presenten en forma simple
-- de Tableta o de Cápsula.

SELECT COUNT(f.Codigo)
FROM farmaco f
INNER JOIN fabricante fa ON f.fabricante = fa.id_fabricante
WHERE (fa.nombre LIKE 'PFIZER'
  OR fa.nombre LIKE 'BAYER'
  OR fa.nombre LIKE 'ROCHE')
  AND (f.Formato_Simple LIKE 'Tableta'
  OR f.Formato_Simple LIKE 'Capsula');

/* EJERCICIO 9 */
-- Hallar el nombre del empleado que ha realizado pedido de menor coste de todos los realizados.

SELECT v.nombre
FROM vendedor v
INNER JOIN pedido p ON v.cod_vendedor = p.id_vendedor
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
GROUP BY dp.id_pedido
HAVING SUM(dp.cantidad * precio ) <= ALL (SELECT SUM(dp.cantidad * precio)
                    										  FROM detalles_pedido dp
                                          INNER JOIN pedido p USING(id_pedido)
                                          INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
                    										  GROUP BY dp.id_pedido);


/* EJERCICIO 10 */
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

/* EJERCICIO 11 */
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


/* EJERCICIO 12 */
-- ¿Qué fármacos ha vendido Steve Wozniak en cantidad superior a 80 unidades y no ha vendido nunca ninguna
-- unidad de ellos Paul Allen?

SELECT f.nombre
FROM farmaco f
INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
WHERE v.nombre LIKE 'Steve Wozniak'
  AND f.nombre NOT IN(SELECT f.nombre
                      FROM farmaco f
                      INNER JOIN detalles_pedido dp ON f.Codigo = dp.id_producto
                      INNER JOIN pedido p ON dp.id_pedido = p.id_pedido
                      INNER JOIN vendedor v ON p.id_vendedor = v.cod_vendedor
                      WHERE v.nombre LIKE 'Paul Allen')
GROUP BY id_producto
HAVING SUM(cantidad) > 80;
