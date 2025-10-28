function imprimir_coeficientes(w)
    % ------------------------------------------------------------
    % Imprime los coeficientes del vector w en formato:
    %   b0 = w(1)
    %   b1 = w(2)
    %   ...
    %
    % Entradas:
    %   w : vector de coeficientes (p x 1)
    %
    % Ejemplo:
    %   imprimir_coeficientes(w)
    % ------------------------------------------------------------

    % Verificar que w sea vector
    if ~isvector(w)
        error('La entrada w debe ser un vector.');
    end

    % Imprimir encabezado
    fprintf('\nCoeficientes del modelo de regresión:\n');

    % Iterar e imprimir cada coeficiente
    for i = 1:length(w)
        fprintf('b%d = %.6f\n', i-1, w(i));
    end

    fprintf('\n');
end
