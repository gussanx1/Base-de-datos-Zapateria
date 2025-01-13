xp_create_subdir 'C:\DatosZapateria\Zapateria'
go
xp_create_subdir 'D:\InfoZapateria'
go

create database Zapateria
	on Primary
	(name = 'DatosZapateria01', filename = 'D:\InfoZapateria\DatosZapateria01.mdf', Size = 20MB,
		Maxsize = 20GB, Filegrowth = 100MB),
	(name = 'DatosZapateria02', filename = 'C:\DatosZapateria\Zapateria\DatosZapateria02.ndf', Size = 20MB,
		Maxsize = 40GB, Filegrowth = 50%),
	filegroup EMPLEADOS
	(name = 'DatosEmpleados01', filename = 'D:\InfoZapateria\DatosEmpleados01.mdf', Size = 20MB,
		Maxsize = 20GB, Filegrowth = 100MB),
	(name = 'DatosEmpleados02', filename = 'C:\DatosZapateria\Zapateria\DatosEmpleados02.ndf', Size = 20MB,
		Maxsize = 40GB, Filegrowth = 50%),
	filegroup PROCESO
	(name = 'DatosProceso01', filename = 'D:\InfoZapateria\DatosProceso01.mdf', Size = 20MB,
		Maxsize = 20GB, Filegrowth = 100MB),
	(name = 'DatosPersonal02', filename = 'C:\DatosZapateria\Zapateria\DatosProceso02.ndf', Size = 20MB,
		Maxsize = 40GB, Filegrowth = 50%)
	log on
	(name = 'TransaccionesZapateria01', filename = 'D:\InfoZapateria\TransaccionesZapateria01.ldf', Size = 100Mb),
	(name = 'TransaccionesZapateria02', filename = 'C:\DatosZapateria\Zapateria\TransaccionesZapateria02.ldf', Size = 300Mb)
go

use Zapateria
go

select * from sys.filegroups
go

select * from sys.schemas
go

select * from sys.tables
go

if not exists 
	(select name from sys.schemas where name = 'Empleado' )
		Begin
			Execute('Create schema Empleado')
		End
go

if not exists 
	(select name from sys.schemas where name = 'Proceso' )
		Begin
			Execute('Create schema Proceso')
		End
go


drop table Empleado.Vendedoras
drop table Empleado.Alistador
drop table Empleado.Armador
drop table Empleado.Perfilador
--drop table Proceso.Compra
--drop table Proceso.Materiales
--drop table Proceso.Proveedor
--drop table Proceso.Kriocas
-- ==============================================================================================
-- REGISTROS DE LOS EMPLEADOS
-- =============================================================================================

if not exists
   (Select name from sys.tables where name = 'Usuario')
   Begin
Create table dbo.Usuario
	(
	UsuarioId nchar(4),
	UsuarioNombre nvarchar(50) not null,
	UsuarioApaterno nvarchar(100) not null,
    UsuarioAmaterno nvarchar(100) not null,
    UsuarioNombreComplet As 
		Upper(UsuarioApaterno+ space(1) + UsuarioAmaterno + Space(1) +  UsuarioNombre),
	UsuarioContraseña nchar(4),
	UsuarioDNI nchar(8) constraint PerfiladorDNI default '11111111',
	UsuarioTelefono nchar(9) not null,
	constraint UsuarioPK primary key (UsuarioId)
	)
	End
go

-- Verificar tabla creada
select * from dbo.Usuario

