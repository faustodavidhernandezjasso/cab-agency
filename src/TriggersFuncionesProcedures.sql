--------------------------------------------------------------------------------
--------------------Triggers,Funciones,Procedures-------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION check_es_cliente() 
RETURNS TRIGGER AS 
$$
BEGIN 
	IF (NEW.esAlumno = False AND NEW.esAcademico = False AND NEW.esTrabajador = False) THEN
		RAISE EXCEPTION 'Los clientes deben ser alumnos,academicos o trabajadores';
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER esCliente
AFTER INSERT OR UPDATE
ON cliente
FOR EACH ROW
EXECUTE PROCEDURE check_es_cliente();

CREATE OR REPLACE FUNCTION check_cambios_clientes() 
RETURNS TRIGGER AS
$$
DECLARE
	C INT;
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroCliente(nombreUsuario, idCliente, fecha, tipo) VALUES (current_user, NEW.idCliente, current_date, 'Insert');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroCliente(nombreUsuario, idCliente, fecha, tipo) VALUES (current_user, NEW.idCliente, current_date, 'Update');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroCliente(nombreUsuario, idCliente, fecha, tipo) VALUES (current_user, NEW.idCliente, current_date, 'Delete');
		WHILE(EXISTS(SELECT * FROM telefonoCelularCliente WHERE idCliente = Old.idCliente))
			LOOP 
				DELETE FROM telefonoCeluluarCliente WHERE idCliente = Old.idCliente;
			END LOOP;
		WHILE(EXISTS(SELECT * FROM correoElectronicoCliente WHERE idCliente = Old.idCliente))
			LOOP 
				DELETE FROM correoElectronicoCliente WHERE idCliente = Old.idCliente;
			END LOOP;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_cliente 
AFTER INSERT OR UPDATE OR DELETE
ON cliente
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_clientes();

CREATE OR REPLACE FUNCTION check_chofer_propietario()
RETURNS TRIGGER AS
$$
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		IF (NEW.esChofer = False and NEW.esPropietario = False) THEN
			RAISE EXCEPTION 'El elemento a gregar o actualizar debe de ser un chofer o propietario';
		END IF;
		IF (NEW.esChofer AND NEW.numeroLicencia IS NULL) THEN
			RAISE EXCEPTION 'Si el elemento es chofer debe de tener un numero de licencia';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER chofer_propietario
AFTER INSERT OR UPDATE ON chofer
FOR EACH ROW
EXECUTE PROCEDURE check_chofer_propietario();

