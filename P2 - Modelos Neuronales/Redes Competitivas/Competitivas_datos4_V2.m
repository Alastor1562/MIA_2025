clear all; close all; clc;

%% Carga de datos

load datos4.mat

temp = BMV_17final(:,5);
ventana = 10;

for k=1:size(temp,1)-ventana
    data(:,k) = temp(k:k+ventana-1,1); 
end

data = normalize(data);

%% Crear modelo neuronal

nn = 8;  % Número de neuronas

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

figure(k+1)
subplot(2,1,1)
plot(BMV_17final(:,5))
subplot(2,1,2)
bar(Y)