-- Agregar USUARIO
Insert into dbo.Usuario (UsuarioId, UsuarioNombre, UsuarioApaterno, UsuarioAmaterno, UsuarioContraseña, UsuarioDNI, UsuarioTelefono)
values
	('0001', 'Juan', 'González', 'López', 'pass', '12345678', '987654321'),
    ('0002', 'María', 'López', 'García', 'sec6', '87654321', '123456789'),
    ('0003', 'Pedro', 'Ramírez', 'Sánchez', 'abc1', '54321678', '987654321'),
    ('0004', 'Ana', 'Martínez', 'Rodríguez', 'p123', '98765432', '123456789'),
    ('0005', 'Luis', 'Hernández', 'Pérez', 'pass', '23456789', '987654321'),
    ('0006', 'Laura', 'Gómez', 'Flores', 'sec8', '65432187', '543210987'),
    ('0007', 'Carlos', 'Vargas', 'Soto', 'qw5y', '87654321', '123456789'),
    ('0008', 'Marta', 'Sánchez', 'López', '62rd', '76543218', '987654321'),
    ('0009', 'José', 'Luna', 'García', 's123', '98765431', '876543210'),
    ('0010', 'Sofía', 'Torres', 'Martínez', 'c123', '87654321', '987654321')
go

-- para obtener el total de usuarios en la tabla "dbo.Usuario" 
-- y mostrarlo como una columna adicional llamada "TotalUsuarios"
select UsuarioNombre, 
	(select count(*) from dbo.Usuario) 
		as TotalUsuarios
			from dbo.Usuario

if not exists
   (Select name from sys.tables where name = 'Perfilador')
   Begin
Create table Empleado.Perfilador
	(
	PerfiladorId nchar(4),
	PerfiladorNombre nvarchar(50) not null,
	PerfiladorApaterno nvarchar(100) not null,
    PerfiladorAmaterno nvarchar(100) not null,
	PerfiladorDNI nchar(8) constraint PerfiladorDNI default '11111111',
	PerfiladorTelefono nchar(9) not null,
	PerfiladorDireccion nvarchar(100) not null,
	PerfiladorEstado nchar(1) constraint PerfiladorEstado default 'A',
	PerfiladorNpares Numeric(19,2) constraint PerfiladorNparesDF Default 0,
	PerfiladorPagoXpar Numeric(19,2) constraint PerfiladorPagoXparDF Default 0,
	PerfiladorPago As PerfiladorNpares * PerfiladorPagoXpar,
	PerfiladorRegistro date,
	constraint PerfiladorPK primary key (PerfiladorId),
	constraint PerfiladorEstadoCK check (PerfiladorEstado = 'A' or PerfiladorEstado = 'E')
	)
	End
go

-- Verificar tabla creada
select * from Empleado.Perfilador

-- Agregar Empleado.Perfilador
insert into Empleado.Perfilador(
	PerfiladorId,
    PerfiladorNombre,
    PerfiladorApaterno,
    PerfiladorAmaterno,
    PerfiladorDNI,
    PerfiladorTelefono,
    PerfiladorDireccion,
    PerfiladorEstado,
    PerfiladorNpares,
    PerfiladorPagoXpar,
    PerfiladorRegistro
)
Values
    ('1111', 'Juan', 'González', 'López', '12345678', '987654321', 'Calle Principal 123', 'A', 10, 5.0, GETDATE()),
    ('2222', 'María', 'López', 'García', '87654321', '123456789', 'Avenida Central 456', 'A', 8, 4.5, GETDATE()),
    ('3333', 'Pedro', 'Ramírez', 'Sánchez', '54321678', '987654321', 'Calle Secundaria 789', 'A', 12, 6.0, GETDATE()),
    ('4444', 'Ana', 'Martínez', 'Rodríguez', '98765432', '123456789', 'Avenida Principal 987', 'A', 15, 4.0, GETDATE()),
    ('5555', 'Luis', 'Hernández', 'Pérez', '23456789', '987654321', 'Calle Principal 555', 'A', 20, 3.5, GETDATE())
go

-- entre la tabla "Empleado.Perfilador" y
--la tabla "Cliente.Cuenta" utilizando la columna "PerfiladorId" como condición de unión.
select P.PerfiladorId, P.PerfiladorNombre, P.PerfiladorTelefono, C.ClienteNombre
	from Empleado.Perfilador P
	JOIN Cliente.Cuenta C ON P.PerfiladorId = C.PerfiladorId


if not exists
   (Select name from sys.tables where name = 'Armador')
   Begin
