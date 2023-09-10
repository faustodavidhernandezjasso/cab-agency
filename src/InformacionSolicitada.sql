------------------------------------------------------------------------------
----------------------informacion solicitada-------------------------------
------------------------------------------------------------------------------

---informacion de todos los choferes----
select * 
from chofer natural join telefonocelularchofer natural join correoelectronicochofer 
where eschofer = true;

---informacion de los vehiculos---
select * 
from vehiculo natural join seguro;

--informacion de vehiculos dados de baja--
select numeroeconomico,idchofer,baja,razon
from vehiculo 
where baja = true;

---informacion de los dueños---
select  * 
from chofer natural join telefonocelularchofer natural join correoelectronicochofer
where espropietario = true; 

---informacion de clientes---
select * 
from cliente natural join telefonocelularcliente natural join correoelectronicocliente ;

---informacion de viajes---
select idViaje,idChofer,idCliente,numeroEconomico, calleOrigen, numeroInteriorOrigen, numeroExteriorOrigen,
coloniaOrigen,cpOrigen,calleDestino,numeroInteriorDestino,numeroExteriorDestino,coloniaDestino,
cpDestino,tiempo,distancia,dentroDeCU,numPasajerosExtra,fecha,hora,
calcularCobro(numPasajerosExtra,calcularDescuento(idCliente),dentroDeCU,distancia,calculaNumV(idCliente)) cobro
from viaje natural join cliente;

---informacion de las infracciones--
select numeroBoleta,numeroEconomico,idChofer,subsidio,hora,calle,alcaldia,cp,nombre,apellidoPaterno,
apellidoMaterno,fecha,monto,pagado,aplicaDescuento(monto,subsidio) montofinal
from infraccion natural join chofer natural join vehiculo;

---informacion de las ganancias de un chofer--
select idViaje,idChofer,cobro,dentroDeCU,sacarGanancia(cobro,dentroDeCU) ganancia
from registroviaje;

--informacion de el bono de algun chofer--
select obtenerBono(1,current_date);





