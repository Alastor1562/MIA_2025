clear all;
close all;
clc;

%% Carga de datos
load BaseSangre.txt

data = BaseSangre;

% Recency (months),Frequency (times),Monetary (c.c. blood),Time (months),"whether he/she donated blood in March 2007"

%% Regresión Logística

X = data(:, 1:4);  % Variables de entrada

Y = data(:,5);  % salidas de 1s y 0s

%cv = cvpartition(Y,'holdout',0.2);

load cv_opt_Ejercicio_3.mat

% holdout: divide aleatoriamente las observaciones en un conjunto de datos
% de entrenamiento y prueba, usando la información de la clase del grupo.
% Datos de entrenamiento.
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));
% Datos de prueba.
Xtest = X(test(cv),:);
Ytest = Y(test(cv));

%% Escalamiento

media = mean(Xtrain);
desviacion = std(Xtrain);

Xtemp = bsxfun(@minus, Xtrain, media);
Xtrain = bsxfun(@rdivide, Xtemp, desviacion); % Entrenamiento ya estandarizado

% Xtrain = normalize(Xtrain);

%% Modelado

n = size(Xtrain,1);  % Cantidad de datos

grado = 3;

[Xa coef] = func_polinomio2(Xtrain,grado);  % La forma del modelo

% Inicialización de parámetros
W = zeros(size(Xa, 2), 1);  % Pesos iniciales

[J, dJdW] = func_costo(W, Xa, Ytrain);

options = optimset('GradObj', 'on', 'MaxIter', 1000);

[Wopt, Jopt] = fminunc(@(W)func_costo(W, Xa, Ytrain), W, options);

%% Simulación con valores óptimos

V = Xa * Wopt;

Yg = round(1./(1+exp(-V)));

% Matriz de Confusión

TP = sum((Ytrain==1) & (Yg==1));  % Verdaderos positivos
TN = sum((Ytrain==0) & (Yg==0));  % Verdaderos negativos
FP = sum((Ytrain==0) & (Yg==1));  % Falsos positivos
FN = sum((Ytrain==1) & (Yg==0));  % Falsos negativos

%%  Medidas de desempeño

exa = (TP+TN) / (TP+TN+FP+FN);  % Exactitud

pre = TP / (TP+FP);  % Precisión

rec = TP / (TP+FN);  % Recall

[exa, pre, rec]

decod_func_polinomio2(Xa, coef, Wopt)

%bar(Wopt)

%% Test Performance

Xtemp = bsxfun(@minus, Xtest, media); 
Xtest= bsxfun(@rdivide, Xtemp, desviacion);

Xatest = func_polinomio2(Xtest, grado);

Vtest = Xatest * Wopt;

Ygtest = round(1./(1+exp(-Vtest)));

% Matriz de Confusión

A = confusionmat(Ytest, Ygtest);

%confusionchart(A,[0 1])

TPtest = A(2,2);
TNtest = A(1,1);
FPtest = A(1,2);
FNtest = A(2,1);

exa_test = (TPtest+TNtest) / (TPtest+TNtest+FPtest+FNtest);  % Exactitud

pre_test = TPtest / (TPtest+FPtest);  % Precisión

rec_test = TPtest / (TPtest+FNtest);  % Recall

[exa_test, pre_test, rec_test]

%% Predicciones nuevas

Xpred = [3 2 1000 12;
        5 3 750 1;
        4 1 250 4;
        8 10 2000 36];

Xapred = func_polinomio2(Xpred,grado);
Vpred = Xapred*Wopt;
Ygpred = round(1./(1+exp(-Vpred)));

Predicciones = [Xpred Ygpred]