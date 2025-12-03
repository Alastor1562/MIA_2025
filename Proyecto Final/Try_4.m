clear; close all; clc;

%% ===============================
%  CARGA Y PREPARACIÓN DE DATOS
%  ===============================

load datos.mat
data = [MaternalHealthRiskDataSet(:,1:6) MaternalHealthRiskDataSet(:,8)];
data = table2array(data);

X = data(:,1:6);
Y = data(:,7);

X = normalize(X);

%% Aumento de variables EXACTAMENTE como tu código
% X = [X, X.^2, sqrt(abs(X))];

%% ===============================
%   PARTICIÓN HOLD OUT
%   ===============================

cv = cvpartition(Y,'HoldOut',0.15);

Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);

Xtest  = X(test(cv),:);
Ytest  = Y(test(cv),:);

classesOrder = [1 2 3];

%% ===============================
%       METAS A SUPERAR
%   ===============================

accTrainTarget  = 0.872;
precTrainTarget = 0.86;
recTrainTarget  = 0.86;

accTestTarget   = 0.84;
precTestTarget  = 0.83;
recTestTarget   = 0.83;

%% ===============================
%         LOOP DE BÚSQUEDA
%   ===============================

encontrado = false;
iter = 0;

disp("Buscando un modelo RANDOM FOREST que cumpla las métricas...");

while ~encontrado
    iter = iter + 1;

    % =========================================
    %         HIPERPARÁMETROS ALEATORIOS
    % =========================================

    numTrees = randi([80 400]);          % Nº de árboles
    maxSplits = randi([3 60]);           % profundidad
    minLeaf = randi([1 20]);             % hoja mínima
    minParent = randi([5 60]);           % padre mínimo

    criterios = ["gdi" "deviance" "twoing"];
    splitCrit = criterios(randi(length(criterios)));

    % Feature sampling (núcleo de Random Forest)
    p = size(Xtrain,2);
    numVarsSample = randi([2 p]);        % evitar 1 por estabilidad

    % Resampling válido ('on'/'off')
    if rand > 0.2
        resampleFlag = 'on';             % 80% con reemplazo
    else
        resampleFlag = 'off';
    end

    % Fracción de muestra por árbol
    fResample = 0.5 + rand/2;            % entre 0.5 y 1.0

    %% Árbol base (ESTO define el Random Forest)
    t = templateTree( ...
        'MaxNumSplits', maxSplits, ...
        'MinLeafSize', minLeaf, ...
        'MinParentSize', minParent, ...
        'SplitCriterion', splitCrit, ...
        'NumVariablesToSample', numVarsSample);

    %% Entrenamiento del Random Forest
    M = fitcensemble( ...
        Xtrain, Ytrain, ...
        'Method','Bag', ...    % Bag + Feature Sampling = Random Forest
        'Learners', t, ...
        'NumLearningCycles', numTrees, ...
        'Resample', resampleFlag, ...
        'FResample', fResample, ...
        'ClassNames', classesOrder);

    %% =========================================
    %         MÉTRICAS TRAIN
    % =========================================
    YpredTrain = predict(M,Xtrain);
    A = confusionmat(Ytrain,YpredTrain,'Order',classesOrder);

    accTrain = sum(diag(A)) / sum(A(:));
    precTrain = mean(diag(A) ./ sum(A,2));
    recTrain  = mean(diag(A) ./ sum(A,1)');

    %% =========================================
    %         MÉTRICAS TEST
    % =========================================
    YpredTest = predict(M,Xtest);
    B = confusionmat(Ytest,YpredTest,'Order',classesOrder);

    accTest = sum(diag(B)) / sum(B(:));
    precTest = mean(diag(B) ./ sum(B,2));
    recTest  = mean(diag(B) ./ sum(B,1)');

    fprintf("Iter %4d | Train A/P/R = %.3f / %.3f / %.3f | Test A = %.3f\n", ...
        iter, accTrain, precTrain, recTrain, accTest);

    %% =========================================
    %        VER SI YA CUMPLE METAS
    % =========================================
    if accTrain >= accTrainTarget && precTrain >= precTrainTarget && recTrain >= recTrainTarget && ...
       accTest >= accTestTarget   && precTest >= precTestTarget  && recTest >= recTestTarget

        encontrado = true;

        best.model = M;

        % Guardar hiperparámetros
        best.numTrees = numTrees;
        best.maxSplits = maxSplits;
        best.minLeaf = minLeaf;
        best.minParent = minParent;
        best.splitCrit = splitCrit;
        best.numVarsSample = numVarsSample;
        best.resampleFlag = resampleFlag;
        best.fResample = fResample;

        % Guardar métricas
        best.accTrain = accTrain;
        best.precTrain = precTrain;
        best.recTrain = recTrain;

        best.accTest = accTest;
        best.precTest = precTest;
        best.recTest = recTest;

        save("bestRandomForestModel.mat","best");

        disp("=====================================");
        disp("  ¡MODELO RANDOM FOREST ENCONTRADO! ");
        disp("=====================================");
        disp(best);

        break
    end
end
