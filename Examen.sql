use PracticasExamenCursores
DROP TABLE IF EXISTS AlumnosConBeca,AlumnosSolicitantes


CREATE TABLE AlumnosSolicitantes (
DNI VARCHAR  (10),
NOMBRE VARCHAR  (255),
NOTA DECIMAL(2),
CUANTIA MONEY 
CONSTRAINT  PKAlumnoSolicitante PRIMARY KEY (DNI)
)

CREATE TABLE AlumnosConBeca (
DNI VARCHAR  (10),
NOMBRE VARCHAR  (255),
CUANTIA VARCHAR  (255),
CONSTRAINT PKAlumnosConBeca  PRIMARY KEY (DNI),
CONSTRAINT FKAlumnosConBecaDNI FOREIGN KEY (DNI) REFERENCES  AlumnosSolicitantes(DNI),
)

--INSERT INTO AlumnosSolicitantes VALUES ('12334567C' ,'PACO',2.3,150)
insert into AlumnosSolicitantes values ('11111111A', 'Ana Albaricoque', 9.8, 150) 
insert into AlumnosSolicitantes values ('22222222B', 'Beatriz Blanco', 9.5, 200) 
insert into AlumnosSolicitantes values ('33333333C', 'Cristina Cortina', 7.6, 100) 
insert into AlumnosSolicitantes values ('44444444D', 'Daniel Dado', 7.6, 100) 
insert into AlumnosSolicitantes values ('55555555E', 'Enriqueta Espera', 6.9, 150) 
insert into AlumnosSolicitantes values ('66666666F', 'Federico Frio', 6.8, 50) 
insert into AlumnosSolicitantes values ('77777777G', 'Guillermo Gil', 6.1, 100)

SELECT * FROM AlumnosSolicitantes

GO

CREATE OR ALTER PROCEDURE REPARTIRBECAS
	@CUANTIATOTAL MONEY 
AS
BEGIN
DECLARE @DNI VARCHAR  (10), @NOMBRE VARCHAR  (255) ,@NOTA DECIMAL(2) ,@CUANTIA MONEY 
DECLARE CCALUMNOS CURSOR FOR SELECT * FROM AlumnosSolicitantes order by nota desc,DNI desc
OPEN CCALUMNOS
FETCH CCALUMNOS INTO @DNI,@NOMBRE,@NOTA,@CUANTIA
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT 'DNI ' + @DNI +   ' NOMBRE  ' + @NOMBRE + ' NOTA ' +  cast (@NOTA as varchar (255)) + ' CUANTIA ' + cast (@CUANTIA as varchar (255))
		if @CUANTIA<@CUANTIATOTAL
		begin
			insert into AlumnosConBeca values (@DNI,@NOMBRE,@CUANTIA)
			set @CUANTIATOTAL=@CUANTIATOTAL-@CUANTIA
			print 'Se le ha concedido la beca a ' + @NOMBRE
		end 
		else 
		begin
			print 'no queda mas dinero ha solicitado ' + cast (@CUANTIA as varchar ) + ' y tenemos ' + cast (@CUANTIATOTAL as varchar )
		end 

	FETCH CCALUMNOS INTO @DNI,@NOMBRE,@NOTA,@CUANTIA
	print''
END 
CLOSE CCALUMNOS
DEALLOCATE CCALUMNOS
print 'han sobrado ' + cast (@CUANTIATOTAL as varchar )
END




begin transaction 
exec REPARTIRBECAS 520
SELECT * FROM AlumnosConBeca
rollback 