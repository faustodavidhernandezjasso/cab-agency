----------------------------------------------------------------------------
----------------------------------DML---------------------------------------
----------------------------------------------------------------------------

insert into cliente values (1000,'Nombre','ApellidoP','ApellidoM','Calle',123,123,'colonia',12345,'fotografia.png','1:00 PM','1:00 PM',12312312,'lugar1','lugar2','lugar3',True,True,True);
insert into cliente values (3000,'Nombre','ApellidoP','ApellidoM','Calle',123,123,'colonia',12345,'fotografia.png','1:00 PM','1:00 PM',12312312,'lugar1',Null,Null,True,False,False);
insert into cliente values (2000,'Nombre','ApellidoP','ApellidoM','Calle',123,123,'colonia',12345,'fotografia.png','1:00 PM','1:00 PM',12312312,Null,'lugar2',Null,True,False,False);
insert into cliente values (4000,'Nombre','ApellidoP','ApellidoM','Calle',123,123,'colonia',12345,'fotografia.png','1:00 PM','1:00 PM',12312312,Null,Null,'lugar',False,False,True);

insert into chofer values (1000,'nombre','apellidop','apellidom','calle',111,222,'colonia',12345,'foro.png',current_date,null,11111123,True,True,'1231231231231');
insert into chofer values (2000,'nombre','apellidop','apellidom','calle',111,222,'colonia',12345,'foro.png',current_date,null,11111124,True,True,'1231231231233');
insert into chofer values (3000,'nombre','apellidop','apellidom','calle',111,222,'colonia',12345,'foro.png',current_date,null,11111125,True,True,'1231231231234');
insert into chofer values (4000,'nombre','apellidop','apellidom','calle',111,222,'colonia',12345,'foro.png',current_date,null,11111126,False,True,'1231111231234');

insert into vehiculo values (1000,1000,True,True,current_date,4,3,True,'marca','modelo',Null,False,3);
insert into vehiculo values (2000,1000,True,True,current_date,4,3,True,'marca','modelo',Null,False,3);
insert into vehiculo values (3000,2000,True,True,current_date,4,3,True,'marca','modelo',Null,False,3);
insert into vehiculo values (4000,2000,True,True,current_date,4,3,True,'marca','modelo',Null,False,3);
insert into vehiculo values (5000,3000,True,True,current_date,4,3,True,'marca','modelo',Null,False,3);

insert into infraccion values(1000,1000,1000,Null,current_time,'calle','alcaldia',12345,'nombre','apellidop','apellidom',current_date,5000,False);
insert into infraccion values(2000,2000,1000,Null,current_time,'calle','alcaldia',12345,'nombre','apellidop','apellidom',current_date,5000,True);
insert into infraccion values(3000,3000,2000,Null,current_time,'calle','alcaldia',12345,'nombre','apellidop','apellidom',current_date,5000,True);
insert into infraccion values(4000,4000,2000,Null,current_time,'calle','alcaldia',12345,'nombre','apellidop','apellidom',current_date,5000,False);
insert into infraccion values(5000,5000,3000,Null,current_time,'calle','alcaldia',12345,'nombre','apellidop','apellidom',current_date,5000,True);
insert into infraccion values(6000,1000,3000,Null,current_time,'calle','alcaldia',12345,'nombre','apellidop','apellidom',current_date,5000,False);

insert into viaje values (1000,1000,1000,1000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,3,current_date,current_time);
insert into viaje values (2000,1000,1000,1000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,2,current_date,current_time);
insert into viaje values (3000,2000,2000,2000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,1,current_date,current_time);
insert into viaje values (4000,2000,2000,2000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,0,current_date,current_time);
insert into viaje values (5000,1000,3000,3000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,3,current_date,current_time);
insert into viaje values (6000,1000,3000,3000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,2,current_date,current_time);
insert into viaje values (7000,1000,3000,3000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12,True,2,current_date,current_time);
insert into viaje values (8000,1000,3000,3000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,1200000,False,2,current_date,current_time);
insert into viaje values (9000,1000,3000,3000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,12000,False,2,current_date,current_time);
insert into viaje values (10000,1000,3000,3000,'corigen',1,2,'colorigen',12345,'cdestino',1,2,'coldestino',12345,10,1000,False,2,current_date,current_time);

insert into seguro values(1000,1000,'cobertura',current_date,'aseguradora');
insert into seguro values(2000,2000,'cobertura',current_date,'aseguradora');
insert into seguro values(3000,3000,'cobertura',current_date,'aseguradora');
insert into seguro values(4000,4000,'cobertura',current_date,'aseguradora');
insert into seguro values(5000,5000,'cobertura',current_date,'aseguradora');

insert into manejar values(1000,1000,'06:00 AM','06:00 AM');
insert into manejar values(1000,2000,'06:00 AM','06:00 AM');
insert into manejar values(1000,3000,'06:00 AM','06:00 AM');
insert into manejar values(2000,4000,'06:00 AM','06:00 AM');
insert into manejar values(1000,5000,'06:00 AM','06:00 AM');
insert into manejar values(2000,1000,'06:00 AM','06:00 AM');
insert into manejar values(2000,2000,'06:00 AM','06:00 AM');
insert into manejar values(2000,1000,'06:00 AM','06:00 AM');

insert into telefonoCelularCliente values (1231232112,1000);
insert into telefonoCelularCliente values (1231212112,1000);
insert into telefonoCelularCliente values (1231322112,2000);
insert into telefonoCelularCliente values (1231232312,2000);
insert into telefonoCelularCliente values (1231232412,3000);
insert into telefonoCelularCliente values (1231232512,3000);
insert into telefonoCelularCliente values (1231232612,3000);

insert into correoElectronicoCliente values('correo1',1000);
insert into correoElectronicoCliente values('correo2',1000);
insert into correoElectronicoCliente values('correo1',2000);
insert into correoElectronicoCliente values('correo2',2000);
insert into correoElectronicoCliente values('correo3',2000);

insert into telefonoCelularChofer values(12343,1000);
insert into telefonoCelularChofer values(123433,1000);
insert into telefonoCelularChofer values(123423,1000);
insert into telefonoCelularChofer values(123413,1000);
insert into telefonoCelularChofer values(12343,2000);
insert into telefonoCelularChofer values(1234323,2000);
insert into telefonoCelularChofer values(123423,2000);

insert into correoElectronicoChofer values ('correo',1000);
insert into correoElectronicoChofer values ('correo1',1000);
insert into correoElectronicoChofer values ('correo2',1000);
insert into correoElectronicoChofer values ('correo',2000);
insert into correoElectronicoChofer values ('correo1',2000);
insert into correoElectronicoChofer values ('correo2',2000);