Create table Empleado.Armador
	(
	ArmadorId nchar(4),
	ArmadorNombre nvarchar(50) not null,
	ArmadorApaterno nvarchar(100) not null,
    ArmadorAmaterno nvarchar(100) not null,
	ArmadorEstado nchar(1) constraint ArmadorEstadoDF Default 'A', 
	ArmadorDNI nchar(8) constraint ArmadorDNI default '11111111',
	ArmadorTelefono nchar(9) not null,
	ArmadorDireccion nvarchar(100) not null,
	ArmadorNpares Numeric(19,2) constraint ArmadorNparesDF Default 0,
	ArmadorPagoXpar Numeric(19,2) constraint ArmadorPagoXparDF Default 0,
	ArmadorPago As ArmadorNpares * ArmadorPagoXpar,
	ArmadorRegistro date,
	ArmadorPerfiladorId nchar(4),
	constraint ArmadorPK primary key (ArmadorId),
	constraint ArmadorEstadoCK check (ArmadorEstado = 'A' or ArmadorEstado = 'E'),
	constraint ArmadorPerfiladorFK Foreign key(ArmadorPerfiladorId)
	references Empleado.Perfilador(PerfiladorId)
	)
	End
go

-- Verificar tabla creada
select * from Empleado.Armador

-- Agregar Empleado.Armador
Insert into Empleado.Armador (
    ArmadorId,
    ArmadorNombre,
    ArmadorApaterno,
    ArmadorAmaterno,
    ArmadorEstado,
    ArmadorDNI,
    ArmadorTelefono,
    ArmadorDireccion,
    ArmadorNpares,
    ArmadorPagoXpar,
    ArmadorRegistro,
    ArmadorPerfiladorId
)
values
    ('0011', 'Juan', 'González', 'López', 'A', '12345678', '987654321', 'Calle Principal 123', 10, 5.0, GETDATE(), '1111'),
    ('0022', 'María', 'López', 'García', 'A', '87654321', '123456789', 'Avenida Central 456', 8, 4.5, GETDATE(), '2222'),
    ('0033', 'Pedro', 'Ramírez', 'Sánchez', 'E', '54321678', '987654321', 'Calle Secundaria 789', 12, 6.0, GETDATE(), '3333'),
    ('0044', 'Ana', 'Martínez', 'Rodríguez', 'E', '98765432', '123456789', 'Avenida Principal 987', 15, 4.0, GETDATE(), '4444'),
    ('0055', 'Luis', 'Hernández', 'Pérez', 'A', '23456789', '987654321', 'Calle Principal 555', 20, 3.5, GETDATE(), '5555')
go



if not exists
   (Select name from sys.tables where name = 'Alistador')
   Begin
Create table Empleado.Alistador
	(
	AlistadorId nchar(4),
	AlistadorNombre nvarchar(50) not null,
	AlistadorApaterno nvarchar(100) not null,
    AlistadorAmaterno nvarchar(100) not null,
	AlistadorEstado nchar(1) constraint AlistadorEstadoDF Default 'A', 
	AlistadorDNI nchar(8) constraint AlistadorDNI default '11111111',
	AlistadorTelefono nchar(9) not null,
	AlistadorDireccion nvarchar(100) not null,
	AlistadorNpares Numeric(19,2) constraint AlistadorNparesDF Default 0,
	AlistadorPagoXpar Numeric(19,2) constraint AlistadorPagoXparDF Default 0,
	AlistadorPago As AlistadorNpares * AlistadorPagoXpar,
	AlistadorRegistro date,
	AlistadorArmadorId nchar(4),
	constraint AlistadorPK primary key (AlistadorId),
	constraint AlistadorEstadoCK check (AlistadorEstado = 'A' or AlistadorEstado = 'E'),
	constraint AlistadorArmadorFK Foreign key(AlistadorArmadorId)
	references Empleado.Armador(ArmadorId)
	)
	End
go

-- Verificar tabla creada
select * from Empleado.Alistador

