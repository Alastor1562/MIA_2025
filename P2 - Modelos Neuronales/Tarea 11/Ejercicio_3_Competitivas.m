clear all; close all; clc;

rng(1234)

%% Carga de datos
load KnowledgeModeling.mat

data = table2array(Train)';
classify = table2array(Classify)';

%% Experimento: #neuronas vs costo

lista_nn = 2:5;
costos  = zeros(size(lista_nn));

for i = 1:numel(lista_nn)
    nn = lista_nn(i);

    % Crear y entrenar red competitiva
    red = competlayer(nn);
    red.trainParam.epochs = 100;
    red = train(red, data);

    % Pesos finales y asignaciones
    Wf = red.IW{1,1}.';          % d x nn
    Y  = vec2ind(red(data));        % 1 x N (índice de neurona ganadora por muestra)

    % Construir matriz de pesos asignados por muestra (d x N)
    W_asignado = Wf(:, Y);

    % Costo (promedio de normas columna a columna)
    costos(i) = funcs.func_costo_competitivas(data, W_asignado);
    fprintf('nn=%d  ->  costo=%.6f\n', nn, costos(i));
end

% Gráfica costo vs #neuronas
figure; 
plot(lista_nn, costos, '-o','LineWidth',1.5);
xlabel('Número de neuronas'); 
ylabel('Costo competitivo promedio');
title('Costo vs número de neuronas'); 
grid on;


%% Modelo adecuado

nn = 4;
red = competlayer(nn);
red.trainParam.epochs = 100;
red = train(red, data);

%% Simulación

Wf = red.IW{1,1}';

Y = vec2ind(red(data));
grupos = unique(Y);  % Devuelve valores únicos, quita repeticiones

%% Asignar los datos a cada grupo

for k = 1:size(grupos,2)
    temp = data(:,Y == grupos(1,k));
    eval(sprintf('grupo%d_train=temp;', grupos(1,k)))

    % Cantidad de datos por grupo

    eval(sprintf('n_datos=size(grupo%d_train,2);', grupos(1,k)))

    fprintf('grupo %d  ->  %d datos\n', grupos(1,k), n_datos);
end

%% Clasificar nuevos datos
Y_classify = vec2ind(red(classify'));  % Índice de neurona ganadora para cada muestra nueva

Predicciones = [classify; Y_classify]'
