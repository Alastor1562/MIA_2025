clear all; close all; clc;

%% Carga de datos

load datos4.mat

for k=1:35
    eval(sprintf('data(:,%d)=BMV_%dfinal(:,5)',k,k));
end

data = normalize(data);

%% Crear modelo neuronal

nn = 4;  % Número de neuronas

red = competlayer(nn); % Definir tipo de modelo

red.trainParam.epochs = 100;  % Configuración

red = train(red, data);  % Entrenamiento

%% Simulación

Wf = red.IW{1,1}';

Y = red(data);  % Y estimada
Y = vec2ind(Y);  % Convierte de vectores a índices
grupos = unique(Y);  % Devuelve valores únicos, quita repeticiones

%% Asignar los datos a cada grupo

for k = 1:size(grupos,2)
    temp = data(:,Y == grupos(1,k));

    eval(sprintf('grupo%d=temp;', grupos(1,k)))

    figure(k)
    eval(sprintf('plot(grupo%d);', grupos(1,k)))

end