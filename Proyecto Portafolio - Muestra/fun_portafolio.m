function [esperanzaport, desvestport]=fun_portafolio(Precios,part)
[nprecios,activos]=size(Precios);
npart=size(part,1);
for k=1:activos
rend(:,k)=(Precios(2:nprecios,k)-Precios(1:nprecios-1,k))./Precios(1:nprecios-1,k);
end
esperanza=mean(rend);
varianza=var(rend);
desvest=std(rend);
covar=cov(rend);
esperanzaport=part*esperanza';
for k=1:npart
   riesgoport(k,:)=part(k,:)*covar*part(k,:)'; 
end
desvestport=sqrt(riesgoport);