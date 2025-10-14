%Mi primer PSO

clear all; %limpieza general
close all;
clc;

act1=downloadValues('KO','02/18/2015', '02/18/2016','d','history');
act2=downloadValues('HD','02/18/2015', '02/18/2016','d','history');
act3=downloadValues('CMG','02/18/2015', '02/18/2016','d','history');
Precios=[act1.AdjClose act2.AdjClose act3.AdjClose];

load portafolio.mat;
% x=-10:0.01:10;
% y=x.^2;
% y=10+x.^2-15*cos(5*x);
% y=-15*exp(-15*sqrt((x.^2)/2))-exp(cos(15*x)/2)+15+exp(1);

np=2000; %Número de particulas

x1p=rand(np,1); % inicialización
x1pg=0; %valor inicial del mejor global
x1pL=x1p; %valores inciales de mejores locales
vx1=zeros(np,1);  %velocidad del enjambre



x2p=rand(np,1); % inicialización
x2pg=0; %valor inicial del mejor global
x2pL=x1p; %valores inciales de mejores locales
vx2=zeros(np,1);  %velocidad del enjambre

x3p=rand(np,1); % inicialización
x3pg=0; %valor inicial del mejor global
x3pL=x1p; %valores inciales de mejores locales
vx3=zeros(np,1);  %velocidad del enjambre

fxpg=1000000; %desempeño valor inicial del mejor global
fxpL=ones(np,1)*fxpg; %desempeño delos mejores locales

c1=0.01;  %Velocidad de convergencia al  mejor global
c2=0.01; %velocidad de convergencia al mejor local



for k=1:2500
a=1000;
[Rend,Risk]=fun_portafolio(Precios,[x1p x2p x3p]);


fx=-(1000*Rend-1000*Risk)+a*abs(x1p+x2p+x3p-1)...
    +a*max(-x1p,0)+a*max(x1p-1,0)...
    +a*max(-x2p,0)+a*max(x2p-1,0)...
    +a*max(-x3p,0)+a*max(x3p-1,0);    

%Si quisiera minimizar riesgo (10000*Risk)
%Si se quisiera un balance entre riesgo y rendimiento 
%Esto es un punto medio -(10000*Rend-10000*Risk)
% si quiero minimizar -(10000*Rend-20000*Risk)

%Para determinar el mejor global
[val,ind]=min(fx);
if val<fxpg
    x1pg=x1p(ind,1);
    x2pg=x2p(ind,1);
    x3pg=x3p(ind,1);
    fxpg=val;
end

%Para determinar los mejores locales
for p=1:np
    if fx(p,1)<fxpL(p,1)
        fxpL(p,1)=fx(p,1);
        x1pL(p,1)=x1p(p,1);
        x2pL(p,1)=x2p(p,1);
        x3pL(p,1)=x3p(p,1);
    end
end
[Rendpg,Riskpg]=fun_portafolio(Precios,[x1pg x2pg x3pg]);
plot(desvestport,esperanzaport,'b.',Risk,Rend,'r.',Riskpg,Rendpg,'go'); % tercer paramétro es color y tipo de línea
axis([0.005 0.02 -0.001 0.0005]);
title(['X1pg=' num2str(x1pg) ', X2pg=' num2str(x2pg) ', X3pg=' num2str(x3pg)]);
grid;
pause(0.01);

%Ecuaciones de movimiento
vx1=vx1+c1*rand(np,1).*(x1pg-x1p)+c2*rand()*(x1pL-x1p);
x1p=x1p+vx1;
%rand(np,1). sirve para darle una velocidad diferente a cada particula

vx2=vx2+c1*rand(np,1).*(x2pg-x2p)+c2*rand()*(x2pL-x2p);
x2p=x2p+vx2;

vx3=vx3+c1*rand(np,1).*(x3pg-x3p)+c2*rand()*(x3pL-x3p);
x3p=x3p+vx3;

end