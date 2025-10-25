function X_norm = standarize(X, n)
% Función para estandarizar una matriz X
% X: matriz de n datos por m features
% n: método de estandarización
%    1 -> (X - media) / desviación estándar
%    2 -> X / valor máximo

    switch n
        case 1
            % Normalización manual
            mu = mean(X);            % Media de cada columna
            sigma = std(X);          % Desviación estándar de cada columna
            Xtemp = bsxfun(@minus, X, mu);
            X_norm = bsxfun(@rdivide, Xtemp, sigma); % Normalizar nuevos datos

        case 2
            % Normalización dividiendo entre el máximo
            max_val = max(X);     % Máximo valor de toda la matriz
            X_norm = bsxfun(@rdivide, X, max_val);

        otherwise
            disp('Ese número no trunca');
            X_norm = X;  % Devuelve la original por si acaso
    end

end
