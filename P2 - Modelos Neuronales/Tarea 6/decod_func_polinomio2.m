function y_hat = decod_func_polinomio2(Xa, coef, w)

fprintf('y_hat = ');
for k = 1:length(w)
    term = '';
    for j = 1:size(coef,2)
        if coef(k,j) > 0
            term = [term sprintf(' * x%d^%d', j, coef(k,j))];
        end
    end
    if isempty(term)
        term = '1'; % término constante
    else
        term = term(4:end); % quitar el primer " * "
    end
    fprintf('%+.3f*(%s) ', w(k), term);
end
fprintf('\n');