%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   TRADING ALGORITHM USING A MOVING AVERAGE    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Obtaining the data that will be used to simulate the trading algorithm
hoy=datestr(date,23);
inicio=datestr(datenum(date)-365,23);
data = downloadValues('GRUMAB.MX',inicio,hoy,'d','history');
precios = data.AdjClose; %Select the closing prices

%% Trading algorithm based on a moving average
npm = 9; %Number of days used to calculate the moving average
cap = 10000*ones(size(precios)); %Initial capital to be invested
nac = 0*ones(size(precios)); %Number of shares available at the start of the simulation
com = 0.0029; %Comisión por operación

% Simulation of the algorithm
for t = 0:size(precios,1)-npm
    pm(npm+t,1) = mean(precios(t+1:npm+t,1)); %Calculating the moving average
    
    if pm(npm+t,1)<precios(npm+t,1)
        % Buy, if the moving average is less than the current price
        u = floor((cap(npm+t,1))/((1+com)*precios(npm+t,1)));
    else
        % Sell, if the moving average is greater than the current price
        u = -nac(npm+t,1);
    end
    nac(npm+t+1,1) = nac(npm+t,1)+u;
    cap(npm+t+1,1) = cap(npm+t,1)-precios(npm+t,1)*u-com*precios(npm+t,1)*abs(u);
end

%% Display of results
T = (1:size(precios,1))';
figure(1);
subplot(4,1,1);
plot(T,precios,'b-',T(npm:end),pm(npm:end),'r--');
title(sprintf('Moving Average to %d days',npm)),xlabel('# days'), ylabel('price');
legend('price','average','Location','NorthEastOutside');
grid;
subplot(4,1,2);
plot(T,nac(1:end-1,1),'b-');
xlabel('# days'), ylabel('# shares');
legend('# shares','Location','NorthEastOutside');
grid;
subplot(4,1,3);
plot(T,cap(1:end-1,1),'b-');
xlabel('# days'), ylabel('$');
legend('capital','Location','NorthEastOutside');
grid;
subplot(4,1,4);
plot(T,100*(cap(1:end-1,1)+precios.*nac(1:end-1,1)-cap(1,1))/cap(1,1),'b-');
xlabel('# days'), ylabel('yield (%)');
legend('Total','Location','NorthEastOutside');
grid;