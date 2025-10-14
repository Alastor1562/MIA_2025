% Limpieza General
clear all;
close all;
clc;

%% Parámetros

xmax1 = 5.12;
xmin1 = -5.12; % Límites de la variable 1

xmax2 = 5.12;
xmin2 = -5.12; % Límites de la variable 2

tp1 = 0.005; % Tamaño de Paso
tp2 = 0.001;

elementos1 = ceil(((xmax1 - xmin1) / tp1) + 1);
elementos2 = ceil(((xmax2 - xmin2) / tp2) + 1); % Cantidad de números

nbits1 = ceil(log2(elementos1)); 
nbits2 = ceil(log2(elementos2)); % Número de bits

np = 640; % Número de pobladores

x1 = randi([0,(2^nbits1 -1)], np, 1);
x2 = randi([0,(2^nbits2 -1)], np, 1); % Población inicial en enteros

xreal1 = x1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1;
xreal2 = x2 * (xmax2 - xmin2) / (2^nbits2 - 1) + xmin2; % Conversión de enteros a reales

for i=1:1000 % Generaciones

    %% Función Objetivo
    
    y = -( 20 + xreal1.^2 + xreal2.^2 - 10*cos(2*pi*xreal1) - 10*cos(2*pi*xreal2) ); % Minimización

    yprom(i,1) = mean(y);
    
    cromosoma = [y x1 xreal1 x2 xreal2];
    
    %% Selección por ranking
    cromosoma = sortrows(cromosoma,1,"descend"); %Ordenar de mayor a menor
    
    padresent1 = cromosoma(1:np/2,2);
    padresent2 = cromosoma(1:np/2,4); %Los padres en número entero
    
    padresreal1 = cromosoma(1:np/2,3);
    padresreal2 = cromosoma(1:np/2,5); %Los padres en número real
    
    padresbin1 = de2bi(padresent1,nbits1);
    padresbin2 = de2bi(padresent2,nbits2); % Conversión a binario
    
    %% Cruzamiento
    % 2 puntos de cruce
    % Variable 1
    hijobin1 = tipodecruce(padresbin1,np,nbits1,2);

    % Variable 2
    hijobin2 = tipodecruce(padresbin2,np,nbits2,2);
    
    %% Mutación
    % Variable 1
    p = rand();
    
    if p >= 0.9 %Probabilidad de mutar de 10%
        hijo = randi(np/2);
        bit = randi(nbits1);
    
        if hijobin1(hijo, bit) == 1
            hijobin1(hijo,bit) = 0;
        else
            hijobin1(hijo,bit) = 1;
        end
    end
    
    % Variable 2
    p = rand();
    
    if p >= 0.95 %Probabilidad de mutar de 5%
        hijo = randi(np/2);
        bit = randi(nbits2);
    
        if hijobin2(hijo, bit) == 1
            hijobin2(hijo,bit) = 0;
        else
            hijobin2(hijo,bit) = 1;
        end
    end

    %% Reemplazo generacional
    
    hijoent1 = bi2de(hijobin1);
    hijoent2 = bi2de(hijobin2); %Convertir de binario a decimal
    
    hijoreal1 = hijoent1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1;
    hijoreal2 = hijoent2 * (xmax2 - xmin2) / (2^nbits2 - 1) + xmin2; % Conversión de hijos enteros a reales
    
    x1 = [padresent1; hijoent1];
    x2 = [padresent2; hijoent2];% Actualizar variable entera
    
    xreal1 = [padresreal1; hijoreal1];
    xreal2 = [padresreal2; hijoreal2]; % Actualizar variable real

end

y = -( 20 + xreal1.^2 + xreal2.^2 - 10*cos(2*pi*xreal1) - 10*cos(2*pi*xreal2) ); % Minimización

cromosoma = [y x1 xreal1 x2 xreal2];

[val, ind] = min(y); % Find the minimum value and its index

disp(['Resultado: x1 = ', num2str(cromosoma(ind,3)), ', x2 = ', num2str(cromosoma(ind,5)), ...
    ', y = ', num2str(-val)])