function fn = func_costo_competitivas(A,w)

    % Paso 1: restar cada peso a su respectiva fila
    diff = A - w; % resta elemento a elemento

    % Paso 2: calcular la suma de cuadrados por columna
    sum_sq = sum(diff.^2, 1); % suma a lo largo de las filas

    % Paso 3: raíz cuadrada de cada suma (norma columna)
    column_norms = sqrt(sum_sq);

    % Paso 4: suma total de todas las normas
    f = sum(column_norms);

    % Paso 5: cantidad de columnas
    n = size(A, 2);

    fn = f/n;

end