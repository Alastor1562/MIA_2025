Precios=xlsread('Proyecto1.xls', 'MarkowitzyCAPM','C4:E64');
npart=10000;
activos=size(Precios,2);
part=rand(size(Precios,2),npart);
suma=sum(part);
for k=1:activos
part(k,:)=part(k,:)./suma;
end
part=part';
[esperanzaport, desvestport]=fun_portafolio(Precios,part);
plot(desvestport,esperanzaport,'b.');