-- Agregar Empleado.Alistador
Insert into Empleado.Alistador (
        AlistadorId,
        AlistadorNombre,
        AlistadorApaterno,
        AlistadorAmaterno,
        AlistadorEstado,
        AlistadorDNI,
        AlistadorTelefono,
        AlistadorDireccion,
        AlistadorNpares,
        AlistadorPagoXpar,
        AlistadorRegistro,
        AlistadorArmadorId
    )
values
        ('1001', 'Juan', 'González', 'López', 'A', '12345678', '987654321', 'Calle Principal 123', 10, 5.0, GETDATE(), '0011'),
        ('2002', 'María', 'López', 'García', 'E', '87654321', '123456789', 'Avenida Central 456', 8, 4.5, GETDATE(), '0022'),
        ('3003', 'Pedro', 'Ramírez', 'Sánchez', 'A', '54321678', '987654321', 'Calle Secundaria 789', 12, 6.0, GETDATE(), '0033'),
        ('4004', 'Ana', 'Martínez', 'Rodríguez', 'E', '98765432', '123456789', 'Avenida Principal 987', 15, 4.0, GETDATE(), '0044'),
        ('5005', 'Luis', 'Hernández', 'Pérez', 'A', '23456789', '987654321', 'Calle Principal 555', 20, 3.5, GETDATE(), '0055')
go



if not exists
   (Select name from sys.tables where name = 'Vendedoras')
   Begin
Create table Empleado.Vendedoras
	(
	VendedorasId nchar(4),
	VendedorasNombre nvarchar(50) not null,
	VendedorasApaterno nvarchar(100) not null,
    VendedorasAmaterno nvarchar(100) not null,
	VendedorasNombreComplet As 
		concat_ws(space(1), VendedorasApaterno, VendedorasAmaterno, VendedorasNombre),
	VendedorasEstado nchar(1) constraint VendedorasEstadoDF Default 'A', 
	VendedorasDNI nchar(8) constraint VendedorasDNI default '11111111',
	VendedorasTelefono nchar(9) not null,
	VendedorasDireccionPuesto nvarchar(100) not null,
	VendedorasNparesVendidos Numeric(19,2) constraint VendedorasNparesDF Default 0,
	VendedorasPagoXpar Numeric(19,2) constraint VendedorasPagoXparDF Default 0,
	VendedorasPago As VendedorasNparesVendidos * VendedorasPagoXpar,
	VendedorasRegistro date,
	constraint VendedorasPK primary key (VendedorasId),
	constraint VendedorasEstadoCK check (VendedorasEstado = 'A' or VendedorasEstado = 'E')
	)
	End
go

-- Verificar tabla creada
select * from Empleado.Vendedoras

-- Agregar Empleado.Vendedoras
insert into Empleado.Vendedoras(
	VendedorasId, 
	VendedorasNombre, 
	VendedorasApaterno,
	VendedorasAmaterno, 
	VendedorasEstado,
	VendedorasDNI,
	VendedorasTelefono,
	VendedorasDireccionPuesto,
	VendedorasNparesVendidos, 
	VendedorasPagoXpar,
	VendedorasRegistro
	)
