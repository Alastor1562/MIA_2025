clear all; close all; clc;

%% Load data

load datos4.mat

data = IPCfinal(:,5);  % Precio ajustado al cierre del IPC

nrez = 3;  % Número de rezagos
diasfut = 4;  % Número de predicciones a futuro

temp = [];

for k=0:nrez+diasfut-1
    temp(:,k+1) = data(nrez+diasfut-k:end-k);
end

Y = temp(:,1:diasfut);  % Salida
X = temp(:,diasfut+1:end); % Matriz de entradas con rezagos

%% Partición

idx = round(size(X,1) * 0.85);

Xtrain = X(1:idx,:);
Ytrain = Y(1:idx,:);

%% Creación de modelo neuronal

red = feedforwardnet([10]);

red.trainFcn = 'trainlm'; % Configuración

red = train(red, Xtrain', Ytrain');

%% Simulación

Yg = red(X');  % Entrenamiento y prueba

for k=1:diasfut
    subplot(diasfut,1,k)
    plot(1:size(Y,1),Y(:,k),'b-',1:size(Yg',1),Yg(k,:)','r-')
    title(['IPC(t + ', num2str(diasfut-k+1), ')']);
end

J = perform(red, Y, Yg')