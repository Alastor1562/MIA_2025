% Limpieza General
clear all;
close all;
clc;

%% Parámetros

xmax1 = 100;
xmin1 = 0; % Límites de la variable 1

xmax2 = 100;
xmin2 = 0; % Límites de la variable 2

xmax3 = 100;
xmin3 = 0; % Límites de la variable 3

tp1 = 1; % Tamaño de Paso
tp2 = 1;
tp3 = 0.001;

elementos1 = ceil(((xmax1 - xmin1) / tp1) + 1);
elementos2 = ceil(((xmax2 - xmin2) / tp2) + 1);
elementos3 = ceil(((xmax3 - xmin3) / tp3) + 1);  % Cantidad de números

nbits1 = ceil(log2(elementos1)); 
nbits2 = ceil(log2(elementos2));
nbits3 = ceil(log2(elementos3));   % Número de bits

np = 1024; % Número de pobladores

x1 = randi([0,(2^nbits1 -1)], np, 1);
x2 = randi([0,(2^nbits2 -1)], np, 1);
x3 = randi([0,(2^nbits3 -1)], np, 1);% Población inicial en enteros

xreal1 = round(x1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1);
xreal2 = round(x2 * (xmax2 - xmin2) / (2^nbits2 - 1) + xmin2);
xreal3 = x3 * (xmax3 - xmin3) / (2^nbits3 - 1) + xmin3;   % Conversión de enteros a reales

a = 1000;

for i=1:10000 % Generaciones

    %% Función Objetivo
    
    y = 20*xreal1 + 10*xreal2 + 25*xreal3 ...
        - a*max(0, 120 - (xreal1+xreal2+xreal3)) ...     
        - a*max(0, (3*xreal1+xreal2+2*xreal3) - 273) ... 
        - a*max(0, (xreal1+2*xreal2+5*xreal3) - 355) ... 
        - a*max(0,-xreal1) - a*max(0,-xreal2) -a*max(0,-xreal3);

    yprom(i,1) = mean(y);
    
    cromosoma = [y x1 xreal1 x2 xreal2 x3 xreal3];
    
    %% Selección por ranking
    cromosoma = sortrows(cromosoma,1,"descend"); %Ordenar de mayor a menor
    
    padresent1 = cromosoma(1:np/2,2);
    padresent2 = cromosoma(1:np/2,4);
    padresent3 = cromosoma(1:np/2,6);   %Los padres en número entero
    
    padresreal1 = cromosoma(1:np/2,3);
    padresreal2 = cromosoma(1:np/2,5);
    padresreal3 = cromosoma(1:np/2,7);  %Los padres en número real
    
    padresbin1 = de2bi(padresent1,nbits1);
    padresbin2 = de2bi(padresent2,nbits2);
    padresbin3 = de2bi(padresent2,nbits3);      % Conversión a binario
    
    %% Cruzamiento
    % 2 puntos de cruce
    % Variable 1
    hijobin1 = tipodecruce(padresbin1,np,nbits1,2);

    % Variable 2
    hijobin2 = tipodecruce(padresbin2,np,nbits2,2);

    % Variable 3
    hijobin3 = tipodecruce(padresbin3,np,nbits3,2);
    
    %% Mutación
    % Variable 1
    p = rand();
    
    if p >= 0.95
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
    
    if p >= 0.95
        hijo = randi(np/2);
        bit = randi(nbits2);
    
        if hijobin2(hijo, bit) == 1
            hijobin2(hijo,bit) = 0;
        else
            hijobin2(hijo,bit) = 1;
        end
    end

    % Variable 3
    p = rand();
    
    if p >= 0.95
        hijo = randi(np/2);
        bit = randi(nbits3);
    
        if hijobin3(hijo, bit) == 1
            hijobin3(hijo,bit) = 0;
        else
            hijobin3(hijo,bit) = 1;
        end
    end

    %% Reemplazo generacional
    
    hijoent1 = bi2de(hijobin1);
    hijoent2 = bi2de(hijobin2);
    hijoent3 = bi2de(hijobin3); %Convertir de binario a decimal
    
    hijoreal1 = round(hijoent1 * (xmax1 - xmin1) / (2^nbits1 - 1) + xmin1);
    hijoreal2 = round(hijoent2 * (xmax2 - xmin2) / (2^nbits2 - 1) + xmin2);
    hijoreal3 = hijoent3 * (xmax3 - xmin3) / (2^nbits3 - 1) + xmin3;    % Conversión de hijos enteros a reales
    
    x1 = [padresent1; hijoent1];
    x2 = [padresent2; hijoent2];
    x3 = [padresent3; hijoent3];        % Actualizar variable entera
    
    xreal1 = [padresreal1; hijoreal1];
    xreal2 = [padresreal2; hijoreal2];
    xreal3 = [padresreal3; hijoreal3];      % Actualizar variable real

end

y = 20*xreal1 + 10*xreal2 + 25*xreal3;

cromosoma = [y x1 xreal1 x2 xreal2 x3 xreal3];

[val, ind] = max(y); % Find the minimum value and its index

disp(['Resultado: x1 = ', num2str(cromosoma(ind,3)), ', x2 = ', num2str(cromosoma(ind,5)), ...
    ', x3 = ', num2str(cromosoma(ind,7)), ', y = ', num2str(val)])