values
	(1211, 'Stefany', 'Vera', 'Velasquez', 'A', 75869446, 941082314, 'Jr. Los Quenuales', 50, 65,  GETDATE()),
	(1212, 'Luisa', 'Catillo', 'De Paz', 'A', 75869446, 941068314, 'Jr. Los Capulies', 68, 50,  GETDATE()),
	(1213, 'Isabel', 'Gomez', 'Lazarte', 'E', 75869446, 941062314, 'Tabariz', 43, 55,  GETDATE()),
	(1214, 'Juan', 'Vega', 'Cruz', 'A', 75869446, 941062314, 'Av. Luzuriaga', 55, 67,  GETDATE()),
	(1215, 'Steban', 'Suarez', 'Pocoy', 'A', 75869446, 941062314, 'Jr. Los Jardines', 62, 52,  GETDATE()),
	(1216, 'Diego', 'Villalva', 'Deza', 'E', 75869446, 941061314, 'Trece de Diciembre', 52, 45,  GETDATE()),
	(1217, 'Mateo', 'Sandoval', 'Chavez', 'A', 75869446, 941032314, 'Jr. Ayacucho', 46, 65,  GETDATE()),
	(1218, 'Nicolas', 'Fernandez', 'Juares', 'E', 75869446, 941062314, 'Av. Fatima', 44, 66,  GETDATE()),
	(1219, 'Sofia', 'Rocha', 'Alva', 'A', 75869446, 941162314, 'Jr. Comercio', 53, 65,  GETDATE()),
	(1220, 'Helena', 'Pesantes', 'Perez', 'E', 75869446, 941362314, 'Jr. Las Rosas', 61, 52,  GETDATE())
go

-- ==================================================================================================
-- ==================================================================================================
-- COMPRA DE MATERIALES PARA LA ELABORACION DE PRODUCTOS
-- ==================================================================================================
-- ==================================================================================================

if not exists
   (Select name from sys.tables where name = 'Kriocas')
   Begin
Create table Proceso.Kriocas
	(
	KriocasId nchar(4),
	KriocasNombre nvarchar(50) not null,
	KriocasEstado nchar(1) constraint KriocasEstado default 'A',
	KriocasRUC nchar(11) constraint KriocasDNI default '11111111111',
	KriocasTelefono nchar(9) not null,
	KriocasCorreoElectronico nvarchar(100) not null,
	constraint KriocasPK primary key (KriocasId),
	constraint KriocasEstadoCK check (KriocasEstado = 'A' or KriocasEstado = 'E')
	)
	End
go

-- Verificar tabla creada
select * from Proceso.Kriocas

-- Agregar Empleado.Vendedoras
insert into Proceso.Kriocas(
	KriocasId, 
	KriocasNombre, 
	KriocasEstado,
	KriocasRUC,
	KriocasTelefono, 
	KriocasCorreoElectronico
)
values
	('0001', 'KriocasTrujillo','A','20552103816', '982994952', 'KrioTrujillo@.com'),
	('0002', 'KriocasChimbote','A','20538856674', '982688266', 'KrioChi@.com'),
	('0003', 'KriocasLambayeque','E','20553856451','936582548', 'KrioLamba258@.com'),
	('0004', 'KriocasCajarmarca','E','20547825781', '987123654', 'KrioCajar209@.com'),
	('0005', 'KriocasLima','A','20494099153', '918234879', 'KrioLim597@.com')
go



if not exists
   (Select name from sys.tables where name = 'Proveedor')
   Begin
Create table Proceso.Proveedor
	(
	ProveedorId nchar(4),
	ProveedorNombre nvarchar(50) not null,
	ProveedorEstado nchar(1) constraint ProveedorEstado default 'A',
	ProveedorRUC nchar(11) constraint ProveedorDNI default '11111111111',
	ProveedorTelefono nchar(9) not null,
	ProveedorCorreoElectronico nvarchar(100) not null,
	constraint ProveedorPK primary key (ProveedorId),
	constraint ProveedorEstadoCK check (ProveedorEstado = 'A' or ProveedorEstado = 'E')
	)
	End
go

-- Verificar tabla creada
select * from Proceso.Proveedor

-- Agregar Empleado.Vendedoras
insert into Proceso.Proveedor (ProveedorId, ProveedorNombre,ProveedorEstado,
			ProveedorRUC, ProveedorTelefono, ProveedorCorreoElectronico)
values 
	('1110', 'Pablo','E','20552103816', '952065523', 'panblo32@gmail.com'),
	('1111', 'Juan','E', '25862253814', '987365402', 'juan657@gmail.com'),
	('1112', 'Jesus','E','20552102893', '938888201', 'jesus89@gmail.com'),
	('1113', 'Oscar','A','20557904922', '999568123', 'oscarv56@gmail.comcom'),
	('1114', 'Francisco','A','38147904922', '980025014', 'franx79@gmail.comcom'),
	('1115', 'Jose','A','20552103816', '900457779', 'jose7_3@gmail.com')
