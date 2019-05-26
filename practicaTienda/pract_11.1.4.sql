/*
CREATE VIEW v_cli_fact
AS SELECT C.DNI, Nombre, Apellidos, Importe * 1.21 AS 'Interes Total'
FROM CLIENTE C
INNER JOIN FACTURA F ON C.DNI = F.DNI;
*/

/*
CREATE VIEW v_distrito_fact
AS SELECT C.Cod_Postal, SUM(Importe) AS 'Facturacion Total'
FROM CLIENTE C
INNER JOIN FACTURA F ON C.DNI = F.DNI
GROUP BY C.Cod_Postal;
*/
