clear all; close all; clc;

rng(123456789)

tic

%% Datos: precios -> rendimientos -> covarianza
load data_proyecto.mat 

P = table2array(data);

R     = diff(log(P));             % rendimientos log diarios
Sigma = cov(R);                   % matriz de covarianza
n     = size(Sigma,1);            % n activos = número de variables del GA

%% Parámetros GA
np   = 640;                       % num pobladores
tp   = 0.001*ones(1,n);           % tamaño de paso por variable
xmin = zeros(1,n);                % pesos >= 0
xmax = ones(1,n);                 % pesos <= 1

elementos = ceil(((xmax - xmin)./tp) + 1);
nbits     = ceil(log2(elementos));

% Población inicial

for j = 1:n
    x_ent(:,j)  = randi([0, 2^nbits(j)-1], np, 1);
    x_real(:,j) = x_ent(:,j) * (xmax(j)-xmin(j)) / (2^nbits(j)-1) + xmin(j);
end

%% Fitness con restricciones
a = 100000; 

fun = @(W) -( sum((W*Sigma).*W,2) ...                     % varianza = w*Sigma*w'
                      + a * ( ...                         % Magnitud de la penalización
                           abs(sum(W,2) - 1).^2 ...       % suma a 1
                         + sum(max(0,-W),2) ...           % no-negatividad
                         + sum(max(0, W-1),2) ) );        % <= 1 (por si acaso)

%% Bucle sin finnnnnnnnnn
ngen = 1000;
yprom = zeros(ngen,1);

for i = 1:ngen
    % Evaluación de la población
    y = fun(x_real);

    % Promedio generación
    yprom(i,1) = mean(y);

    % Construcción de cromosoma
    cromosoma = y;
    for j = 1:n
        cromosoma = [cromosoma x_ent(:,j) x_real(:,j)];
    end

    % Selección por ranking
    cromosoma = sortrows(cromosoma,1,"descend");

    % Padres (mitad superior)
    for j = 1:n
        col_ent  = 1 + (j-1)*2 + 1;
        col_real = 1 + (j-1)*2 + 2;
        padresent(:,j) = cromosoma(1:np/2, col_ent);
        padresreal(:,j) = cromosoma(1:np/2, col_real);
    end

    % Cruzamiento + mutación por variable
    for j = 1:n
        padresbin = de2bi(padresent(:,j), nbits(j));
        hijobin = tipodecruce(padresbin, np, nbits(j), 5);
        hijobin = mutacion(hijobin, np, nbits(j), 0.1);
        hijosen(:,j) = bi2de(hijobin);
    end

    % Hijos: entero -> real
    for j = 1:n
        hijoreal(:,j) = hijosen(:,j) * (xmax(j)-xmin(j)) / (2^nbits(j)-1) + xmin(j);
    end

    % Reemplazo generacional
    x_ent  = [padresent; hijosen];
    x_real = [padresreal; hijoreal];
end

%% Resultados
y = fun(x_real);
[best_fit, ind] = max(y);

w_best_raw = x_real(ind,:); 

% Por si alguno de los pesos es negativo y/o la suma de éstos termina siendo 0
w_best = max(w_best_raw,0);
if sum(w_best) == 0, w_best = ones(1,n)/n; else, w_best = w_best/sum(w_best); end

var_min = w_best * Sigma * w_best';   % varianza mínima encontrada

% Imprime pesos
fprintf('--- Portafolio de mínima varianza (GA) ---\n');
for j = 1:n
    fprintf('w(%d) = %.6f\n', j, w_best(j));
end
fprintf('Suma de pesos = %.6f\n', sum(w_best));
fprintf('Varianza min   = %.8f\n', var_min);

% Curva de convergencia
figure; plot(yprom,'LineWidth',1.3);
xlabel('Generación'); ylabel('Fitness promedio');
title('Convergencia del GA (min varianza con penalización)');
grid on;

toc