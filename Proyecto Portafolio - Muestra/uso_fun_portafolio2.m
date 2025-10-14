act1=downloadValues('KO','02/18/2015', '02/18/2016','d','history');
act2=downloadValues('HD','02/18/2015', '02/18/2016','d','history');
act3=downloadValues('CMG','02/18/2015', '02/18/2016','d','history');
Precios=[act1.AdjClose act2.AdjClose act3.AdjClose];
npart=10000;
activos=size(Precios,2);
part=rand(size(Precios,2),npart);
suma=sum(part);
for k=1:activos
part(k,:)=part(k,:)./suma;
end
part=part';
[esperanzaport, desvestport]=fun_portafolio(Precios,part);
plot(desvestport,esperanzaport,'b.')

