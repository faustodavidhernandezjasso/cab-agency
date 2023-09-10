/**
* Consulta 1. 
* Lord Ciencias.
* Proyecto Final
* El nombre de todos los clientes que han tomado al menos un viaje dentro CU, 
* y llevaban al menos un acompañante.
*/
SELECT cliente.nombre, cliente.apellidoPaterno, cliente.apellidoMaterno 
FROM  cliente NATURAL JOIN viaje WHERE cliente.idCliente = viaje.idCliente 
                                 AND viaje.dentroDeCU 
                                 AND numPasajerosExtra >= 1;


/**
* Consulta 2. 
* Lord Ciencias.
* Proyecto Final
* El nombre de todos los clientes que sean estudiantes y académicos, que hayan tomado 
* un viaje fuera de CU en el 1er y 3er semestre del año 2019
* llevado acompañante
*/
SELECT cliente.nombre, cliente.apellidoPaterno, cliente.apellidoMaterno 
FROM  cliente NATURAL JOIN viaje WHERE cliente.idCliente = viaje.idCliente 
                                       AND (NOT viaje.dentroDeCU)
                                       AND numPasajerosExtra = 0
                                       AND EXTRACT('YEAR' FROM fecha) = 2019 
                                       AND (EXTRACT('QUARTER' FROM fecha) = 1 or EXTRACT('QUARTER' FROM fecha) = 3);


/**
* Consulta 3. 
* Lord Ciencias.
* Proyecto Final.
* El nombre completo de los clientes que son homónimos, junto con su ID, hayan viajado fuera de CU
* en un vehículo fabricado entre 2013 y 2018.
*/
SELECT DISTINCT a.nombre, a.apellidoPaterno, a.apellidoMaterno, a.idcliente
FROM cliente a JOIN cliente b ON a.nombre = b.nombre AND a.apellidoPaterno = b.apellidoPaterno AND a.apellidoMaterno = b.apellidoMaterno AND a.idcliente <> b.idcliente
               JOIN viaje c ON a.idCliente = c.idCliente AND NOT(c.dentroDeCU) 
               JOIN vehiculo d ON EXTRACT('YEAR' FROM d.fechaDeFabricacion) BETWEEN 2013 AND 2018;
     

/**
* Consulta 4. 
* Lord Ciencias.
* Proyecto Final
* El ID del viaje, la fecha tal que el chofer y el cliente tengan el mismo nombre, no importa sí tienen distinto 
* apellido.
*/
SELECT idViaje, fecha 
FROM cliente NATURAL JOIN viaje NATURAL JOIN chofer 
WHERE cliente.idCliente = viaje.idCliente AND
      viaje.idChofer = chofer.idChofer AND
      cliente.nombre = chofer.nombre;


/**
* Consulta 5. 
* Lord Ciencias.
* Proyecto Final.
* Nombre completo, id del cliente y el número de viajes que ha 
* realizado
* entre los años 2017 y 2019.
*/
SELECT cliente.idCliente, cliente.nombre, cliente.apellidoPaterno, cliente.apellidoMaterno, COUNT(viaje.idCliente) viajes,
FROM cliente JOIN viaje ON cliente.idCliente = viaje.idCliente AND
                           EXTRACT('YEAR' FROM viaje.fecha) BETWEEN 2017 AND 2019
GROUP BY cliente.idCliente
ORDER BY viajes;


/**
* Consulta 6. 
* Lord Ciencias.
* Proyecto Final
* Nombre completo, id del cliente del cliente que tenga el mayor número de viajes y el 
* menor número de viajes.
*/
SELECT cliente.idCliente, cliente.nombre, cliente.apellidoPaterno, cliente.apellidoMaterno, COUNT(viaje.idCliente) viajes
FROM cliente JOIN viaje ON cliente.idCliente = viaje.idCliente
GROUP BY cliente.idcliente
HAVING COUNT(viaje.idCliente) >= all (SELECT COUNT(viaje.idCliente) FROM viaje GROUP BY viaje.idCliente);


/**
* Consulta 7. 
* Lord Ciencias.
* Proyecto Final
* Nombre de los choferes que han cometido una infracción.
*/
SELECT chofer.nombre, chofer.apellidoPaterno, chofer.apellidoMaterno 
FROM chofer JOIN infraccion ON chofer.idChofer = infraccion.idChofer
ORDER BY chofer.nombre ASC;


