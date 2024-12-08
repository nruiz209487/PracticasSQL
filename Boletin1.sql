--DROP DATABASE SCOTT 
 CREATE DATABASE SCOTT
 USE SCOTT
 
-- Creacion de las tablas de SCOTT
 
CREATE TABLE DEPT (
        DEPTNO INT CONSTRAINT PK_DEPT PRIMARY KEY,
        DNAME VARCHAR(14),
        LOC VARCHAR(13));
 
CREATE TABLE EMP (
        EMPNO INT CONSTRAINT PK_EMP PRIMARY KEY,
        ENAME VARCHAR(10),
        JOB VARCHAR(9),
        MGR INT,
        HIREDATE DATE,
        SAL DECIMAL(7,2),
        COMM DECIMAL(7,2),
        DEPTNO INT CONSTRAINT FK_DEPTNO REFERENCES DEPT);
 
CREATE TABLE BONUS (
        ENAME VARCHAR(10),
        JOB VARCHAR(9),
        SAL INT,
        COMM INT);
         
CREATE TABLE SALGRADE (
        GRADE INT,
        LOSAL INT,
        HISAL INT);
 
-- Insercion de datos en las tablas
INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');
 
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'17-12-1980',800,NULL,20);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'20-2-1981',1600,300,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'22-2-1981',1250,500,30);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'2-4-1981',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'28-9-1981',1250,1400,30);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'1-5-1981',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'9-6-1981',2450,NULL,10);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'13-07-87',3000,NULL,20);
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'17-11-1981',5000,NULL,10);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'8-9-1981',1500,0,30);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'13-07-87',1100,NULL,20);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'3-12-1981',950,NULL,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'3-12-1981',3000,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'23-1-1982',1300,NULL,10);
 
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
 

 
 go
--Ejercicio 1
--Haz una función llamada DevolverCodDept que reciba el nombre de un departamento y devuelva su código.
CREATE or alter FUNCTION DevolverCodDept
(
	@nombreDept varchar(255)
)
RETURNS INT
AS
BEGIN
declare  @DEPTNO INT
select @DEPTNO =DEPTNO  from DEPT where @nombreDept = DNAME
return @DEPTNO
END
GO

select dbo.DevolverCodDept('ACCOUNTING') as res

--Ejercicio 2
--Realiza un procedimiento llamado HallarNumEmp que recibiendo un nombre de departamento, muestre en
--pantalla el número de empleados de dicho departamento. Puedes utilizar la función creada en el ejercicio 1.
--Si el departamento no tiene empleados deberá mostrar un mensaje informando de ello. Si el departamento no
--existe se tratará la excepción correspondiente.
go
CREATE or alter  PROCEDURE HallarNumEmp
@nombreDept varchar(255)
AS
BEGIN
declare @numEmp int =0
select @numEmp =count(EMPNO) from EMP where DEPTNO  = ( select DEPTNO  from DEPT  where  @nombreDept = DNAME)

if @numEmp !=0
BEGIN
print 'El numero de empleados en el dept '+ @nombreDept + ' Es igual a :'+  cast(@numEmp as varchar(255))
END
Else 
BEGIN
print 'No hay empleados o el dept no existe '
END
END
GO
select * from DEPT
exec HallarNumEmp 'RESEARCH'


--Ejercicio 3
--Realiza una función llamada CalcularCosteSalarial que reciba un nombre de departamento y devuelva la suma de
--los salarios y comisiones de los empleados de dicho departamento. Trata las excepciones que consideres
--necesarias.

go
CREATE or alter FUNCTION CalcularCosteSalarial
(
	@nombreDept varchar(255)
)
RETURNS FLOAT 
AS
BEGIN
	DECLARE @res FLOAT =0.0
	select @res=sal + isnull(comm,0) from emp where DEPTNO =(select DEPTNO from DEPT where @nombreDept = DNAME)
	RETURN @res

END
GO

select dbo.CalcularCosteSalarial('SALES') AS res
select * from DEPT	select * from emp

--Ejercicio 4 Cr
--Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de todos los departamentos y el coste
--salarial de cada uno de ellos. Puedes usar la función del ejercicio 3.
go
CREATE  or alter PROCEDURE MostrarCostesSalariales
AS
BEGIN
declare @nombreDept varchar(255),@res float =0.0
declare ccDept cursor for 
select dname from DEPT  
open ccDept
fetch ccDept into @nombreDept
while(@@FETCH_STATUS=0)
begin
set @res=0.0
select @res = sal + isnull(comm,0) from emp where DEPTNO =(select DEPTNO from DEPT where @nombreDept = DNAME)
print 'Los gasto en el dept ' + @nombreDept + ' son en total: ' + cast (@res as varchar(255))
fetch ccDept into @nombreDept
end
close ccDept
deallocate ccDept
END
GO

exec MostrarCostesSalariales

