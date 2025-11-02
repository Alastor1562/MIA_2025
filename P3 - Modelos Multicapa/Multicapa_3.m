clear all; close all; clc;

%% Load data

load datos4.mat

data = IPCfinal(:,5);  % Precio ajustado al cierre del IPC

nrez = 6;  % Número de rezagos

temp = [];

for k=0:nrez
    temp(:,k+1) = data(nrez+1-k:end-k);
end

Y = temp(:,1);  % Salida
X = temp(:,2:end); % Matriz de entradas con rezagos

%% Partición

idx = round(size(X,1) * 0.85);

Xtrain = X(1:idx,:);
Ytrain = Y(1:idx,:);

%% Creación de modelo neuronal

red = feedforwardnet([10]);

red.trainFcn = 'trainlm'; % Configuración

red = train(red, Xtrain', Ytrain');

%% Simulación

Yg = red(X');

plot([1:size(X,1)]',Y,'b-',[1:size(X,1)]',Yg','r-')

J = perform(red, Y, Yg')