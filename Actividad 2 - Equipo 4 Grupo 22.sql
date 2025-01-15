--1. Proporcionar un listado de productos compuesto por nombre, 
--numero de producto y color para aquellos con un precio superior a 20 euros y con tallas de XS-XL.
SELECT Nombre, NumeroProducto, Color
FROM EC_Productos
WHERE Precio > 20
AND Talla_disponibles = 'XS-XL'

--2. Proporcionar un listado de clientes individuos compuesto por IDCliente, 
--nombre, apellidos y género que hayan nacido entre 1970 y 1980, cuya ocupación no sea investigador, 
--ordenados por fecha de primera compra de forma descendente.
SELECT IDCliente, Nombre, Apellidos, Genero
FROM EC_Clientes_IN
WHERE Fecha_Nacimiento BETWEEN '1970-01-01' AND '1980-12-31'
AND Ocupacion <> 'Investigador'
ORDER BY Fecha_Primera_Compra DESC

--3. Obtener un listado compuesto por factura, fecha de pedido, fecha de envío y 
--estado de pedido que contengan los códigos 9658 y 4568 en las observaciones. Pista: Utilizar OR
SELECT IDFactura, FechaPedido, FechaEnvio, EstadoPedido
FROM EC_Facturas
WHERE Observaciones LIKE '%9658%' 
OR Observaciones LIKE '%4568%'

--4. Proporcionar un listado de IDFactura, IDCliente, 
--fecha de pedido y total con impuestos cuyo estado sea cancelado y el total con impuestos sea mayor que 1000.
SELECT IDFactura, IDCliente, FechaPedido, Total_con_Impuestos
FROM EC_Facturas
WHERE EstadoPedido = 'Cancelado'
AND Total_con_Impuestos > 1000

--5. Utilizando como base la consulta anterior, y utilizándola como una subconsulta,
--obtener el denominación social y teléfono de esos clientes. 

SELECT EC.IDCliente
	   ,ECIN.Telefono AS Telefono_Individuo
	   ,ECEM.Telefono AS Telefono_Empresa
	   ,ECEM.DenominacionSocial
FROM EC_Clientes AS EC
LEFT JOIN EC_Clientes_IN AS ECIN
	ON EC.IDCliente = ECIN.IDCliente
LEFT JOIN EC_Clientes_EM AS ECEM
	ON EC.IDCliente = ECEM.IDCliente
WHERE EC.IDCliente IN (SELECT DISTINCT IDCliente
					 FROM EC_Facturas 
					 WHERE EstadoPedido = 'Cancelado'
					 AND Total_con_impuestos >1000)

--6. Obtener un listado compuesto por factura, nombre de producto, color, precio unitario, 
--cantidad y el % de descuento de las transacciones realizadas entre el abril y septiembre de 2019.
SELECT Transacciones.IDFactura, 
	   Productos.Nombre,
	   Productos.Color,
	   Productos.Precio AS PrecioUnitario,
	   Transacciones.Cantidad,
	   Transacciones.Descuento
FROM EC_Transacciones AS Transacciones
INNER JOIN EC_Productos AS Productos
	ON Transacciones.IDProducto = Productos.IDProducto
INNER JOIN EC_Facturas
	ON Transacciones.IDFactura = EC_Facturas.IDFactura
WHERE EC_Facturas.FechaPedido BETWEEN '20190401' AND '20190930'

--7. Se desea saber cuántos productos hay por cada categoría de productos, así como el precio máximo, 
--precio mínimo y precio medio por cada categoría, ordenados de mayor a menor en función del recuento por categoría.
SELECT GrupoProductoID,
		COUNT(IDProducto) AS Recuento_Productos,
		MAX(Precio) AS Precio_Maximo,
		MIN(Precio) AS Precio_Minimo,
		AVG(Precio) AS Precio_Medio
FROM EC_Productos AS Productos
GROUP BY Productos.GrupoProductoID
ORDER BY Recuento_Productos DESC

--8. Obtener las ventas totales con impuestos por país y región. Excluyendo los pedidos cancelados. 
--Ordenados de menor a mayor por el total de las ventas. 

SELECT TE.Region
		,TE.Pais
		,SUM(FA.Total_con_Impuestos) AS Total_con_Impuestos
