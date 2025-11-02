clear all; close all; clc;

%% Load data

load datos4.mat

X = [BMV_9final(:,5) BMV_17final(:,5)]; % Entrada
Y = [BMV_13final(:,5) IPCfinal(:,5)]; % Salida

%% Train-Test

idx = round(size(X,1) * 0.8);

Xtrain = X(1:idx,:);
Xtest = X(idx+1:end,:);

Ytrain = Y(1:idx, :);
Ytest = Y(idx+1:end,:);

%% Modelo

red = feedforwardnet([10]); %% Tipo de red
% Configuración
red.trainFcn = 'traingd'; % Entrenar por gradiente descendiente

red = train(red, Xtrain', Ytrain');

%% Simulación

Yg = red(X');

figure(1)
plot([1:size(X,1)]',Y(:,1),'b-',[1:size(X,1)]',Yg(1,:)','r-')

figure(2)
plot([1:size(X,1)]',Y(:,2),'b-',[1:size(X,1)]',Yg(2,:)','r-')

J = perform(red,Y,Yg')
J1 = perform(red,Y(:,1),Yg(1,:)')
J2 = perform(red,Y(:,2),Yg(2,:)')