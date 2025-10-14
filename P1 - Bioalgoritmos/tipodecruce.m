% y: Hijos en binario
% padresbin: Padres en binario
% np: Cantidad de pobladores
% nbits: Cantidad de bits necesaria
% n: Tipo de cruce

function y = tipodecruce(padresbin,np,nbits,n)

    switch n
        case 1 % Cruce de 1 punto
            for k=1:np/4
                p=randi([2, nbits-1]);
                hijobin(2*k-1, :) = [padresbin(2*k-1,1:p), padresbin(2*k, p+1:nbits)];
                hijobin(2*k,:) = [padresbin(2*k,1:p),padresbin(2*k-1,p+1:nbits)];
            end
    
            y = hijobin;
        
        case 2 % Cruce de 2 puntos
            for k=1:np/4
                p1=randi([2, nbits-2]);
                p2=randi([p1 + 1, nbits-1]);
            
                hijobin(2*k-1, :) = [padresbin(2*k-1,1:p1), padresbin(2*k,p1+1:p2), padresbin(2*k-1, p2+1:nbits)];
            
                hijobin(2*k,:) = [padresbin(2*k,1:p1), padresbin(2*k-1,p1+1:p2), padresbin(2*k, p2+1:nbits)];
            end
    
            y = hijobin;
    
        case 3 % Cruce uniforme
            for h=1:np/4
                for k=1:nbits
                    p = rand();
                    
                    if p >= 0.5
                        hijobin(2*h-1,k) = padresbin(2*h-1,k);
                        hijobin(2*h,k) = padresbin(2*h,k);
                    
                    else
                        hijobin(2*h-1,k) = padresbin(2*h,k);
                        hijobin(2*h,k) = padresbin(2*h-1,k);
                    
                    end
                end
            end
    
            y = hijobin;
        
        case 4 % Cruce Aditivo
            padresreal = bi2de(padresbin);
            for k = 1:np/4
                a = rand();
                hijoreal(2*k-1) = round(a*padresreal(2*k-1) + (1-a)*padresreal(2*k));
                hijoreal(2*k) = round(a*padresreal(2*k) + (1-a)*padresreal(2*k-1));
            end
            
            hijobin = de2bi(hijoreal, nbits); % Convert real offspring back to binary
    
            y = hijobin;
        
        otherwise
            disp('Ese número no trunca')
            
    end % Final de Switch

end % Final de función