% Limpieza general
clear all;
close all;
clc;

%% Parámetros generales
n = 2; % Número de variables
np = 640; % Pobladores
tp = [0.001 0.001];  % Tamaño de paso por variable (puedes personalizar)
xmin = 0 * ones(1,n);
xmax =  1 * ones(1,n);

%% Discretización
elementos = ceil(((xmax - xmin)./tp) + 1);
nbits = ceil(log2(elementos));

%% Población inicial

for j = 1:n
    x_ent(:,j) = randi([0, 2^nbits(j)-1], np, 1);
    x_real(:,j) = x_ent(:,j) * (xmax(j)-xmin(j)) / (2^nbits(j)-1) + xmin(j);
end

%% Bucle de generaciones
for i = 1:1000

    y = -(20 + x_real(:,1).^2 + x_real(:,2).^2 - 10*cos(2*pi*x_real(:,1)) - 10*cos(2*pi*x_real(:,2)));

    yprom(i,1) = mean(y);

    %% Construcción del cromosoma (como antes)
    cromosoma = y;
    for j = 1:n
        cromosoma = [cromosoma x_ent(:,j) x_real(:,j)];
    end

    %% Selección por ranking
    cromosoma = sortrows(cromosoma,1,"descend");

    % Padres

    for j = 1:n
        col_ent = 1 + (j-1)*2 + 1;
        col_real = 1 + (j-1)*2 + 2;
        padresent(:,j) = cromosoma(1:np/2, col_ent);
        padresreal(:,j) = cromosoma(1:np/2, col_real);
    end

    %% Cruzamiento y mutación (por variable)

    for j = 1:n
        padresbin = de2bi(padresent(:,j), nbits(j));
        hijobin = tipodecruce(padresbin, np, nbits(j), 5);
        hijobin = mutacion(hijobin, np, nbits(j), 0.1);
        hijosen(:,j) = bi2de(hijobin);
    end

    %% Conversión de hijos a reales

    for j = 1:n
        hijoreal(:,j) = hijosen(:,j) * (xmax(j)-xmin(j)) / (2^nbits(j)-1) + xmin(j);
    end

    %% Reemplazo generacional
    
    x_ent = [padresent; hijosen];
    x_real = [padresreal; hijoreal];

end

%% Evaluación final
y = -(20 + x_real(:,1).^2 + x_real(:,2).^2 - 10*cos(2*pi*x_real(:,1)) - 10*cos(2*pi*x_real(:,2)));
[val,ind] = max(y);

x_best = x_real(ind,:);
f_best = -val; % valor mínimo real de la función

for j = 1:n
    fprintf('x%d = %.8f\n', j, x_best(j));
end
fprintf('Fitness = %.8f\n', f_best);

figure; plot(yprom,'LineWidth',1.3);
xlabel('Generación'); ylabel('Fitness promedio (y)');
title('Convergencia del GA');
grid on;
