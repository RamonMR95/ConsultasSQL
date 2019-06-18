--Media de la cantidad de fármacos vendidos en cada línea de pedido por cada fabricantes cuyo nombre
--se compoNe exactamente de 2 letras.
--Da el resultado separado por comas y cON 4 decimales sin usar espacios en blanco;
SELECT id_fabricante, ROUND(AVG(dp.cantidad), 4)
FROM fabricante fa
INNER JOIN farmaco f ON f.fabricante = fa.id_fabricante
INNER JOIN detalles_pedido dp ON dp.id_producto = f.codigo
WHERE LENGTH(fa.nombre) = 2
GROUP BY id_fabricante;