FROM EC_Facturas AS FA
INNER JOIN EC_Clientes AS CL
	ON FA.IDCliente = CL.IDCliente
INNER JOIN EC_Territorio AS TE
	ON TE.TerritorioID = CL.TerritorioID 
WHERE FA.EstadoPedido <> 'Cancelado'
GROUP BY TE.Pais
		 ,TE.Region
ORDER BY Total_con_Impuestos ASC


--9. Se desea saber el número de pedidos, el montante total sin impuestos para clientes individuos, 
--así como el nombre y el número de cuenta de los mismos.  Solo queremos aquellos cuyo montante total 
--supera los 1500 euros. Ordenar el resultado de mayor a menor en función del montante total calculado.

SELECT CONCAT(CL.Nombre,' ', CL.Apellidos) AS Nombre_completo
		,EC.NumeroCuenta
		,COUNT(FA.IDFactura) AS Numero_pedidos
		,SUM(FA.Total) AS Total_sin_impuesto
FROM EC_Clientes_IN AS CL
INNER JOIN EC_Facturas AS FA
	ON CL.IDCliente = FA.IDCliente
INNER JOIN EC_Clientes AS EC
	ON CL.IDCliente = EC.IDCliente
WHERE FA.EstadoPedido <> 'Cancelado'
GROUP BY CONCAT(CL.Nombre,' ', CL.Apellidos)
		,EC.NumeroCuenta
HAVING SUM(FA.Total) > 1500
ORDER BY Total_sin_impuesto DESC
 
 -- Ejercicios adicionales

 -- BAJO
 -- Se desea saber el nombre completo, pasaporte y teléfono de las clientes mujeres que hayan nacido después de 1970.
SELECT CONCAT (Nombre,' ',Apellidos) AS Nombre_Completo
		,Pasaporte
		,Telefono 
FROM EC_Clientes_IN
WHERE Genero = 'M' AND Fecha_Nacimiento > '1970'
ORDER BY Fecha_Nacimiento ASC

-- MEDIO-BAJO
-- Se desea saber el nombre y precio de los productos cuyo peso no este entre 300 y 400 gr; y cuyo color no sea nulo.
SELECT Nombre, Precio
FROM EC_Productos
WHERE Peso_gramos NOT BETWEEN 300 and 400 
AND Color IS NOT NULL

-- MEDIO-ALTO
-- Se desea saber cuales son los clientes que realizaron su primera compra luego del 2015, y que sean de la región Europa
SELECT CLEM.DenominacionSocial, CONCAT(CLIN.Nombre, ' ', CLIN.Apellidos) AS Nombre_Completo, TE.Pais
FROM EC_Clientes AS CL
LEFT JOIN EC_Clientes_EM AS CLEM
	ON CLEM.IDCliente = CL.IDCliente
LEFT JOIN EC_Clientes_IN AS CLIN
	ON CLIN.IDCliente = CL.IDCliente
LEFT JOIN EC_Territorio AS TE
	ON TE.TerritorioID = CL.TerritorioID
WHERE (CLEM.Fecha_Primera_Compra > '2015'
	OR CLIN.Fecha_Primera_Compra > '2015')
	AND TE.Region = 'Europa'

-- ALTO
-- Se desea conocer los pedidos, el peso total del envio y el valor total de la factura,
-- para los pedidos cuyo peso de los productos por factura sea superior a 5.000 gramos y el estado del envio sea "Enviado"

SELECT TR.IDFactura, FC.FechaEnvio, SUM(TR.Cantidad*PR.Peso_gramos) AS Peso_Total, SUM(FC.Total_con_Impuestos) AS Valor_Total_Factura
FROM EC_Transacciones AS TR
INNER JOIN EC_Productos AS PR
	ON TR.IDProducto = PR.IDProducto
INNER JOIN EC_Facturas AS FC
	ON TR.IDFactura = FC.IDFactura
WHERE FC.EstadoPedido = 'Enviado'
GROUP BY TR.IDFactura, FC.FechaEnvio
HAVING SUM(TR.Cantidad*PR.Peso_gramos) > 5000
ORDER BY Peso_Total DESC