go



if not exists
   (Select name from sys.tables where name = 'Materiales')
   Begin
Create table Proceso.Materiales
	(
	MaterialesId nchar(4),
	MaterialesNombre nvarchar(50) not null,
	MaterialesDescripcion nvarchar(50) not null,
	MaterialesEstado nchar(1) constraint MaterialesEstado default 'A',
	MaterialesCosto Numeric(19,2) constraint MaterialesCostoDF Default 0,
	MaterialesProveedorId nchar(4),
	constraint MaterialesPK primary key (MaterialesId),
	constraint MaterialesEstadoCK check (MaterialesEstado = 'A' or MaterialesEstado = 'E'),
	constraint MaterialesProveedorFK Foreign key(MaterialesProveedorId)
	references Proceso.Proveedor(ProveedorId)
	)
	End
go

-- Verificar tabla creada
select * from  Proceso.Materiales

-- Agregar Proceso.Materiales
insert into Proceso.Materiales (MaterialesId, MaterialesNombre,MaterialesDescripcion,
	MaterialesEstado, MaterialesCosto, MaterialesProveedorId
	)
values
	('3001', 'cuero', 'cabras y cabritos', 'A', 10.99, '1110'),
	('3002', 'plástico', 'Hoja de plástico', 'A', 10.99, '1110'),
	('3003', 'textiles', 'Fibra de polímero', 'A', 10.99, '1110'),
	('3004', 'madera', 'gruesa,caoba y resistente', 'A', 10.99, '1110'),
	('3005', 'corcho', 'Naturales', 'A', 10.99, '1110'),
	('3006', 'trenzados', 'pasadores​​ o guatos', 'A', 10.99, '1110')
go



if not exists
   (Select name from sys.tables where name = 'Compra')
   Begin
Create table Proceso.Compra
	(
	CompraId nchar(4),
	CompraDescripcion nvarchar(100) not null,
	CompraFechaCompra date,
	CompraFechaEntrega date,
	CompraEstado nchar(1) constraint CompraEstado default 'A',
	CompraMaterialesId nchar(4),
	CompraKriocasId nchar(4),
	CompraProveedorId nchar(4),
	constraint CompraPK primary key (CompraId),
	constraint CompraEstadoCK check (CompraEstado = 'A' or CompraEstado = 'E'),
	constraint CompraMaterialesFK Foreign key(CompraMaterialesId)
	references Proceso.Materiales(MaterialesId),
	constraint CompraKriocasFK Foreign key(CompraKriocasId)
	references Proceso.Kriocas(KriocasId),
	constraint CompraProveedorFK Foreign key(CompraProveedorId)
	references Proceso.Proveedor(ProveedorId)
	)
	End
go


-- Verificar tabla creada
select * from  Proceso.Compra


-- Agregar Proceso.Compra
insert into Proceso.Compra(CompraId, CompraDescripcion, CompraFechaCompra, 
	CompraFechaEntrega, CompraEstado, CompraMaterialesId, CompraKriocasId, 
	CompraProveedorId)
values 
	('2310', 'cabras y cabritos', '2023-07-06', '2023-07-06', 'A', '3001', '0001', '1110'),
	('2311', 'Hoja de plástico', '2023-07-06', '2023-07-06', 'A', '3002', '0002', '1111'),
	('2312', 'Fibra de polímero', '2023-07-06', '2023-07-07', 'A', '3003', '0003', '1112'),
	('2313', 'gruesa,caoba y resistente', '2023-07-10', '2023-07-10', 'A', '3004', '0004', '1113'),
	('2314', 'Naturales', '2023-07-07', '2023-07-12', 'A', '3005', '0005', '1114'),
	('2315', 'pasadores​​ o guatos', '2023-07-07', '2023-07-11', 'A', '3006', '0006', '1115')
go

