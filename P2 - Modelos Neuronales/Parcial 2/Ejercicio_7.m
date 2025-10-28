clear all;
close all;
clc;
rng(7); 

%% Cargar Datos
load base_semillas.mat
data = base_semillas; % copia de los datos
[d, N] = size(data); % obtiene el número de filas (d) y columnas (N) de la matriz data

% Estandarización de los datos
% para que todas las variables tengan igual peso en las distancias
mu = mean(data, 2); % media de cada variable (por fila)
sd = std(data, 0, 2); % desviación estándar de cada variable
sd(sd == 0) = 1; % evita división por cero si alguna sd es 0
data = (data - mu) ./ sd; % resta la media y divide por la desviación estándar


%% Parámetros generales
epochs = 200; % número de épocas
eta = 0.05; % velocidad de convergencia
neuronas_lista = [2, 3]; % 2 y 3 neuronas

% Función de costo J: promedio de distancia Euclídea al centro asignado
% Métrica de error (costo promedio de distancias a su centro)
calcJ = @(data, W, gan) mean( sqrt( sum( (data - W(:,gan)).^2 , 1 ) ) );
% Se usó la medición de la distancia Euclídea por ser la más exacta

% guardar resultados
RESULT = struct([]);

%% Entrenamiento competitivo 
for caso = 1:length(neuronas_lista)
    nn = neuronas_lista(caso); % número de neuronas que se van a probar (2 o 3)

    % Elegir centros iniciales al azar (a partir de muestras reales)
    idx0 = randperm(N, nn);
    W = data(:, idx0); % cada columna de W es una neurona o centro

    % Entrenamiento de la red 
    for nepoc = 1:epochs % repetir varias veces sobre todos los datos
        for k = 1:N % recorrer cada muestra del conjunto
            xk = data(:,k); % tomar una muestra

            % Calcular qué tan lejos está la muestra de cada neurona
            for j = 1:nn
                distancia(1,j) = sum((xk - W(:,j)).^2); % distancia Euclídea al cuadrado
            end

            % Buscar la neurona más cercana (ganadora)
            [~, ind] = min(distancia);

            % Mover el peso de la neurona ganadora hacia la muestra
            W(:,ind) = W(:,ind) + eta*(xk - W(:,ind));
        end
    end


    % Asignación final de cada muestra al centro más cercano
    ganador = zeros(1,N); % vector donde se guarda qué neurona ganó para cada muestra
    for k = 1:N  % recorre todas las muestras
        xk = data(:,k); % tomar la muestra k
        for j = 1:nn % calcular la distancia a cada neurona
            distancia(1,j) = sum((xk - W(:,j)).^2); % distancia Euclídea al cuadrado
        end
        [~, ganador(k)] = min(distancia); % guardar la neurona que quedó más cerca (ganadora)
    end

    % Conteo por grupo (INCISOS: a y c)
    conteos = zeros(1,nn); % Un vector para contar cuántas muestras tiene cada grupo
    for j = 1:nn
        conteos(j) = sum(ganador == j); % cuenta cuántas veces ganó cada neurona
    end

    % Costo J (INCISOS: b y d)
    J = calcJ(data, W, ganador); % calcula el costo promedio (distancia media a su centro asignado)

    % Guardar resultados
    RESULT(caso).nn = nn; % número de neuronas del modelo
    RESULT(caso).W = W; % pesos finales (centros)
    RESULT(caso).ganador = ganador; % índice del grupo ganador por muestra
    RESULT(caso).conteos = conteos; % cantidad de muestras por grupo
    RESULT(caso).J = J;  % costo del modelo (promedio de distancias)
end


%% Resultados
% (a) Modelo con 2 neuronas, cuántos datos hay en cada grupo
fprintf('\n(a) Modelo con 2 neuronas:\n');
fprintf('Conteos por grupo: ');
fprintf('%d ', RESULT(1).conteos);
fprintf('\n');

% (b) Costo del modelo con 2 neuronas
fprintf('\n(b) Costo J (2 neuronas): %.6f\n', RESULT(1).J);

% (c) Modelo con 3 neuronas, cuántos datos hay en cada grupo
fprintf('\n(c) Modelo con 3 neuronas:\n');
fprintf('Conteos por grupo: ');
fprintf('%d ', RESULT(2).conteos);
fprintf('\n');

% (d) Costo del modelo con 3 neuronas
fprintf('\n(d) Costo J (3 neuronas): %.6f\n', RESULT(2).J);

% (e) Indicar cuál modelo es mejor
[~, idx_best] = min([RESULT.J]);
fprintf('\n(e) El mejor modelo es el de %d neuronas porque tiene menor costo J (%.6f).\n', ...
    RESULT(idx_best).nn, RESULT(idx_best).J);

% (f) Mostrar el código de J utilizado
fprintf('\n(f) Código de J:\n');
fprintf('J = mean( sqrt( sum( (data - W(:,gan)).^2 , 1 ) ) );\n');
