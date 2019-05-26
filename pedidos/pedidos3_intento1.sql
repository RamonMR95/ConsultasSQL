
-- INTENTO 1
/* EJERCICIO 1
Mostrar los clientes que han comprado patatas pero no han comprado plátanos
SELECT DISTINCT id_cliente
FROM pedidos p
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN productos ps ON dp.id_producto = ps.id_producto
WHERE ps.nombre like 'PATATAS' AND id_cliente NOT IN (SELECT DISTINCT id_cliente
                                                      FROM pedidos p
                                                      INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
                                                      INNER JOIN productos ps ON dp.id_producto = ps.id_producto
                                                      WHERE ps.nombre like 'PLATANOS');

*/

/* EJERCICIO 2
Mostrar la ciudad donde menos se ha vendido en unidades totales (contando duplicados del mismo producto)
SELECT c.ciudad
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
WHERE cantidad <= ALL (SELECT cantidad
                      FROM detalles_pedido);
*/

/* EJERCICIO 3
Mostrar los clientes que han pedido todos los productos que ha pedido 'PEPE'

select distinct nombre
from clientes c1
where nombre NOT LIKE 'PEPE'
AND NOT EXISTS ( select id_producto
                  from clientes c2 inner join pedidos p1 using (id_cliente)
                  inner join detalles_pedido dp1 using (id_pedido)
                  where c2.nombre = 'PEPE'
                  AND NOT EXISTS ( select id_producto
                                    from pedidos p2
                                    inner join detalles_pedido dp2 using (id_pedido )
                                    where dp2.id_producto = dp1.id_producto
                                    and p2.id_cliente = c1.id_cliente));
*/


/* EJERCICIO 4
Mostrar el empleado que ha facturado el pedido con mayor numero total de unidades
SELECT id_empleado
FROM pedidos p
INNER JOIN detalles_pedido dp using(id_pedido)
GROUP BY dp.id_pedido
HAVING SUM(dp.cantidad) >= ALL (SELECT SUM(dp.cantidad)
                                FROM detalles_pedido dp
                                GROUP BY dp.id_pedido);
 */


/* EJERCICIO 5
Mostrar los pedidos (identificador) en los cuales la ciudad del cliente y la del empleado que lo factura sea la misma ciudad.
SELECT DISTINCT id_pedido
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
WHERE c.ciudad = e.ciudad;
 */


/* EJERCICIO 6
Obtener el id_pedido, el nombre del cliente, el nombre de los productos y cantidad de los mismos para todos los pedidos
SELECT dp.id_pedido, c.nombre, dp.id_producto, dp.cantidad
FROM detalles_pedido dp
INNER JOIN pedidos p ON dp.id_pedido = p.id_pedido
INNER JOIN clientes c ON p.id_cliente = c.id_cliente;
*/

/* EJERCICIO 7
Mostrar la ciudad a la que se han enviado más plátanos. Supondremos que cada cliente recibe el pedido en su ciudad.
SELECT c.ciudad
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN productos pro ON dp.id_producto = pro.id_producto
WHERE pro.nombre LIKE 'PLATANOS'
GROUP BY c.ciudad
HAVING SUM(dp.cantidad) >= ALL (SELECT SUM(dp.cantidad)
                                FROM detalles_pedido dp
                                INNER JOIN productos pro ON dp.id_producto = pro.id_producto
                                WHERE pro.nombre LIKE 'PLATANOS'
                                GROUP BY dp.id_pedido);
*/

/* EJERCICIO 8
Mostrar los clientes que han efectuado un pedido con mayor cantidad de patatas que alguno de los pedidos que ha facturado el empleado MARIA.
SELECT DISTINCT p.id_cliente
FROM pedidos p
INNER JOIN detalles_pedido dp USING(id_pedido)
INNER JOIN productos pro USING(id_producto)
INNER JOIN empleados e USING(id_empleado)
WHERE pro.nombre LIKE 'PATATAS'
  AND e.nombre NOT LIKE 'MARIA'
  AND cantidad > any (SELECT cantidad
                      FROM pedidos p
                      INNER JOIN detalles_pedido dp USING(id_pedido)
                      INNER JOIN empleados e USING(id_empleado)
                      WHERE e.nombre LIKE 'MARIA'
                        AND pro.nombre LIKE 'PATATAS');
 */


/* EJERCICIO 9
Mostrar los clientes que han sido atendidos por todos los empleados de Cartagena
SELECT nombre
FROM clientes c1
WHERE NOT EXISTS (SELECT id_empleado
                  FROM empleados
                  WHERE ciudad LIKE 'Cartagena'
                    AND id_empleado NOT IN (SELECT id_empleado
                                            FROM pedidos p
                                            WHERE p.id_cliente=c1.id_cliente
                                              AND id_empleado IS NOT NULL));
*/


/* EJERCICIO 10
Mostrar los empleados de Murcia que han vendido menos de 100 unidades de productos, contando las repeticiones del mismo producto.

SELECT DISTINCT e.nombre
FROM empleados e
INNER JOIN pedidos p USING(id_empleado)
INNER JOIN detalles_pedido dp USING(id_pedido)
WHERE e.ciudad LIKE 'MURCIA'
GROUP BY dp.id_pedido
HAVING SUM(cantidad) < 100;
*/