CREATE OR REPLACE FUNCTION check_cambios_choferes() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroChofer(nombreUsuario, idChofer, fecha, tipo) VALUES (current_user, NEW.idChofer, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroChofer(nombreUsuario, idChofer, fecha, tipo) VALUES (current_user, NEW.idChofer, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroChofer(nombreUsuario, idChofer, fecha, tipo) VALUES (current_user, NEW.idChofer, current_date, 'borrado');
		WHILE(EXISTS(SELECT * FROM telefonoCelularChofer WHERE idChofer = Old.idChofer))
			LOOP 
				DELETE FROM telefonoCeluluarChofer WHERE idcliente = Old.idChofer;
			END LOOP;
		WHILE(EXISTS(SELECT * FROM correoElectronicoChofer WHERE idChofer = Old.idChofer))
			LOOP 
				DELETE FROM correoElectronicoCliente WHERE idChofer = Old.idChofer;
			END LOOP;
		WHILE(EXISTS(SELECT * FROM manejar WHERE idChofer = Old.idChofer))
			LOOP
				DELETE FROM manejar WHERE idChofer = Old.idChofer;
			END LOOP;
		WHILE(EXISTS(SELECT * FROM vehiculo WHERE idChofer = Old.idChofer))
			LOOP
				DELETE FROM vehiculo WHERE idChofer = Old.idChofer;
			END LOOP;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_choferes
AFTER INSERT OR UPDATE OR DELETE
ON chofer
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_choferes();

CREATE OR REPLACE FUNCTION check_cambios_vehiculo() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroVehiculo(nombreUsuario, numeroEconomico, fecha, tipo) VALUES (user, NEW.numeroEconomico, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroVehiculo(nombreUsuario, numeroEconomico, fecha, tipo) VALUES (user, NEW.numeroEconomico, current_date, 'actualizacion');
		IF (NEW.baja and Old.baja=False) THEN
			WHILE(EXISTS(SELECT * FROM manejar WHERE numeroEconomico = Old.numeroEconomico))
				LOOP
					DELETE FROM manejar WHERE numeroEconomico=Old.numeroEconomico;
				END LOOP;
			WHILE(EXISTS(SELECT * FROM seguro WHERE numeroEconomico = Old.numeroEconomico))
				LOOP
					DELETE FROM seguro WHERE numeroEconomico=Old.numeroEconomico;
				END LOOP;
		END IF;
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroVehiculo(nombreUsuario, numeroEconomico, fecha, tipo) VALUES (user, NEW.numeroEconomico, current_date, 'borrado');
		WHILE(EXISTS(SELECT * FROM manejar WHERE numeroEconomico = Old.numeroEconomico))
			LOOP
				DELETE FROM manejar WHERE numeroEconomico=Old.numeroEconomico;
			END LOOP;
		WHILE(EXISTS(SELECT * FROM seguro WHERE numeroEconomico = Old.numeroEconomico))
			LOOP
				DELETE FROM seguro WHERE numeroEconomico=Old.numeroEconomico;
			END LOOP;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_vehiculo
AFTER INSERT OR UPDATE OR DELETE
ON vehiculo
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_vehiculo();

CREATE OR REPLACE FUNCTION check_insert_infraccion() 
RETURNS TRIGGER AS 
$$
BEGIN
	NEW.subsidio = 50;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_infraccion
BEFORE INSERT OR UPDATE
ON infraccion
FOR EACH ROW
EXECUTE PROCEDURE check_insert_infraccion();

CREATE OR REPLACE FUNCTION check_cambios_infraccion() 
RETURNS TRIGGER AS
$$
DECLARE
	esChof BOOLEAN;
BEGIN 
	IF TG_OP= 'INSERT' THEN
		SELECT esChofer INTO esChof FROM chofer WHERE idChofer = NEW.idChofer;
		IF esChof = False THEN
			RAISE EXCEPTION 'Las multas solo se pueden asignar a choferes';
		END IF;
		INSERT INTO registroInfraccion(nombreUsuario, numeroBoleta, fecha, tipo) VALUES (current_user, NEW.numeroBoleta, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroInfraccion(nombreUsuario, numeroBoleta, fecha, tipo) VALUES (current_user, NEW.numeroBoleta, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		SELECT esChofer INTO esChof FROM chofer WHERE idChofer = NEW.idChofer;
		IF esChof = False THEN
			RAISE EXCEPTION 'Las multas solo se pueden asignar a choferes';
		END IF;
		INSERT INTO registroInfraccion(nombreUsuario, numeroBoleta, fecha, tipo) VALUES (current_user, NEW.numeroBoleta, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_infraccion
AFTER INSERT OR UPDATE OR DELETE
ON infraccion
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_infraccion();

CREATE OR REPLACE FUNCTION check_cambios_viaje() 
RETURNS TRIGGER AS
$$
DECLARE
	esChof Boolean;
BEGIN 
	IF TG_OP= 'INSERT' THEN
		SELECT esChofer INTO esChof FROM chofer WHERE idChofer = NEW.idChofer;
		IF esChof = False THEN
			RAISE EXCEPTION 'El viaje solo puede ser realizado por choferes';
		END IF;
		INSERT INTO registroViaje VALUES (
			new.idViaje,new.idchofer,new.idCliente,new.numeroEconomico,new.calleOrigen,new.numeroInteriorOrigen,
			new.numeroExteriorOrigen,new.coloniaOrigen,new.cpOrigen,new.calleDestino,new.numeroInteriorDestino,
			new.numeroExteriorDestino,new.coloniaDestino,new.cpDestino,new.tiempo,new.distancia,new.dentroDeCU,
			new.numPasajerosExtra,new.fecha,new.hora,
			calcularCobro(new.numPasajerosExtra,calcularDescuento(new.idCliente),new.dentroDeCU,new.distancia,calculaNumV(new.idCliente))
		);
	END IF;
	IF TG_OP= 'UPDATE' THEN
		SELECT esChofer INTO esChof FROM chofer WHERE idChofer = NEW.idChofer;
		IF esChof = False THEN
			RAISE EXCEPTION 'El viaje solo puede ser realizado por choferes';
		END IF;
		INSERT INTO registroViaje VALUES (
			new.idViaje,new.idchofer,new.idCliente,new.numeroEconomico,new.calleOrigen,new.numeroInteriorOrigen,
			new.numeroExteriorOrigen,new.coloniaOrigen,new.cpOrigen,new.calleDestino,new.numeroInteriorDestino,
			new.numeroExteriorDestino,new.coloniaDestino,new.cpDestino,new.tiempo,new.distancia,new.dentroDeCU,
			new.numPasajerosExtra,new.fecha,new.hora,
			calcularCobro(new.numPasajerosExtra,calcularDescuento(idCliente),new.dentroDeCU,new.distancia,calculaNumV(idCliente))
		);
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroViaje VALUES (
			new.idViaje,new.idchofer,new.idCliente,new.numeroEconomico,new.calleOrigen,new.numeroInteriorOrigen,
			new.numeroExteriorOrigen,new.coloniaOrigen,new.cpOrigen,new.calleDestino,new.numeroInteriorDestino,
			new.numeroExteriorDestino,new.coloniaDestino,new.cpDestino,new.tiempo,new.distancia,new.dentroDeCU,
			new.numPasajerosExtra,new.fecha,new.hora,
			calcularCobro(new.numPasajerosExtra,calcularDescuento(idCliente),new.dentroDeCU,new.distancia,calculaNumV(idCliente))
		);
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_viaje
AFTER INSERT OR UPDATE OR DELETE
ON viaje
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_viaje();

CREATE OR REPLACE FUNCTION check_cambios_seguro() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroSeguro(nombreUsuario, aseguradora, numeroPoliza, fecha, tipo) VALUES (current_user, New.aseguradora, New.numeroPoliza, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroSeguro(nombreUsuario, aseguradora, numeroPoliza, fecha, tipo) VALUES (current_user, New.aseguradora, New.numeroPoliza, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroSeguro(nombreUsuario, aseguradora, numeroPoliza, fecha, tipo) VALUES (current_user, New.aseguradora, New.numeroPoliza, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_seguro
AFTER INSERT OR UPDATE OR DELETE
ON seguro
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_seguro();

CREATE OR REPLACE FUNCTION check_cambios_manejar() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroManejar(nombreUsuario, idChofer, numeroEconomico, fecha, tipo) VALUES (current_user, New.idChofer, New.numeroEconomico, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroManejar(nombreUsuario, idChofer, numeroEconomico, fecha, tipo) VALUES (current_user, New.idChofer, New.numeroEconomico, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroManejar(nombreUsuario, idChofer, numeroEconomico, fecha, tipo) VALUES (current_user, New.idChofer, New.numeroEconomico, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_manejar
AFTER INSERT OR UPDATE OR DELETE
ON manejar
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_manejar();

CREATE OR REPLACE FUNCTION check_cambios_telefonoCelularCliente() RETURNS TRIGGER 
AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroTelefonoCelularCliente(nombreUsuario, telefonoCelular, idCliente, fecha, tipo) VALUES (current_user, New.telefonoCelular, New.idCliente, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroTelefonoCelularCliente(nombreUsuario, telefonoCelular, idCLiente, fecha, tipo) VALUES (current_user, New.telefonoCelular, New.idCliente, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroTelefonoCelularCliente(nombreUsuario, telefonoCelular, idCLiente, fecha, tipo) VALUES (current_user, New.telefonoCelular, New.idCliente, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_telefonoCelularCliente
AFTER INSERT OR UPDATE OR DELETE
ON telefonoCelularCliente
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_telefonoCelularCliente();

CREATE OR REPLACE FUNCTION check_cambios_correoElectronicoCliente() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroCorreoElectronicoCliente(nombreUsuario, correoElectronico, idCliente, fecha, tipo) VALUES (current_user, New.correoElectronico, New.idCliente, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroCorreoElectronicoCliente(nombreUsuario, correoElectronico, idCliente, fecha, tipo) VALUES (current_user, New.correoElectronico, New.idCliente, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroCorreoElectronicoCliente(nombreUsuario, correoElectronico, idCliente, fecha, tipo) VALUES (current_user, New.correoElectronico, New.idCliente, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_correoElectronicoCliente
	AFTER INSERT OR UPDATE OR DELETE
	ON correoElectronicoCliente
	FOR EACH ROW
	EXECUTE PROCEDURE check_cambios_correoElectronicoCliente();

CREATE OR REPLACE FUNCTION check_cambios_telefonoCelularChofer() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroTelefonoCelularChofer(nombreUsuario, telefonoCelular, idChofer, fecha, tipo) VALUES (current_user, New.telefonoCelular, New.idChofer, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroTelefonoCelularChofer(nombreUsuario, telefonoCelular, idChofer, fecha, tipo) VALUES (current_user, New.telefonoCelular, New.idChofer, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroTelefonoCelularChofer(nombreUsuario, telefonoCelular, idChofer, fecha, tipo) VALUES (current_user, New.telefonoCelular, New.idChofer, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_telefonoCelularChofer
AFTER INSERT OR UPDATE OR DELETE
ON telefonoCelularChofer
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_telefonoCelularChofer();

CREATE OR REPLACE FUNCTION check_cambios_correoElectronicoChofer() 
RETURNS TRIGGER AS
$$
BEGIN 
	IF TG_OP= 'INSERT' THEN
		INSERT INTO registroCorreoElectronicoChofer(nombreUsuario, correoElectronico, idChofer, fecha, tipo) VALUES (current_user, New.correoElectronico, New.idChofer, current_date, 'insercion');
	END IF;
	IF TG_OP= 'UPDATE' THEN
		INSERT INTO registroCorreoElectronicoChofer(nombreUsuario, correoElectronico, idChofer, fecha, tipo) VALUES (current_user, New.correoElectronico, New.idChofer, current_date, 'actualizacion');
	END IF; 
	IF TG_OP = 'DELETE' THEN 
		INSERT INTO registroCorreoElectronicoChofer(nombreUsuario, correoElectronico, idChofer, fecha, tipo) VALUES (current_user, New.correoElectronico, New.idChofer, current_date, 'borrado');
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER registra_cambios_correoElectronicoChofer
AFTER INSERT OR UPDATE OR DELETE
ON correoElectronicoChofer
FOR EACH ROW
EXECUTE PROCEDURE check_cambios_correoElectronicoChofer();

create or replace function aplicaDescuento(cantidad numeric,descuento numeric)
returns numeric as 
$$
begin
	return cantidad * (descuento/100);
end;
$$
language plpgsql;

create or replace function calcularCobro(numPasajerosExtra int,descuentoCliente numeric,cu boolean,kilometros  numeric,numViajes boolean)
returns numeric as 
$$
declare 
descuento numeric;
preciocu numeric;
preciok numeric;
resultado numeric;
begin
	descuento := numPasajerosExtra*8 + descuentoCliente;
	if numViajes then
		preciocu := 15;
		preciok := 8;
	else
		preciocu := 20;
		preciok := 10;
	end if;
	if cu then
		resultado := preciocu * (descuento/100);
	else
		resultado := (preciocu + (preciok * kilometros)) * (descuento/100);
	end if;
	return resultado;
end;
$$
language plpgsql;

create or replace function calcularDescuento(id int)
returns numeric as 
$$
declare 
descuento numeric := 0;
fila cliente%rowtype;
begin 
	select *
	into fila
	from cliente
	where idcliente = id;
	if fila.esTrabajador or fila.esAcademico then 
		descuento := 10;
	else if fila.esAlumno then
		descuento := 15;
		end if;
	end if;
	return descuento;
end
$$
language plpgsql;

create or replace function calculaNumV(id int)
returns boolean as 
$$
declare
numero int;
resultado boolean = False ;
begin 
	select count (*) 
	into numero
	from viaje
	where idcliente = id;
	if (numero%6) = 0 then
		resultado = true;
	end if;
	return resultado;
end;
$$
language plpgsql;

create or replace function sacarGanancia(ganancia real, cu boolean)
returns numeric as 
$$
declare
g numeric;
begin 
	if cu then 
		g := ganancia * (0.08);
	else 
		g:= ganancia * (0.12);
	end if;
return g;
end;
$$
language plpgsql;

create or replace function obtenerbono(id int, f date)
returns numeric as 
$$
declare
viajes numeric := 0;
r numeric := 0;
suma numeric := 0;
begin 
	select count(*) 
	into viajes 
	from viaje 
	where idChofer = id and (date_part('year',fecha) = date_part('year',f) and date_part('month',fecha) = date_part('month',f));
	if viajes > 25 then
		select sum(cobro) into suma from registroViaje where idChofer = id; 
		r := suma * (0.1);
	end if;
	return r;
end;
$$
language plpgsql;

