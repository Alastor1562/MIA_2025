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
                hijobin(2*k,:)   = [padresbin(2*k,1:p),   padresbin(2*k-1,p+1:nbits)];
            end
            y = hijobin;

        case 2 % Cruce de 2 puntos
            for k=1:np/4
                p1 = randi([2, nbits-2]);
                p2 = randi([p1+1, nbits-1]);
                hijobin(2*k-1,:) = [padresbin(2*k-1,1:p1), padresbin(2*k,  p1+1:p2), padresbin(2*k-1, p2+1:nbits)];
                hijobin(2*k,:)   = [padresbin(2*k,  1:p1), padresbin(2*k-1,p1+1:p2), padresbin(2*k,   p2+1:nbits)];
            end
            y = hijobin;

        case 3 % Cruce uniforme
            for h=1:np/4
                for kbit=1:nbits
                    if rand() >= 0.5
                        hijobin(2*h-1,kbit) = padresbin(2*h-1,kbit);
                        hijobin(2*h,  kbit) = padresbin(2*h,  kbit);
                    else
                        hijobin(2*h-1,kbit) = padresbin(2*h,  kbit);
                        hijobin(2*h,  kbit) = padresbin(2*h-1,kbit);
                    end
                end
            end
            y = hijobin;

        case 4 % Cruce aditivo en entero (vía real)
            padresent = bi2de(padresbin);           % default: 'right-msb'
            for k = 1:np/4
                a = rand();
                h1 = round(a*padresent(2*k-1) + (1-a)*padresent(2*k));
                h2 = round(a*padresent(2*k)   + (1-a)*padresent(2*k-1));
                % recorta al rango válido
                h1 = min(max(h1,0), 2^nbits - 1);
                h2 = min(max(h2,0), 2^nbits - 1);
                hijobin(2*k-1,:) = de2bi(h1, nbits);
                hijobin(2*k,  :) = de2bi(h2, nbits);
            end
            y = hijobin;

        case 5 % Cruce HEURÍSTICO (entero) — asume fila (2k-1) es mejor que (2k)
            % Hijo = best + r*(best - worst), r ~ U[0,1], por pareja generamos 2 hijos
            padresent = bi2de(padresbin);           % entero [0, 2^nbits-1], 'right-msb'
            maxval    = 2^nbits - 1;
            for k = 1:np/4
                i1 = 2*k - 1; i2 = 2*k;
                best  = padresent(i1);  % por ranking previo
                worst = padresent(i2);

                if best == worst
                    % si son idénticos, copiamos (evita estancarse por fuera del rango)
                    h1 = best; 
                    h2 = worst;
                else
                    r1 = rand(); 
                    r2 = rand();
                    h1 = round( best + r1*(best - worst) );
                    h2 = round( best + r2*(best - worst) );
                    % recorta al rango válido
                    h1 = min(max(h1,0), maxval);
                    h2 = min(max(h2,0), maxval);
                end

                hijobin(i1,:) = de2bi(h1, nbits);   % vuelve a binario
                hijobin(i2,:) = de2bi(h2, nbits);
            end

            y = hijobin;

        otherwise
            disp('Ese número no trunca')
    end

end
