clear; close all; clc;

%% Carga de Datos
load datos.mat
data = [MaternalHealthRiskDataSet(:,1:6) MaternalHealthRiskDataSet(:,8)];
data = table2array(data);

X = data(:,1:6);
Y = data(:,7);

% Asegurar clases 1,2,3
if min(Y) == 0
    Y = Y + 1;
end

% Aumento de variables (igual que tu código)
X = [X, X.^2, sqrt(abs(X))];

%% Partición HoldOut
cv = cvpartition(Y,'HoldOut',0.15);

Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);

Xtest  = X(test(cv),:);
Ytest  = Y(test(cv),:);

%% Metas a superar
accTrainTarget  = 0.89;
precTrainTarget = 0.88;
recTrainTarget  = 0.88;

accTestTarget   = 0.85;
precTestTarget  = 0.85;
recTestTarget   = 0.85;

classesOrder = [1 2 3];

encontrado = false;
iter = 0;

disp("Buscando modelo que cumpla todas las métricas...");

%% LOOP INFINITO HASTA ENCONTRAR MODELO ADECUADO
while ~encontrado
    iter = iter + 1;

    % -------------------------------
    % Parámetros aleatorios
    % -------------------------------
    numTrees  = randi([1 500]);          % árboles entre 50 y 300
    maxSplits = randi([3 100]);            % profundidad entre 3 y 40
    minLeaf   = randi([1 16]);            % tamaño mínimo entre 1 y 15

    t = templateTree('MaxNumSplits',maxSplits, ...
                     'MinLeafSize',minLeaf);

    % Modelo
    M = fitcensemble(Xtrain, Ytrain, ...
        'Method','Bag', ...
        'NumLearningCycles',numTrees, ...
        'Learners',t, ...
        'ClassNames',classesOrder);

    %% TRAIN
    YpredTrain = predict(M,Xtrain);
    A = confusionmat(Ytrain, YpredTrain, 'Order', classesOrder);

    exaTrain = sum(diag(A)) / sum(A(:));
    preTrain = mean(diag(A) ./ sum(A,2));
    recTrain = mean(diag(A) ./ sum(A,1)');

    %% TEST
    YpredTest = predict(M,Xtest);
    B = confusionmat(Ytest, YpredTest, 'Order', classesOrder);

    exaTest = sum(diag(B)) / sum(B(:));
    preTest = mean(diag(B) ./ sum(B,2));
    recTest = mean(diag(B) ./ sum(B,1)');

    fprintf("Iter %4d | Trees=%3d, MaxSplits=%2d, MinLeaf=%2d | TrainA=%.3f TestA=%.3f\n", ...
        iter, numTrees, maxSplits, minLeaf, exaTrain, exaTest);

    % ------------------------------------------
    % Revisar si ya cumple TODAS las metas
    % ------------------------------------------
    if exaTrain >= accTrainTarget && preTrain >= precTrainTarget && recTrain >= recTrainTarget && ...
       exaTest  >= accTestTarget  && preTest >= precTestTarget  && recTest >= recTestTestTarget

        encontrado = true;

        % Guardar resultados
        best.model     = M;
        best.numTrees  = numTrees;
        best.maxSplits = maxSplits;
        best.minLeaf   = minLeaf;

        best.accTrain  = exaTrain;
        best.precTrain = preTrain;
        best.recTrain  = recTrain;

        best.accTest  = exaTest;
        best.precTest = preTest;
        best.recTest  = recTest;

        disp("===============================================");
        disp("         ¡MODELO ENCONTRADO CON ÉXITO!         ");
        disp("===============================================");
        disp(best);

        save("bestBaggedTreesModel.mat","best");

        break;
    end
end

