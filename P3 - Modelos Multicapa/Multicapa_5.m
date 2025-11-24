clear all; close all; clc;

%% Cargar datos
load data1.txt;

data = data1;

% Separación de datos (Opcional)
G0 = data(data(:,3)==0,1:2); % Grupo 0

G1 = data(data(:,3)==1,1:2); % Grupo 1

plot(G0(:,1), G0(:,2), 'bo', G1(:,1), G1(:,2), 'rx')

%% Separación de datos
X = data(:, 1:2);  % Variables de entrada

Y = data(:,3);  % salidas de 1s y 0s

%% Modelo
red = feedforwardnet([10 10 10]);  % Tipo de red
% Configurar red
red.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)

% Entrenamiento
red = train(red, X', Y');

%% Simulación
Yg = round(red(X'))';

%% Medidas de desempeño
A = confusionmat(Y, Yg);

figure(2)
confusionchart(A, [0,1])

TP = A(2,2);  % Verdaderos positivos
TN = A(1,1);  % Verdaderos negativos
FP = A(1,2);  % Falsos positivos
FN = A(2,1);  % Falsos negativos

exa = (TP+TN) / (TP+TN+FP+FN);  % Exactitud
pre = TP / (TP+FP);  % Precisión
rec = TP / (TP+FN);  % Recall

[exa, pre, rec]