INSERT INTO CLIENTE(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('11111111A', 'Jose', 'Perez Perez', '1974-08-01', 'C/Lepanto nº25 5ºB', '30001');
INSERT INTO CLIENTE(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('22222222B', 'Maria', 'Sanchez Sanchez', '1985-03-25', 'C/Cervantes nº1 2ºA', '30001');
INSERT INTO CLIENTE(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('33333333C', 'Pedro', 'Martinez Lopez', '1995-06-10', 'C/Medina nº15 1ºC', '30009');
INSERT INTO CLIENTE(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('44444444D', 'Juan', 'Flores Puerta', '1991-04-12', 'C/Velazquez nº20 4ºD', '30008');

INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0001', '11111111A', '2012-02-01', 2800);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0002', '11111111A', '2012-03-02', 1500);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0003', '11111111A', '2012-08-15', 800);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0004', '22222222B', '2013-09-20', 3000);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0005', '22222222B', '2013-10-02', 900);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0006', '33333333C', '2013-11-15', 2500);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0007', '44444444D', '2014-02-02', 520);
INSERT INTO FACTURA(Cod_Fac, DNI, Fecha_Fac, Importe) VALUES ('F-0008', '44444444D', '2015-02-04', 2500);

INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-10', 'Elevador potencia', 60, 50);
INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-80', 'Condensador RJW', 20, 200);
INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-77', 'Placa Base ASUS 1155', 50, 35);
INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-100', 'SAI 1500VA-Salicru', 500, 8);
INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-101', 'Condensador RJW', 20, 200);
INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-120', 'Ventilador led enermax', 10, 55);
INSERT INTO ARTICULO(Cod_Art, Descripcion, Precio, Stock) VALUES ('ART-250', 'Condensador RJW', 250, 40);

INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0001', 'F-0001', '2012-01-10', 'ART-250', 10);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0002', 'F-0001', '2012-01-20', 'ART-120', 30);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0003', 'F-0002', '2012-02-15', 'ART-100', 3);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0004', 'F-0003', '2012-04-03', 'ART-80', 25);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0005', 'F-0003', '2012-06-15', 'ART-120', 10);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0006', 'F-0003', '2012-07-25', 'ART-77', 4);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0007', 'F-0004', '2013-09-20', 'ART-10', 50);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0008', 'F-0005', '2013-10-02', 'ART-10', 15);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0009', 'F-0006', '2013-11-15', 'ART-100', 5);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0010', 'F-0007', '2014-02-01', 'ART-101', 1);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0011', 'F-0007', '2014-02-02', 'ART-100', 1);
INSERT INTO ALBARAN(Cod_Alb, Cod_Fac, Fecha_Alb, Cod_Art, Cantidad) VALUES ('A-0012', 'F-0008', '2015-02-04', 'ART-100', 5);

INSERT INTO COMERCIAL(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('55555555E', 'Berta', 'Fuertes Ruiz', '1980-08-01', 'C/Medina nº40 3ºA', '30008');
INSERT INTO COMERCIAL(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('66666666F', 'Luis', 'Perez Martinez', '1983-02-23', 'C/Picasso nº3 7ºC', '30001');
INSERT INTO COMERCIAL(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('77777777G', 'Ramon', 'Lucas Sanchez', '1995-06-12', 'C/Nadal nº14 1ºD', '30009');
INSERT INTO COMERCIAL(DNI, Nombre, Apellidos, Fecha_Nac, Direccion, Cod_Postal) VALUES ('88888888H', 'Juana', 'Luna Puertas', '1991-05-15', 'C/Colon nº20 4ºD', '30007');

INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('11111111A', '66666666F', '2012-01-04');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('11111111A', '66666666F', '2012-06-01');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('22222222B', '66666666F', '2013-05-10');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('33333333C', '55555555E', '2014-07-12');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('33333333C', '66666666F', '2014-04-01');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('44444444D', '77777777G', '2012-02-07');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('44444444D', '66666666F', '2013-04-01');
INSERT INTO VISITA(DNI_Cli, DNI_Comercial, Fecha_Visita) VALUES ('44444444D', '55555555E', '2014-04-15');
