Use Zapateria
go

-- Join
select A.ArmadorId As 'ID Armador',
	   P.PerfiladorId As 'ID Perfilador',
	   Armador = A.ArmadorNombre + SPACE(1) + A.ArmadorApaterno + SPACE(1) + A.ArmadorAmaterno,
	   A.ArmadorEstado As 'Estado',
	   A.ArmadorDNI As 'DNI',
	   A.ArmadorTelefono As 'Teléfono',
	   A.ArmadorDireccion As 'Dirección',
	   A.ArmadorNpares As 'Número Pares',
	   A.ArmadorPagoXpar As 'Pago por Par',
	   A.ArmadorRegistro As 'Registro'
	   from Empleado.Armador As A
	   join Empleado.Perfilador As P on A.ArmadorPerfiladorId = P.PerfiladorId
go

-- SubConsulta
select A.ArmadorId As 'ID Armador',
	   (Select count(P.PerfiladorId) from Empleado.Perfilador As P where A.ArmadorPerfiladorId = P.PerfiladorId) As 'ID Perfilador',
	   (Select count(A.ArmadorNombre + SPACE(1) + A.ArmadorApaterno + SPACE(1) + A.ArmadorAmaterno) from Empleado.Armador As A) As 'Nombre',
	   (Select count(A.ArmadorNpares) from Empleado.Armador As A)'Número Pares',
	   (Select count(A.ArmadorPagoXpar) from Empleado.Armador As A) As 'Pago por par',
	   (Select count(A.ArmadorPago) from Empleado.Armador As A) As 'Pago Total',
	   (Select count(A.ArmadorRegistro) from Empleado.Armador As A) As 'Registro'
	   from Empleado.Armador As A
go

-- Join
select A.AlistadorId As 'ID Alistador',
	   AR.ArmadorId As 'ID Armador',
	   Alistador = A.AlistadorNombre + SPACE(1) + A.AlistadorApaterno + SPACE(1) + A.AlistadorAmaterno,
	   A.AlistadorEstado As 'Estado',
	   A.AlistadorDNI As 'DNI',
	   A.AlistadorTelefono As 'Teléfono',
	   A.AlistadorDireccion As 'Dirección',
	   A.AlistadorNpares As 'Número Pares',
	   A.AlistadorPago As 'Pago',
	   A.AlistadorRegistro As 'Registro'
	   from Empleado.Alistador As A
	   join Empleado.Armador As AR on A.AlistadorArmadorId = AR.ArmadorId
go

-- SubConsulta
select A.AlistadorId As 'ID Alistador',
	   (Select count(AR.ArmadorId) from Empleado.Armador As AR where A.AlistadorArmadorId = AR.ArmadorId) As 'ID Armador',
	   (Select count(A.AlistadorNombre + SPACE(1) + A.AlistadorApaterno + SPACE(1) + A.AlistadorAmaterno) from Empleado.Alistador As A) As 'Nombre',
	   (Select count(A.AlistadorNpares) from Empleado.Alistador As A) As 'Número Pares',
	   (Select count(A.AlistadorPagoXpar) from Empleado.Alistador As A) As 'Pago por par',
	   (Select count(A.AlistadorPago) from Empleado.Alistador As A) As 'Pago Total',
	   (Select count(A.AlistadorRegistro) from Empleado.Alistador As A) As 'Registro'
	   from Empleado.Alistador As A
go

-- Join
select M.MaterialesId As 'ID Material',
	   P.ProveedorId As 'ID Proveedor',
	   M.MaterialesNombre As 'Nombre',
	   M.MaterialesDescripcion As 'Descripción',
	   M.MaterialesEstado As 'Estado',
	   M.MaterialesCosto As 'Costo'
	   from Proceso.Materiales As M
	   join Proceso.Proveedor As P on M.MaterialesProveedorId = P.ProveedorId
go

-- SubConsulta
select M.MaterialesId As 'ID Material',
	   (Select count(P.ProveedorId) from Proceso.Proveedor As P where M.MaterialesProveedorId = P.ProveedorId) As 'ID Provedor',
	   (Select count(M.MaterialesNombre) from Proceso.Materiales As M) As 'Nombre',
	   (Select count(M.MaterialesCosto) from Proceso.Materiales As M) As 'Costo'
	   from Proceso.Materiales As M
go

-- Join
select C.CompraId As 'ID Compra',
	   M.MaterialesId As 'ID Material',
	   K.KriocasId As 'ID Kriocas',
	   P.ProveedorId As 'ID Proveedor',
	   C.CompraDescripcion As 'Descripción de la Compra',
	   C.CompraFechaCompra As 'Fecha de Compra',
	   C.CompraFechaEntrega As 'Fecha de Entrega',
	   C.CompraEstado As 'Estado'
	   from Proceso.Compra As C
	   join Proceso.Materiales As M on C.CompraMaterialesId = M.MaterialesId
	   join Proceso.Kriocas As K on C.CompraKriocasId = K.KriocasId
	   join Proceso.Proveedor As P on C.CompraProveedorId = P.ProveedorId
go

-- SubConsulta
select C.CompraId As 'ID Compra',
	   (Select count(M.MaterialesId) from Proceso.Materiales As M where C.CompraMaterialesId = M.MaterialesId) As 'ID Material',
	   (Select count(K.KriocasId) from Proceso.Kriocas As K where C.CompraKriocasId = K.KriocasId) As 'ID Kriocas',
	   (Select count(P.ProveedorId) from Proceso.Proveedor As P where C.CompraProveedorId = P.ProveedorId) As 'ID Proveedor',
	   (Select count(C.CompraDescripcion) from Proceso.Compra As C) As 'Descripción',
	   (Select count(C.CompraFechaCompra) from Proceso.Compra As C) As 'Fecha de Compra',
	   (Select count(C.CompraFechaEntrega) from Proceso.Compra As C) As 'Fecha de Entrega'
	   from Proceso.Compra As C
go