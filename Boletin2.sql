
DROP DATABASE IF exists PracticasExamenCursores
create database PracticasExamenCursores
use PracticasExamenCursores

/**
actividad 1
*/
drop table if exists prestamos,libros ,socios

create table  socios (
	dni varchar(10) primary key not null, 
	nombre varchar(10) not null,
	direccion varchar(10) not null,
	penalizaciones int default 0
);
create table libros (
	refLibro  varchar(10) primary key not null,
	nombre varchar(10) not null,
	autor varchar (30 )not null,
	genero varchar(10) not null,
	anyoPublicacion int,
	editorial varchar(10)

)
create table prestamos (
	dni varchar (10) not null ,
	refLibro varchar (10)  not null ,
	fechaPrestamo date,
	duracion int,
	primary key (dni,refLibro,fechaPrestamo),
	foreign key (dni) references socios(dni),
	foreign key (refLibro) references libros(refLibro)
)
insert into socios (dni, nombre, direccion, penalizaciones) 
values 
('123456789A', 'Juan', 'Calle1', 0),
('987654321B', 'Maria', 'Calle2', 1),
('567890123C', 'Carlos', 'Calle3', 2);

insert into libros (refLibro, nombre, autor, genero, anyoPublicacion, editorial) 
values 
('L001', 'Libro1', 'Autor1', 'Ficcion', 2015, 'Ed1'),
('L002', 'Libro2', 'Autor2', 'Drama', 2020, 'Ed2'),
('L003', 'Libro3', 'Autor3', 'Ciencia', 2018, 'Ed3')


insert into prestamos (dni, refLibro, fechaPrestamo, duracion) 
values 
('987654321B', 'L001', '2024-01-02', 15),
('123456789A', 'L001', '2024-01-01', 15),
('987654321B', 'L002', '2024-02-01', 30),
('567890123C', 'L003', '2024-03-01', 20);

go

CREATE or alter  PROCEDURE listadocuatromasprestados 
AS
BEGIN
declare @nombreLib varchar(255),@numeroPrestamos int  , @genero varchar(255)

declare ccLibros cursor for 
select TOP(4) lib.nombre ,count(pre.refLibro)as numeroPrestamos ,lib.genero from prestamos as  pre
inner join libros as  lib
on pre.refLibro = lib.refLibro
group by lib.nombre ,lib.genero
order by count(pre.fechaPrestamo) desc 
open ccLibros

fetch ccLibros into  @nombreLib,@numeroPrestamos,@genero
while (@@FETCH_STATUS = 0 ) 
begin
	 print   'nombre: '  + @nombreLib + ' numeroPrestamos ' + cast (@numeroPrestamos as varchar(20) )+ ' genero '   + @genero 
	 

			declare  @nombre varchar (255), @fechaPrestamo date
		    declare ccPrestamo cursor for 
					 select soc.nombre , pre.fechaPrestamo from prestamos  as  pre
						inner join socios as  soc 
						on pre.dni = soc.dni
						where refLibro= ( select refLibro from libros where nombre =@nombreLib)
	        open ccPrestamo
			fetch ccPrestamo into @nombre,@fechaPrestamo
			while (@@FETCH_STATUS = 0 ) 
			begin
				  print   'informacion del prestamo nombre:'  + @nombre + ' fechaPrestamo '  +  cast (@fechaPrestamo as varchar (255))
				  fetch ccPrestamo into @nombre,@fechaPrestamo
			end
				close ccPrestamo
	            deallocate ccPrestamo

	 fetch ccLibros into   @nombreLib,@numeroPrestamos,@genero

end
close ccLibros
deallocate ccLibros
END

exec listadocuatromasprestados
GO

/**
Actidad 2
*/
DROP TABLE IF EXISTS NOTAS,ALUMNOS,ASIGNATURAS

