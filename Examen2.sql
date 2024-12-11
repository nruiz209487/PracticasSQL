--CREATE database corredoresNeos
USE corredoresNeos

DROP TABLE IF exists corredores

/**TABLA */
CREATE TABLE corredores (
	id int IDENTITY(1,1) ,
	nombre varchar(255) not null,
	fechacnac date not null,
	dorsal int default 0
	constraint  pkcorredores primary key (id)  
)

/** INSERTS  */ 
insert into corredores(nombre,fechacnac) values ('Antonio','01/10/2023')
insert into corredores(nombre,fechacnac) values ('Jose','01/10/2023')
insert into corredores(nombre,fechacnac) values ('Maria','02/10/2000')
insert into corredores(nombre,fechacnac) values ('Juan','02/10/2000')
insert into corredores(nombre,fechacnac) values ('Julio','03/10/2000')
insert into corredores(nombre,fechacnac) values ('Maria','16/10/2000')
insert into corredores(nombre,fechacnac) values ('juan','16/10/2015')
insert into corredores(nombre,fechacnac) values ('Laura','16/10/2001')
insert into corredores(nombre,fechacnac) values ('Ana','16/10/2021')





go
CREATE OR ALTER PROCEDURE asignarDorsal
/** ASIGNACION DE VATIABLES PARA LOS DORSALES */
	@DorsalesMenoresDeEdad int = 1,
    @DorsalesMayoresDeEdad int = 1000
AS
BEGIN
SET NOCOUNT ON;

--DECLARACION CURSOR 
DECLARE @id int , @nombre varchar(255), @fechacnac date ,@dorsal int
DECLARE ccCorredores CURSOR FOR /*CONSULTA ORDENADA POR fechacnac,nombre */ select id, nombre ,fechacnac ,dorsal from corredores order by fechacnac desc ,nombre asc

--PRIMERA FILA
OPEN ccCorredores
FETCH ccCorredores INTO @id,@nombre,@fechacnac,@dorsal

--BUCLE
WHILE (@@FETCH_STATUS=0)
BEGIN

	if year(@fechacnac)< year(CURRENT_TIMESTAMP) -18 /**MAYOR DE EDAD */
	BEGIN
       update corredores
	   set dorsal=@DorsalesMayoresDeEdad
	   where id=@id
	   print  'El corredor  '  + @nombre  +' tiene asignado el dorsal '   +  cast (@DorsalesMayoresDeEdad /**NO LA CONSULTA POR QUE EL FETCH NO SE ACTUALIZA */ as varchar (255))
	   set @DorsalesMayoresDeEdad=@DorsalesMayoresDeEdad + 1 --SUMA 1 A LA VARIABLE @DorsalesMayoresDeEdad
	END

	ELSE  /**MENOR DE EDAD */
	BEGIN
       update corredores
	   set dorsal=@DorsalesMenoresDeEdad
	   where id=@id
	   print  'El corredor  '  + @nombre  +' tiene asignado el dorsal '   +  cast (@DorsalesMenoresDeEdad /**NO LA CONSULTA POR QUE EL FETCH NO SE ACTUALIZA */ as varchar (255))
	   set @DorsalesMenoresDeEdad=@DorsalesMenoresDeEdad + 1 --SUMA 1 A LA VARIABLE @DorsalesMenoresDeEdad
	  
	END


    --NUEVA FILA
	FETCH ccCorredores INTO @id, @nombre,@fechacnac,@dorsal
END

CLOSE ccCorredores
DEALLOCATE ccCorredores
END
GO

begin transaction 
--ANTES DEL PRCEDIMEIENTO
select *  from corredores  order by fechacnac desc ,nombre asc 
exec asignarDorsal
--DESPUES DEL PRCEDIMEIENTO
select *  from corredores  order by fechacnac desc ,nombre asc 
rollback
