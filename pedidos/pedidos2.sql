
-- CONSULTAS PEDIDOS 2

/* EJERCICIO 1
-- Mostrar el identificador y nombre de aquellos productos pedidos por ’PEPE’

SELECT p.id_producto, p.nombre
FROM productos p
INNER JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
INNER JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
INNER JOIN clientes c ON pe.id_cliente = c.id_cliente
WHERE c.nombre like 'PEPE';

+-------------+----------+
| id_producto | nombre   |
+-------------+----------+
|         201 | PATATAS  |
|         204 | PLATANOS |
+-------------+----------+
*/

/* EJERCICIO 2
-- Mostrar el identificador y nombre de aquellos productos NO pedidos por ’PEPE’

SELECT p.id_producto, p.nombre
FROM productos p
WHERE p.id_producto NOT IN (SELECT dp.id_producto
                            FROM detalles_pedido dp
                            INNER JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
                            INNER JOIN clientes c ON pe.id_cliente = c.id_cliente
                            WHERE c.nombre = 'PEPE');

+-------------+----------+
| id_producto | nombre   |
+-------------+----------+
|         202 | PERAS    |
|         203 | MANZANAS |
|         205 | NARANJAS |
+-------------+----------+
 */

/* EJERCICIO 3
-- Mostrar el identificador y nombre de aquellos productos que cuestan más que alguno de los que ha pedido ’PEPE’

SELECT p.id_producto, p.nombre
FROM productos p
WHERE p.precio > any (SELECT p.precio
                      FROM productos p
                      INNER JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
                      INNER JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
                      INNER JOIN clientes c ON pe.id_cliente = c.id_cliente
                      WHERE c.nombre like 'PEPE');

+-------------+----------+
| id_producto | nombre   |
+-------------+----------+
|         202 | PERAS    |
|         203 | MANZANAS |
|         204 | PLATANOS |
|         205 | NARANJAS |
+-------------+----------+
*/

/* EJERCICIO 4
-- Mostrar pedidos con su fecha en los que no aparece ningún producto.

SELECT p.id_pedido, p.fecha_Pedido
FROM pedidos p
LEFT JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
WHERE dp.id_producto IS NULL;

+-----------+--------------+
| id_pedido | fecha_Pedido |
+-----------+--------------+
|       106 | 2019-02-13   |
+-----------+--------------+
 */

/* EJERCICIO 5
-- Mostrar los nombres de empleados o clientes que viven en Murcia

(SELECT c.nombre
FROM clientes c
WHERE c.ciudad like 'MURCIA')
UNION
(SELECT e.nombre
FROM empleados e
WHERE e.ciudad like 'MURCIA');

+--------+
| nombre |
+--------+
| PILI   |
| PEPE   |
| MARIA  |
| ISA    |
| LUIS   |
| BELEN  |
+--------+
 */

/* EJERCICIO 6
-- Mostrar los nombres de empleados o clientes que viven en Murcia y la calle en la que viven

(SELECT c.nombre, c.calle
FROM clientes c
WHERE c.ciudad like 'MURCIA')
UNION
(SELECT e.nombre, e.calle
FROM empleados e
WHERE e.ciudad like 'MURCIA');

+--------+----------+
| nombre | calle    |
+--------+----------+
| PILI   | BIDINOSA |
| PEPE   | LOTAS    |
| MARIA  | BAJA     |
| ISA    | LADA     |
| LUIS   | AMAN     |
| BELEN  | CERIA    |
+--------+----------+
*/

/* EJERCICIO 7
-- Mostrar ciudades en las que viven empleados y no viven clientes.

SELECT e.ciudad
FROM empleados e
WHERE e.ciudad NOT IN (SELECT c.ciudad
                      FROM clientes c);

EMPTY SET
*/


/* EJERCICIO 8
-- Mostrar productos que no ha pedido PEPE.

SELECT p.nombre
FROM productos p
WHERE p.id_producto NOT IN (SELECT dp.id_producto
                            FROM detalles_pedido dp
                            INNER JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
                            INNER JOIN clientes c ON pe.id_cliente = c.id_cliente
                            WHERE NOMBRE LIKE 'PEPE');

+----------+
| nombre   |
+----------+
| PERAS    |
| MANZANAS |
| NARANJAS |
+----------+
*/


/* EJERCICIO 9
-- Mostrar los empleados que no han atendido ningún pedido utilizando el operador NOT IN.

SELECT e.nombre
FROM empleados e
WHERE e.id_empleado NOT IN (SELECT p.id_empleado
                            FROM pedidos p
                            WHERE id_empleado IS NOT NULL);

SELECT e.nombre
FROM empleados e
LEFT JOIN pedidos p ON e.id_empleado = p.id_empleado
WHERE p.id_empleado IS NULL;

+--------+
| nombre |
+--------+
| ISA    |
| LUIS   |
| BELEN  |
+--------+
*/

/* EJERCICIO 10
-- Fecha y número de empleados que han atendido algún pedido en cada día.

SELECT p.fecha_Pedido, COUNT(DISTINCT id_empleado) AS 'Nº Empleados'
FROM pedidos p
GROUP BY fecha_Pedido
HAVING COUNT(id_empleado) > 0;

+--------------+---------------+
| fecha_Pedido | Nº Empleados  |
+--------------+---------------+
| 2019-02-05   |             1 |
| 2019-02-06   |             2 |
| 2019-02-08   |             1 |
| 2019-02-11   |             1 |
+--------------+---------------+
*/