CREATE TABLE ALUMNOS(
DNI VARCHAR(30),
NOMBRE VARCHAR(30),
DIRECCION VARCHAR(30),
POBLACION VARCHAR(30),
TELEFONO VARCHAR(30)
CONSTRAINT pkALUMNOS PRIMARY KEY (DNI)

)

CREATE TABLE ASIGNATURAS (
COD INT ,
NOMBRE VARCHAR(30) 
CONSTRAINT pkASIGNATURAS PRIMARY KEY (COD)
) 

CREATE TABLE NOTAS (
DNIALUMNO VARCHAR(30),
CODASIGNATURA  INT,
NOTA INT 
CONSTRAINT pkNOTAS PRIMARY KEY (DNIALUMNO,CODASIGNATURA),
CONSTRAINT FKNOTASDNIALUMNO FOREIGN KEY (DNIALUMNO) REFERENCES ALUMNOS(DNI),
CONSTRAINT FKNOTASCODASIGNATURA FOREIGN KEY (CODASIGNATURA) REFERENCES ASIGNATURAS(COD)
)


-- Inserción de datos en ASIGNATURAS
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (1, 'Prog. Leng. Estr.');
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (2, 'Sist. Informáticos');
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (3, 'Análisis');
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (4, 'FOL');
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (5, 'RET');
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (6, 'Entornos Gráficos');
INSERT INTO ASIGNATURAS (COD, NOMBRE) VALUES (7, 'Aplic. Entornos 4ªGen');

-- Inserción de datos en ALUMNOS
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('12344345', 'Alcalde García, Elena', 'C/Las Matas, 24', 'Madrid', '917766545');
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('4448242', 'Cerrato Vela, Luis', 'C/Mina 28 - 3A', 'Madrid', '916566545');
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('56882942', 'Díaz Fernández, María', 'C/Luis Vives 25', 'Móstoles', '915577545');
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('56882912', 'Díaz Fernández, PACO', 'C/Luis Vives 25', 'Móstoles', '915577545');
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('56822912', 'Díaz Fernández, PEPE', 'C/Luis Vives 25', 'Móstoles', '915577545');
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('56382912', 'Díaz Fernández, JUAN', 'C/Luis Vives 25', 'Móstoles', '915577545');
INSERT INTO ALUMNOS (DNI, NOMBRE, DIRECCION, POBLACION, TELEFONO) 
VALUES ('56282912', 'Díaz Fernández, JORGE', 'C/Luis Vives 25', 'Móstoles', '915577545');
-- Inserción de datos en NOTAS
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('56882912', 7, 6);
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('56282912', 7, 5);
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('56382912', 7, 3);

INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('4448242', 4, 6);
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('4448242', 5, 8);
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('4448242', 7, 5);

INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('56882942', 5, 7);
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('56882942', 6, 8);
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('56882942', 7, 9);

INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('12344345', 7, 1); 
INSERT INTO NOTAS (DNIALUMNO, CODASIGNATURA, NOTA) VALUES ('4448242', 7, 7); 

GO
CREATE OR ALTER PROCEDURE NOTASPORASIGNATURA 
	@nombreAsignatura VARCHAR(255)
