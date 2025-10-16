clear all; close all; clc;

%% Carga de datos

load datos1.mat

data = datos1;  % Renombrar las variables

%% Crear modelo neuronal

nn = 4;  % Número de neuronas

red = competlayer(nn); % Definir tipo de modelo

red.trainParam.epochs = 100;  % Configuración

red = train(red, data);  % Entrenamiento

%% Simulación

Wf = red.IW{1,1}';

plot(data(1,:), data(2,:),'b.', ...
    Wf(1,:), Wf(2,:), 'gp')

Y = red(data);  % Y estimada
Y = vec2ind(Y);  % Convierte de vectores a índices
grupos = unique(Y);  % Devuelve valores únicos, quita repeticiones

%% Asignar los datos a cada grupo

for k = 1:size(grupos,2)
    temp = data(Y == grupos(1,k));

    eval(sprintf('grupo%d=temp;', grupos(1,k)))

end