/* EJERCICIO 1
Se desea realizar un trigger de tipo AFTER que actualice el stock de artículo
al insertar un albarán.
*/
DELIMITER //
CREATE TRIGGER update_stock_insert AFTER INSERT ON ALBARAN
FOR EACH ROW
BEGIN
  UPDATE ARTICULO
    SET ARTICULO.stock = ARTICULO.stock - NEW.cantidad
    WHERE ARTICULO.Cod_Art = NEW.Cod_Art;
END //
DELIMITER ;

/* EJERCICIO 2
Actualización del stock de articulo al borrar un albarán mediante Trigger AFTER.
*/
DELIMITER //
CREATE TRIGGER update_stock_delete AFTER DELETE ON ALBARAN
FOR EACH ROW
BEGIN
  UPDATE ARTICULO
    SET ARTICULO.stock = ARTICULO.stock + OLD.cantidad
    WHERE ARTICULO.Cod_Art = OLD.Cod_Art;
END //
DELIMITER ;

/* EJERCICIO 3
Actualización mediante Trigger AFTER del stock de articulo al actualizar
la cantidad de un albarán.
*/
DELIMITER //
CREATE TRIGGER update_stock AFTER UPDATE ON ALBARAN
FOR EACH ROW
BEGIN
  IF cantidad > NEW.cantidad THEN
  UPDATE ARTICULO
    SET ARTICULO.stock = ARTICULO.stock + OLD.cantidad
    WHERE ARTICULO.Cod_Art = OLD.Cod_Art;
  ELSEIF cantidad < NEW.cantidad THEN
  UPDATE ARTICULO
    SET ARTICULO.stock = ARTICULO.stock - OLD.cantidad
    WHERE ARTICULO.Cod_Art = OLD.Cod_Art;
  END IF;
END //
DELIMITER ;

/* EJERCICIO 4
Crear un trigger que al borrar una factura se borre los albaranes asociados
(e.d crear un trigger que emule un DELETE CASCADE).
*/
DELIMITER //
CREATE TRIGGER cascade_albaranes BEFORE DELETE ON FACTURA
FOR EACH ROW
BEGIN
 DELETE FROM ALBARAN
  WHERE ALBARAN.Cod_Fac = OLD.Cod_Fac;
END //
DELIMITER ;

/* EJERCICIO 5
Se desea llevar un control de las ventas realizadas en una tabla auxiliar de
auditoría t_audit_albaran. Se desea almacenar el cod_alb, el usuario de base
de datos, y el momento exacto de la venta. (Generar previamente a la creación
del trigger la tabla correspondiente).
*/
CREATE TABLE t_audit_albaran(
  id_audit int(5) AUTO_INCREMENT,
  Cod_Alb VARCHAR(6) NOT NULL,
  Usuario VARCHAR(255),
  Fecha TIMESTAMP,
  CONSTRAINT PK_audit
    PRIMARY KEY(id_audit)
);

DELIMITER //
CREATE TRIGGER control_ventas AFTER INSERT ON ALBARAN
FOR EACH ROW
BEGIN
  INSERT INTO t_audit_albaran VALUES(NEW.Cod_Alb, CURRENT_USER(), now());
END //
DELIMITER ;

/* EJERCICIO 6
Crear una tabla de logs y un trigger que genere un log con información de las 
modificaciones de precio de los artículos almacenando la fecha de modificación,
el precio antiguo y el nuevo.
*/
CREATE TABLE logs (
  id_logs int(9) AUTO_INCREMENT,
  fecha_mod TIMESTAMP,
  precio_antiguo int(9),
  precio_nuevo int(9),
  CONSTRAINT PK_LOGS
    PRIMARY KEY(id_logs)
);

DELIMITER //
CREATE TRIGGER log_informacion AFTER UPDATE ON ARTICULO
FOR EACH ROW
BEGIN
  INSERT INTO logs(fecha_mod, precio_antiguo, precio_nuevo)
    VALUES(now(), OLD.precio, NEW.precio);
END //
DELIMITER ;
