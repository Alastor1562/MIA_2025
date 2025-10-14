% Limpieza General
clear all;
close all;
clc;

%% Parámetros

xmax1 = 1024;
xmin1 = 1;

tp1 = 0.01; % Tamaño de Paso

elementos1 = ceil(((xmax1 - xmin1) / tp1) + 1); % Cantidad de números

nbits1 = ceil(log2(elementos1)); % Número de bits

np = 32; % Número de pobladores

x1 = randi([0,(2^nbits1 -1)], np, 1); % Población inicial en enteros

xreal1 = x1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1; % Conversión de enteros a reales

for i=1:1000 % Generaciones

    %% Función Objetivo
    
    y = - (xreal1 - 628) .^2 + 20;

    yprom(i,1) = mean(y);
    
    cromosoma = [y x1 xreal1];
    
    %% Selección por ranking
    cromosoma = sortrows(cromosoma,1,"descend"); %Ordenar de mayor a menor
    
    padresent1 = cromosoma(1:np/2,2); %Los padres en número entero
    
    padresreal1 = cromosoma(1:np/2,3); %Los padres en número real
    
    padresbin1 = de2bi(padresent1,nbits1); % Conversión a binario
    
    %% Cruzamiento
    % 2 puntos de cruce

    hijobin1 = tipodecruce(padresbin1,np,nbits1,2);
    
    %% Mutación
    
    hijobin1 = mutacion(hijobin1,np,nbits1,0.1);
    
    %% Reemplazo generacional
    
    hijoent1 = bi2de(hijobin1); %Convertir de binario a decimal
    
    hijoreal1 = hijoent1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1; % Conversión de hijos enteros a reales
    
    x1 = [padresent1; hijoent1]; % Actualizar variable entera
    
    xreal1 = [padresreal1; hijoreal1]; % Actualizar variable real

end

y = - (xreal1 + 20.85) .^2 + 100;
cromosoma = [y x1 xreal1];

[val, ind] = max(y);

disp(['Resultado: x1 = ', num2str(cromosoma(ind,3)),', y = ', num2str(val)])