AS
BEGIN
/*VARIABLES */
DECLARE @SUSPENSOS INT =0,@APROBADOS INT =0 ,@NOTAMASALTANOMBRE VARCHAR(255),@NOTAMASALTA INT =0 ,@NOTAMASBAJANOMBRE VARCHAR(255),@NOTAMASBAJA INT=10
/*VARIABLES CURSOR */
DECLARE @NOMBRE VARCHAR(255),@NOTA INT 
DECLARE CCNOTAS CURSOR FOR 
SELECT NOMBRE ,NOTA FROM NOTAS AS N
INNER JOIN ALUMNOS AS A
ON N.DNIALUMNO = A.DNI
WHERE CODASIGNATURA=(SELECT COD FROM ASIGNATURAS WHERE NOMBRE = @nombreAsignatura) ORDER BY NOTA DESC , NOMBRE  ASC
OPEN CCNOTAS
FETCH CCNOTAS INTO @NOMBRE,@NOTA
WHILE (@@FETCH_STATUS=0)
BEGIN 
PRINT 'NOMBRE DEL ALUMNO: ' + @NOMBRE + ' NOTA: '  + CAST(@NOTA AS VARCHAR(255))
	IF @NOTA>=5
	BEGIN
		SET @APROBADOS=@APROBADOS+1
	END

	ELSE 
	BEGIN
		SET @SUSPENSOS = @SUSPENSOS+1
	END

	IF @NOTA>@NOTAMASALTA
	BEGIN
		SET @NOTAMASALTA=@NOTA 
		SET @NOTAMASALTANOMBRE=@NOMBRE
	END

	IF @NOTA<@NOTAMASBAJA
	BEGIN
		SET @NOTAMASBAJA=@NOTA 
		SET @NOTAMASBAJANOMBRE=@NOMBRE
	END
FETCH CCNOTAS INTO @NOMBRE,@NOTA
END
CLOSE CCNOTAS
DEALLOCATE CCNOTAS
PRINT  'NUM APROBADOS : '  + CAST(@APROBADOS AS VARCHAR(255)) +  ' NUM SUSP : '  + CAST(@SUSPENSOS AS VARCHAR(255))
PRINT 'NOTA MAS BAJA : ' + @NOTAMASBAJANOMBRE + ' NOTA: '  + CAST(@NOTAMASBAJA AS VARCHAR(255))
PRINT 'NOTA MAS ALTA : ' + @NOTAMASALTANOMBRE + ' NOTA: '  + CAST(@NOTAMASALTA AS VARCHAR(255))
END

EXEC NOTASPORASIGNATURA 'Aplic. Entornos 4ªGen'
GO 
/**
Actividad 3
*/
DROP TABLE IF EXISTS VENTAS,PRODUCTOS

CREATE TABLE PRODUCTOS (
CODPRODUCTO VARCHAR(10),
NOMBRE VARCHAR(100) NOT NULL,
LINEADEPRODUCTO VARCHAR(100),
PRECIOUNITARIO MONEY,
STOCK INT ,
CONSTRAINT PKCODPRODUCTO PRIMARY KEY (CODPRODUCTO)
)

CREATE TABLE VENTAS(
CODVENTA VARCHAR(10),
CODPRODUCTO VARCHAR(10),
FECHA DATE,
UNIDADESVENDIDADAS INT DEFAULT 1
CONSTRAINT PKVENTAS PRIMARY KEY (CODVENTA)
CONSTRAINT FKVENTASCODPRODUCTO FOREIGN KEY (CODPRODUCTO) REFERENCES PRODUCTOS(CODPRODUCTO)

)

INSERT INTO productos VALUES ('1','Procesador P133', 'Proc',15000,20);
INSERT INTO productos VALUES ('2','Placa base VX',   'PB',  18000,15);
INSERT INTO productos VALUES ('3','Simm EDO 16Mb',   'Memo', 7000,30);
INSERT INTO productos VALUES ('4','Disco SCSI 4Gb',  'Disc',38000, 5);
INSERT INTO productos VALUES ('5','Procesador K6-2', 'Proc',18500,10);
INSERT INTO productos VALUES ('6','Disco IDE 2.5Gb', 'Disc',20000,25);
INSERT INTO productos VALUES ('7','Procesador MMX',  'Proc',15000, 5);
INSERT INTO productos VALUES ('8','Placa Base Atlas','PB',  12000, 3);
INSERT INTO productos VALUES ('9','DIMM SDRAM 32Mb', 'Memo',17000,12);
 
