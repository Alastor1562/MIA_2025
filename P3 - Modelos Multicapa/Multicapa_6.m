clear all; close all; clc;

%% Load data

load dna.mat;

%% Separación de datos
X = dna(:, 2:end);  % Variables de entrada

Y = dna(:,1);  % salidas de 1s y 0s

%% Partición
cv = cvpartition(Y, 'HoldOut', 0.2);
Xtrain = X(training(cv), :);
Ytrain = Y(training(cv), :);

Xtest = X(test(cv), :);
Ytest = Y(test(cv), :);

%% Modelo
red = feedforwardnet([10 10 10]);  % Tipo de red
% Configurar red
red.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)

% Entrenamiento
red = train(red, Xtrain', Ytrain');

%% Simulación
Ygtrain = (red(Xtrain'))';

Ygtrain(Ygtrain > 2,:) = 2;   % Cambia todos los valores mayores a 2 por 2
Ygtrain(Ygtrain < 0,:) = 0; 

Ygtrain = round(Ygtrain);

%% Medidas de desempeño

A = confusionmat(Ytrain, Ygtrain);

% confusionchart(A, [0,1,2])

exatrain = sum(diag(A)) / sum(A(:));
pretrain = mean(diag(A) ./ sum(A, 2)); 
rectrain = mean(diag(A) ./ sum(A, 1)');

Jtrain = perform(red, Ytrain, Ygtrain);

[Jtrain exatrain, pretrain, rectrain]

%% Test
Ygtest = (red(Xtest'))';

Ygtest(Ygtest > 2,:) = 2;   % Cambia todos los valores mayores a 2 por 2
Ygtest(Ygtest < 0,:) = 0; 

Ygtest = round(Ygtest);

B = confusionmat(Ytest, Ygtest);

% -confusionchart(B, [0,1,2])

exatest = sum(diag(B)) / sum(B(:));
pretest = mean(diag(B) ./ sum(B, 2)); 
rectest = mean(diag(B) ./ sum(B, 1)');

Jtest = perform(red, Ytest, Ygtest);

[Jtest exatest pretest rectest]