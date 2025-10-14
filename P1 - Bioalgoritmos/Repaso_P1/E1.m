% Limpieza General
clear all;
close all;
clc;

%% Parámetros

xmax1 = 1024;
xmin1 = 1;

tp1 = 1; % Tamaño de Paso

elementos1 = ceil(((xmax1 - xmin1) / tp1) + 1); % Cantidad de números

nbits1 = ceil(log2(elementos1)); % Número de bits

np = 32; % Número de pobladores

x1 = randi([0,(2^nbits1 -1)], np, 1); % Población inicial en enteros

xreal1 = x1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1; % Conversión de enteros a reales

for i=1:10000 % Generaciones

    %% Función Objetivo
    
    y = -(xreal1-628).^2 + 20;

    yprom(i,1) = mean(y);
    
    cromosoma = [y x1 xreal1];
    
    %% Selección por Torneo
    cromosoma = sortrows(cromosoma,1,"descend"); %Ordenar de mayor a menor

    for i=1:np/2

        p = rand();

        if p <= 0.8
            padresent1(i,1) = cromosoma(2*i-1, 2);
            padresreal1(i,1) = cromosoma(2*i-1, 3);
        else
            padresent1(i,1) = cromosoma(2*i, 2);
            padresreal1(i,1) = cromosoma(2*i, 3);
        end
    
    end
    
    padresbin1 = de2bi(padresent1,nbits1); % Conversión a binario
    
    %% Cruzamiento
    % 3 puntos de cruce

    for k = 1:np/2
        p1=randi([2, nbits1-2]);
        p2=randi([p1 + 1, nbits1-1]);

        m1 = randi([1, np/2]);
        m2 = randi([1, np/2]);
        m3 = randi([1, np/2]);
    
        hijobin1(k, :) = [padresbin1(m1,1:p1), padresbin1(m2,p1+1:p2), padresbin1(m3, p2+1:nbits1)];

    end

    %% Mutación
    
    hijobin1 = mutacion(hijobin1,np,nbits1,0.1);
    
    %% Reemplazo generacional
    
    hijoent1 = bi2de(hijobin1); %Convertir de binario a decimal
    
    hijoreal1 = hijoent1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1; % Conversión de hijos enteros a reales
    
    x1 = [padresent1; hijoent1]; % Actualizar variable entera
    
    xreal1 = [padresreal1; hijoreal1]; % Actualizar variable real

end

y = -(xreal1-628).^2 + 20;
cromosoma = [y x1 xreal1];

[val, ind] = max(y);

disp(['Resultado: x1 = ', num2str(cromosoma(ind,3)),', y = ', num2str(val)])