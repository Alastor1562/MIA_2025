% hijobin: Hijos en binario
% np: Número de pobladores
% nbits: Cantidad de bits necesarios
% prob: probabilidad de mutar en decimal

function y = mutacion_doble(hijobin,np,nbits,prob)

    p = rand();

    if p <= prob  % En nuestro caso seria prob = 0.15
        % Seleccionar dos hijos distintos
        hijos = randperm(np/2,2);  % dos índices diferentes
        hijo1 = hijos(1);
        hijo2 = hijos(2);

        % Seleccionar un bit al azar para cada hijo
        bit1 = randi(nbits);
        bit2 = randi(nbits);

        % Intercambiar los valores de esos bits
        temp = hijobin(hijo1,bit1);
        hijobin(hijo1,bit1) = hijobin(hijo2,bit2);
        hijobin(hijo2,bit2) = temp;
    end

    y = hijobin;

end % Final de función