/**
* Consulta 8. 
* Lord Ciencias.
* Proyecto Final.
* El nombre de los choferes que son dueños y el número de vehículos que han manejado.
*/
SELECT chofer.idChofer,chofer.nombre, chofer.apellidoPaterno, chofer.apellidoMaterno, COUNT(vehiculo.numeroEconomico) vehiculos
FROM chofer JOIN manejar ON chofer.idChofer = manejar.idChofer JOIN vehiculo ON manejar.numeroEconomico = vehiculo.numeroEconomico AND esPropietario
GROUP BY chofer.idChofer;

/**
* Consulta 9. 
* Lord Ciencias.
* Proyecto Final
* El nombre del chofer con mayor número de infracciones.
*/
SELECT chofer.nombre, chofer.apellidoPaterno, apellidoMaterno, COUNT(infraccion.idChofer) infracciones 
FROM chofer JOIN infraccion ON chofer.idChofer = infraccion.idChofer
GROUP BY infraccion.idChofer
HAVING COUNT(idChofer) >= all (SELECT COUNT(infraccion.idChofer) 
                               FROM infraccion
                               GROUP BY infraccion.idChofer);


/**
* Consulta 10. 
* Lord Ciencias.
* Proyecto Final.
* El nombre del chofer con menor número de infracciones*/
SELECT chofer.nombre
FROM chofer JOIN infraccion ON chofer.idChofer = infraccion.idChofer
GROUP BY chofer.nombre
HAVING COUNT(chofer.idChofer) <= all (SELECT COUNT(infraccion.idChofer) 
                               FROM infraccion
                               GROUP BY infraccion.idChofer);


/**
* Consulta 11. 
* Lord Ciencias.
* Proyecto Final
* El nombre completo, id de los clientes, con su lugar de estudio, el id de su viaje y la fecha en la que 
* viajaron. Los clientes deben de ser alumnos y los viajes deben de haber sido realizados a partir del primero 
* de enero del 2022.
*/
SELECT cliente.idcliente, cliente.nombre, cliente.apellidopaterno, cliente.lugardeestudio, viaje.idviaje, viaje.fecha
FROM cliente
INNER JOIN viaje ON cliente.idcliente = viaje.idcliente
WHERE viaje.fecha > '2021-12-31' AND cliente.esalumno = True;


/**
* Consulta 12. 
* Lord Ciencias.
* Proyecto Final.
* Los choferes que cometieron una infracción y no ha sido pagada. Están 
* ordenadas desde la más reciente hasta la más antigüa.
*/ 
SELECT chofer.idchofer, infraccion.numeroboleta, infraccion.monto, infraccion.fecha
FROM chofer
INNER JOIN infraccion ON chofer.idchofer = infraccion.idchofer
WHERE pagado = False
ORDER BY infraccion.fecha ASC;


/**
* Consulta 13. 
* Lord Ciencias.
* Proyecto Final.
* El monto total de las infracciones que no se han pagado por alcaldía, los montos están ordenados
* del más pequeño al más grande.
*/
SELECT SUM(monto), alcaldia FROM infraccion 
WHERE pagado = False AND fecha < '2022-01-01'
GROUP BY alcaldia
ORDER BY SUM(monto) DESC;


/**
* Consulta 14. 
* Lord Ciencias.
* Proyecto Final.
* El número de vehículos que tiene la asociación de taxis por marca y modelo.
*/
SELECT COUNT(numeroeconomico), marca, modelovehiculo
FROM vehiculo
GROUP BY (marca, modelovehiculo)
ORDER BY COUNT(numeroeconomico) DESC;


/**
* Consulta 15. 
* Lord Ciencias.
* Proyecto Final
* Todos los clientes que realizaron un viaje entre el 12 de diciembre del 2021 y al 10 de 
* enero del 2022.
*/
SELECT cliente.idcliente, viaje.idchofer, viaje.tiempo, viaje.distancia, viaje.cpdestino
FROM cliente
INNER JOIN viaje ON cliente.idcliente=viaje.idcliente
WHERE viaje.dentrodecu = True AND viaje.fecha BETWEEN '2021-12-12' AND '2022-01-10';