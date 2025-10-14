% hijobin: Hijos en binario
% np: Número de pobladores
% nbits: Cantidad de bits necesarios
% prob: probabilidad de mutar en decimal

function y = mutacion(hijobin,np,nbits,prob)

    p = rand();
    
    if p >= (1-prob)
        hijo = randi(np/2);
        bit = randi(nbits);
    
        if hijobin(hijo, bit) == 1
            hijobin(hijo,bit) = 0;
        else
            hijobin(hijo,bit) = 1;
        end
    end

    y = hijobin;

end % Final de función