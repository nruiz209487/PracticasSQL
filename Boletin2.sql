create database PracticasExamenCursores
use PracticasExamenCursores
go
begin transaction  
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
commit 




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

