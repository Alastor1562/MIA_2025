clear all; close all; clc;

T = readtable('gato.xlsx');
dataTable = T;

% X = jugadas (9 columnas), Y = resultado (columna 10)
X = dataTable(:, 1:9);
Y = dataTable(:, 10);

% Convertir las jugadas a números: x=1, o=-1, b=0
X = table2array(varfun(@(x) double(strcmp(x,'x')) - double(strcmp(x,'o')), X));

% Convertir la salida: "positive" = 1 (ganadora), "negative" = 0
Y = strcmp(table2array(Y), 'positive');
Y = double(Y(:));

%% Train-Test

cv = cvpartition(Y,'holdout',0.1);

% Datos de entrenamiento.
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));

% Datos de prueba.
Xtest = X(test(cv),:);
Ytest = Y(test(cv));

%% Escalamiento

Xtrain = normalize(Xtrain);
Xtest = normalize(Xtest);

%% Modelado

n = size(Xtrain,1);  % Cantidad de datos

grado = 3;

[Xa coef] = func_polinomio2(Xtrain,grado);  % La forma del modelo

% Inicialización de parámetros
W = zeros(size(Xa, 2), 1);  % Pesos iniciales

[J, dJdW] = func_costo(W, Xa, Ytrain);

options = optimset('GradObj', 'on', 'MaxIter', 1000);

[Wopt, Jopt] = fminunc(@(W)func_costo(W, Xa, Ytrain), W, options);

%% Train Performance

Vtrain = Xa * Wopt;

Ygtrain = round(1./(1+exp(-Vtrain)));

% Matriz de Confusión

A_train = confusionmat(Ytrain, Ygtrain);
figure(1)
confusionchart(A_train,[0 1])

%confusionchart(A,[0 1])

TPtrain = A_train(2,2);
TNtrain = A_train(1,1);
FPtrain = A_train(1,2);
FNtrain = A_train(2,1);

exa_train = (TPtrain+TNtrain) / (TPtrain+TNtrain+FPtrain+FNtrain);  % Exactitud

pre_train = TPtrain / (TPtrain+FPtrain);  % Precisión

rec_train = TPtrain / (TPtrain+FNtrain);  % Recall

fprintf('\n--- ENTRENAMIENTO ---\n');
fprintf('Exactitud: %.2f\nPrecisión: %.2f\nRecall: %.2f\n', exa_train, pre_train, rec_train);

%% Test Performance

Xatest = func_polinomio2(Xtest, grado);

Vtest = Xatest * Wopt;

Ygtest = round(1./(1+exp(-Vtest)));

% Matriz de Confusión

A_test = confusionmat(Ytest, Ygtest);
figure(2)
confusionchart(A_test,[0 1])

%confusionchart(A,[0 1])

TPtest = A_test(2,2);
TNtest = A_test(1,1);
FPtest = A_test(1,2);
FNtest = A_test(2,1);

exa_test = (TPtest+TNtest) / (TPtest+TNtest+FPtest+FNtest);  % Exactitud

pre_test = TPtest / (TPtest+FPtest);  % Precisión

rec_test = TPtest / (TPtest+FNtest);  % Recall

fprintf('\n--- TEST ---\n');
fprintf('Exactitud: %.2f\nPrecisión: %.2f\nRecall: %.2f\n', exa_test, pre_test, rec_test);

%% Predicciones nuevas

Xpred = [
    0  1  1  0  1  0 -1 -1 -1;
    0  1 -1  1  1  0  1  0 -1;
    1  0  1  0  1  0 -1  1  0;
    0  1  0  1  0  1  1  0  1;
    1  0  1  0  1  0  0  1  1
];

Xpred = normalize(Xpred);
Xapred = func_polinomio2(Xpred, grado);
Vpred = Xapred * Wopt;
Ygpred = round(1./(1+exp(-Vpred)));

disp('--- PREDICCIONES NUEVAS ---');
disp('1 = Ganadora, 0 = No ganadora');
disp(Ygpred);