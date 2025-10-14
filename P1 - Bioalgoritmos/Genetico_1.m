clear all;  %Borrar todas las variables del espacio de trabajo
close all;  %Cierra todas las ventanas emergentes
clc;        %Limpia la ventana de comandos

%% Parámetros inciales
%Cantidad de bits
nbits = 8;

%Cantidad de pobladores
np = 8;

%Rango de búsqueda
%Población incial
pobin = randi([0,255], np, 1);

%Función de ajuste
x = pobin;

for n = 1:100 %Cantidad de generaciones
    %% Evaluación
    y = x.^2; %Función de ajuste
    
    promy(n,1) = mean(y);

    cromosoma = [y x]; %Desempeño y población
    
    %% Selección por ranking
    cromosoma = sortrows(cromosoma,1,"descend"); %Ordenar de mayor a menor
    
    padredec = cromosoma(1:np/2,2); %Padres en decimal
    
    %% Codificación
    padrebin = de2bi(padredec, nbits); %Convertir a binario
    
    %% Cruzamiento
    % 1 punto de cruce
    for k=1:np/4
        p=randi([2, nbits-1]); %Posición 2 porque no queremos la primera posición
        hijobin(2*k-1, :) = [padrebin(2*k-1,1:p), padrebin(2*k, p+1:nbits)];
        hijobin(2*k,:) = [padrebin(2*k,1:p),padrebin(2*k-1,p+1:nbits)];
    end
    
    %% Mutación
    p = rand();

    if p >= 0.85 %Probabilidad de mutar de 15%
        hijo = randi(np/2);
        bit = randi(nbits);

        if hijobin(hijo, bit) == 1
            hijobin(hijo,bit) = 0;
        else
            hijobin(hijo,bit) = 1;
        end
    end

    hijodec = bi2de(hijobin); %Convertir de binario a decimal
    
    x = [padredec; hijodec];
end

plot(promy)
max(y)
max(x)