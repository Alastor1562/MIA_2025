clear all; close all; clc;

%% Carga de datos
load datos1.mat
A = datos1;             

%% Experimento: #neuronas vs costo

lista_nn = 2:10;
costos  = zeros(size(lista_nn));

for i = 1:numel(lista_nn)
    nn = lista_nn(i);

    % 1) Crear y entrenar red competitiva
    red = competlayer(nn);
    red.trainParam.epochs = 100;
    red = train(red, A);

    % 2) Pesos finales y asignaciones
    Wf = red.IW{1,1}.';          % d x nn
    Y  = vec2ind(red(A));        % 1 x N (índice de neurona ganadora por muestra)

    % 3) Construir matriz de pesos asignados por muestra (d x N)
    W_asignado = Wf(:, Y);

    % 4) Costo (promedio de normas columna a columna)
    costos(i) = func_costo_competitivas(A, W_asignado);
    fprintf('nn=%d  ->  costo=%.6f\n', nn, costos(i));
end

% 5) Gráfica costo vs #neuronas
figure; 
plot(lista_nn, costos, '-o','LineWidth',1.5);
xlabel('Número de neuronas'); 
ylabel('Costo competitivo promedio');
title('Costo vs número de neuronas'); 
grid on;

% 6) Mejor # de neuronas (mínimo costo)
[val, idx] = min(costos);
mejor_nn = lista_nn(idx);
fprintf('\nMejor configuración: nn=%d con costo=%.6f\n', mejor_nn, val);