INSERT INTO ventas VALUES('V1', '2', '22/09/97',2);
INSERT INTO ventas VALUES('V2', '4', '22/09/97',1);
INSERT INTO ventas VALUES('V3', '6', '23/09/97',3);
INSERT INTO ventas VALUES('V4', '5', '26/09/97',5);
INSERT INTO ventas VALUES('V5', '9', '28/09/97',3);
INSERT INTO ventas VALUES('V6', '4', '28/09/97',1);
INSERT INTO ventas VALUES('V7', '6', '02/10/97',2);
INSERT INTO ventas VALUES('V8', '6', '02/10/97',1);
INSERT INTO ventas VALUES('V9', '2', '04/10/97',4);
INSERT INTO ventas VALUES('V10','9', '04/10/97',4);
INSERT INTO ventas VALUES('V11','6', '05/10/97',2);
INSERT INTO ventas VALUES('V12','7', '07/10/97',1);
INSERT INTO ventas VALUES('V13','4', '10/10/97',3);
INSERT INTO ventas VALUES('V14','4', '16/10/97',2);
INSERT INTO ventas VALUES('V15','3', '18/10/97',3);
INSERT INTO ventas VALUES('V16','4', '18/10/97',5);
INSERT INTO ventas VALUES('V17','6', '22/10/97',2);
INSERT INTO ventas VALUES('V18','6', '02/11/97',2);
INSERT INTO ventas VALUES('V19','2', '04/11/97',3);
INSERT INTO ventas VALUES('V20','9', '04/12/97',3);

SELECT  LINEADEPRODUCTO FROM productos GROUP BY LINEADEPRODUCTO





GO
CREATE OR ALTER PROCEDURE VENTASPORLINEAPRODUCTOS
AS
BEGIN
DECLARE @NOMBRE  VARCHAR(100),  @UNIDADESVENDIDADAS INT , @Importe MONEY, @Importetotal MONEY
DECLARE @LINEADEPRODUCTO  VARCHAR(100)
DECLARE CCLINEADEPRODUCTO CURSOR FOR 
SELECT DISTINCT  LINEADEPRODUCTO FROM productos GROUP BY LINEADEPRODUCTO
OPEN CCLINEADEPRODUCTO
FETCH CCLINEADEPRODUCTO INTO @LINEADEPRODUCTO
WHILE(@@FETCH_STATUS=0)
BEGIN
set @Importetotal=0
PRINT 'LINEA PRODUCTO ' + @LINEADEPRODUCTO

DECLARE CCVENTAS CURSOR FOR 
SELECT NOMBRE,SUM(UNIDADESVENDIDADAS) AS VENTAS ,SUM(PRECIOUNITARIO*UNIDADESVENDIDADAS) AS ImporteTotal  FROM ventas AS V 
INNER JOIN  productos AS P
ON P.CODPRODUCTO = V.CODPRODUCTO
WHERE LINEADEPRODUCTO =@LINEADEPRODUCTO
GROUP BY NOMBRE
OPEN CCVENTAS
FETCH CCVENTAS INTO @NOMBRE,@UNIDADESVENDIDADAS,@Importe
WHILE (@@FETCH_STATUS=0)

BEGIN
PRINT '    NOMBRE ' + @NOMBRE +  ' UNIDADES VENDIDAS ' + CAST(@UNIDADESVENDIDADAS AS VARCHAR(255))+ ' IMPORTE TOTAL ' + CAST (@Importe AS VARCHAR(255))

set @Importetotal=@Importetotal+@Importe
FETCH CCVENTAS INTO @NOMBRE,@UNIDADESVENDIDADAS,@Importe
END
CLOSE CCVENTAS
DEALLOCATE CCVENTAS
print 'importe total: ' +  cast (@Importetotal as varchar (255))
print ''
FETCH CCLINEADEPRODUCTO INTO @LINEADEPRODUCTO

END 

CLOSE CCLINEADEPRODUCTO
DEALLOCATE CCLINEADEPRODUCTO
END
GO

EXEC VENTASPORLINEAPRODUCTOS