--Ejercicio 5
--Realiza un procedimiento MostrarAbreviaturas que muestre las tres primeras letras del nombre de cada empleado.
go
CREATE or alter  PROCEDURE MostrarAbreviaturas
AS
BEGIN
declare @abreviatura varchar(3)
declare ccemp cursor for 
select substring(ename,1,3) from emp
open ccemp
fetch ccemp into @abreviatura
while (@@FETCH_STATUS = 0 )
BEGIN
print 'Iniciales del empleado: ' + @abreviatura
fetch ccemp into @abreviatura
end 

close ccemp
deallocate ccemp
END
GO

exec MostrarAbreviaturas

--Ejercicio 6 cr
--Realiza un procedimiento MostrarMasAntiguos que muestre el nombre del empleado más antiguo de cada
--departamento junto con el nombre del departamento. Trata las excepciones que consideres necesarias.
GO 
CREATE OR ALTER  PROCEDURE MostrarMasAntiguos
AS
BEGIN
DECLARE @nombreDept varchar(255), @nombreEmpAnt  varchar(255)
DECLARE ccDept cursor for 
select dname from DEPT
open ccDept
fetch ccDept into @nombreDept
while (@@FETCH_STATUS =0)
BEGIN
SELECT top (1) @nombreEmpAnt = ENAME  FROM EMP where DEPTNO=(select DEPTNO from dept where dname= @nombreDept)  ORDER BY HIREDATE ASC   
PRINT 'El empleado mas antiguo del departamento ' + @nombreDept +  ' es ' + @nombreEmpAnt
fetch ccDept into @nombreDept
end 
close ccDept
deallocate  ccDept
END
GO

EXEC MostrarMasAntiguos



--Ejercicio 8
--Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres de los dos vendedores con más
--comisiones. Trata las excepciones que consideres necesarias.
go 
CREATE or alter  PROCEDURE MostrarMejoresVendedores 
AS
BEGIN
declare @nombre varchar(255), @cuantia float ,@contador int = 1
declare ccemp cursor for 
select top (2) ename ,isnull(COMM,0)  from emp order by COMM desc
open ccemp
fetch ccemp into  @nombre,@cuantia
while (@@FETCH_STATUS =0 )
begin
	if @contador=1
		begin 
		print 'El emmpleado que mas a vendido es ' + @nombre + ' con una cuantia total de ' +  cast (@cuantia as varchar(255))
		end
	else 
		begin 
		print 'En el segundo lugar esta ' + @nombre + ' con una cuantia total de ' +  cast (@cuantia as varchar(255))
		end

	fetch ccemp into  @nombre,@cuantia
	set @contador=@contador+1
end 
close ccemp
deallocate ccemp
END
GO

exec MostrarMejoresVendedores

--Ejercicio 10
--Realiza un procedimiento RecortarSueldos que recorte el sueldo un 20% a los empleados cuyo nombre empiece
--por la letra que recibe como parámetro.Trata las excepciones que consideres necesarias
go
CREATE or alter  PROCEDURE RecortarSueldos
@letra varchar(1)
AS
BEGIN
update EMP
set sal = sal -sal*0.20
where ename like @letra + '%'

declare @empno int, @name varchar(255) ,@sal float
declare ccemp cursor for 
select EMPNO ,ENAME, isnull(SAL,0.0) from emp where ENAME like @letra+'%' 
open ccemp
fetch ccemp into @empno,@name ,@sal
while (@@FETCH_STATUS=0)
	begin
	print 'Num: ' + cast (@empno as varchar(255) ) + ' nombre: '+ @name  + ' sal: ' +cast(@sal as varchar(255))
	fetch ccemp into @empno,@name, @sal
	end 
close ccemp
deallocate ccemp
END
GO

begin transaction 
exec RecortarSueldos 'a'
rollback

--Ejercicio 11 cr
--Realiza un procedimiento BorrarBecarios que borre a los dos empleados más nuevos de cada departamento. Trata
--las excepciones que consideres necesarias.
go
CREATE or alter PROCEDURE BorrarBecarios
@numEmpleadosEliminar int =2
AS
BEGIN
declare @deptno int  , @dname varchar (255),@contador int,@codEmp int
declare ccDept cursor for 
select DEPTNO, dname  from DEPT
open ccDept
fetch ccDept into @deptno,@dname
while (@@FETCH_STATUS=0) 
	begin 
	set @contador=0
	print 'Datos del departamentop , codigo '+ cast(@deptno as varchar(255)) + ' nombre ' + @dname
	print '-----------------------------------------------------------------------------------------'
	while(@contador<@numEmpleadosEliminar)
			begin
			select top(1) @codEmp= EMPNO from emp where @deptno=DEPTNO order by HIREDATE desc
			delete from emp where EMPNO=@codEmp
			set @contador=@contador+1
			print 'Empleado ' + cast(@codEmp as varchar(255)) + ' borrado correctamente.'
			end
	fetch ccDept into @deptno,@dname
	end 
close ccDept
deallocate ccDept
END
GO


begin transaction 
exec BorrarBecarios
rollback

