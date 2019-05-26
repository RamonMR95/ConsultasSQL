-- INTENTO 2

/* EJERCICIO 1
Mostrar el cliente que ha realizado el pedido de mayor valor monetario
SELECT c.nombre
FROM clientes c
INNER JOIN pedidos p USING(id_cliente)
INNER JOIN detalles_pedido dp USING(id_pedido)
INNER JOIN productos pro USING(id_producto)
WHERE dp.cantidad * pro.precio >= ALL(SELECT dp.cantidad * pro.precio
                                      FROM detalles_pedido dp
                                      INNER JOIN productos pro USING(id_producto));

+---------+
| nombre  |
+---------+
| ALBERTO |
+---------+
*/

/* EJERCICIO 2
Mostrar el empleado que ha realizado el pedido que tiene la mayor cantidad de un mismo producto.

SELECT DISTINCT e.nombre
FROM empleados e
INNER JOIN pedidos p USING(id_empleado)
INNER JOIN detalles_pedido dp USING(id_pedido)
GROUP BY id_producto
HAVING SUM(cantidad) = (SELECT MAX(quan)
                        FROM (SELECT SUM(cantidad) as quan
                              FROM detalles_pedido
                              GROUP BY id_producto) as T);

+--------+
| nombre |
+--------+
| MARIA  |
+--------+
*/

/* EJERCICIO 3
Mostrar los clientes que hayan realizado un pedido en el que pidan todos los productos disponibles en la empresa.


SELECT c.nombre
FROM clientes c
INNER JOIN pedidos p USING(id_cliente)
WHERE NOT EXISTS (SELECT pro.id_producto
                  FROM productos pro
                  WHERE pro.id_producto NOT IN (SELECT dp.id_producto
                                                FROM detalles_pedido dp
                                                INNER JOIN pedidos USING(id_pedido)
                                                INNER JOIN clientes c USING(id_cliente)));
*/
/* EJERCICIO 4
Mostrar los clientes que han efectuado un pedido posterior a alguno de los pedidos que ha
facturado el empleado EFREN .

SELECT DISTINCT c.nombre
FROM clientes c
INNER JOIN pedidos p USING(id_cliente)
INNER JOIN empleados e USING(id_empleado)
WHERE e.nombre NOT LIKE 'EFREN' AND
  p.fecha_Pedido > ANY(SELECT p.fecha_Pedido
                      FROM pedidos p
                      INNER JOIN empleados e USING(id_empleado)
                      WHERE e.nombre LIKE 'EFREN');
+--------+
| nombre |
+--------+
| PILI   |
+--------+
*/


/* EJERCICIO 5
Mostrar el cliente que ha adquirido el pedido con mayor precio medio por producto.
SELECT c.nombre
FROM clientes c
INNER JOIN pedidos p USING(id_cliente)
INNER JOIN detalles_pedido dp USING(id_pedido)
INNER JOIN productos pro USING(id_producto)
GROUP BY dp.id_producto
HAVING AVG(dp.cantidad * pro.precio) >= ALL (SELECT AVG(dp.cantidad * pro.precio)
                                              FROM detalles_pedido dp
                                              INNER JOIN pedidos p USING(id_pedido)
                                              INNER JOIN productos pro USING(id_producto)
                                              GROUP BY dp.id_producto);
+---------+
| nombre  |
+---------+
| ALBERTO |
+---------+
*/

/* EJERCICIO 6
Mostrar los pedidos que han sido atendidos por un empleado cuya ciudad es la misma que
la del cliente que ha realizado el pedido.

SELECT DISTINCT id_pedido
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
INNER JOIN empleados e ON p.id_empleado = e.id_empleado
WHERE c.ciudad = e.ciudad;


select distinct id_pedido from pedidos natural join clientes on pedidos.id_cliente = clientes.id_cliente
where (clientes.ciudad, id_pedido)
in (select empleados.ciudad, id_pedido from pedidos natural join empleados);
*/

/* EJERCICIO 7
Mostrar los nombres y la ciudad de los clientes y los empleados en una única tabla

(SELECT c.nombre, c.ciudad
FROM clientes c)
  UNION
(SELECT e.nombre, e.ciudad
FROM empleados e);

+---------+-----------+
| nombre  | ciudad    |
+---------+-----------+
| ALBERTO | Cartagena |
| PACO    | Lorca     |
| PILI    | Murcia    |
| PEPE    | Murcia    |
| RAMON   | Cartagena |
| EFREN   | Cartagena |
| JESUS   | Lorca     |
| MARIA   | Murcia    |
| ISA     | Murcia    |
| LUIS    | Murcia    |
| BELEN   | Murcia    |
+---------+-----------+
*/

/* EJERCICIO 8
Mostrar aquellos productos que aparecen en todos los pedidos realizados en los primeros 5 días de Febrero de 2019.

SELECT pro.nombre
FROM productos pro
INNER JOIN detalles_pedido dp USING(id_producto)
INNER JOIN pedidos p USING(id_pedido)
WHERE p.fecha_Pedido BETWEEN '2019-02-01' AND '2019-02-05';

+----------+
| nombre   |
+----------+
| PATATAS  |
| PERAS    |
| MANZANAS |
+----------+
*/

/* EJERCICIO 9
Mostrar los clientes que han pedido todos los productos que ha pedido ’PEPE’.

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

+--------+
| nombre |
+--------+
| PACO   |
+--------+
*/

/* EJERCICIO 10
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


+--------+
| nombre |
+--------+
| PACO   |
| PEPE   |
+--------+
*/




































/* */
