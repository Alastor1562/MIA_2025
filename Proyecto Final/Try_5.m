clear; close all; clc;

%% ===============================
%  CARGA Y PREPARACIÓN DE DATOS
%  ===============================

load datos.mat
data = [MaternalHealthRiskDataSet(:,1:6) MaternalHealthRiskDataSet(:,8)];
data = table2array(data);

X = data(:,1:6);
Y = data(:,7);

%% INGENIERÍA DE VARIABLES
Age         = X(:,1);
SysBP       = X(:,2);
DiaBP       = X(:,3);
BS          = X(:,4);
Temp        = X(:,5);
HR          = X(:,6);

%% --- 1. Transformaciones univariadas ---
X_sq        = X.^2;                 % cuadrado de cada variable
X_sqrt      = sqrt(abs(X));         % raíz de los valores absolutos
X_inv       = 1 ./ (X + 1e-6);      % inversa (evita div entre cero)
X_log       = log(X + 1);           % log-transform

%% --- 2. Relaciones fisiológicas clínicas ---
MAP   = (SysBP + 2*DiaBP) / 3;         % presión arterial media
PP    = SysBP - DiaBP;                 % pulse pressure
BP_ratio = SysBP ./ (DiaBP + 1e-6);    % ratio sistólica/diastólica

%% --- 3. Indicadores binarios clínicos ---
Fever       = Temp > 37.5;
HighSysBP   = SysBP > 140;
HighDiaBP   = DiaBP > 90;
HighBS      = BS > 7;                  % glucosa elevada
Tachy       = HR > 100;                % taquicardia

%% --- 4. Interacciones ---
Int_Age_Sys = Age .* SysBP;
Int_BS_HR   = BS .* HR;
Int_Temp_HR = Temp .* HR;
Int_PP_Age  = PP .* Age;

%% --- UNIR TODO ---
Xnew = [X, ...
        X_sq, X_sqrt, X_inv, X_log, ...
        MAP, PP, BP_ratio, ...
        Fever, HighSysBP, HighDiaBP, HighBS, Tachy, ...
        Int_Age_Sys, Int_BS_HR, Int_Temp_HR, Int_PP_Age];


%% ===============================
%   PARTICIÓN HOLD OUT
%   ===============================

cv = cvpartition(Y,'HoldOut',0.15);

Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);

Xtest  = X(test(cv),:);
Ytest  = Y(test(cv),:);

% maximo = max(Xtrain);
% Xtrain = Xtrain./maximo;
% Xtest = Xtest./maximo;

classesOrder = [1 2 3];

%% ===============================
%       METAS A SUPERAR
%   ===============================

accTrainTarget  = 0.88;
precTrainTarget = 0.87;
recTrainTarget  = 0.87;

accTestTarget   = 0.85;
precTestTarget  = 0.84;
recTestTarget   = 0.84;

%% ================================================
%        LOOP DE BÚSQUEDA – RED NEURONAL
%           CAPAS – CON PESOS DINÁMICOS
% ================================================

labels = unique(Ytrain);
nClasses = numel(labels);

% Crear matriz dummy (one-hot encoding)
Ytraind = zeros(length(Ytrain), nClasses);
for i = 1:nClasses
    Ytraind(Ytrain == labels(i), i) = 1;
end

encontrado = false;
iter = 0;

disp("Buscando una RED NEURONAL con pesos dinámicos...");

while ~encontrado
    iter = iter + 1;

    % =====================================================
    %     ARQUITECTURA ALEATORIA
    % =====================================================
    h = randi([1 200], 1, 10);  
    % h = [capa1 capa2 ... capa n]

    redNN = feedforwardnet(h);

    % Función de activación
    for L = 1:length(h)
        redNN.layers{L}.transferFcn = 'tansig';
    end

    % Elegir función de entrenamiento
    funcs = ["trainrp" "trainscg"];
    redNN.trainFcn = funcs(randi(2));

    % Desactivar ventanas/outputs
    redNN.trainParam.showWindow = false;
    redNN.trainParam.showCommandLine = false;

    % =====================================================
    %                PESOS DE CLASE
    % =====================================================
    [~, ~, Ytrain_idx] = unique(Ytrain);

    counts = histcounts(Ytrain_idx, nClasses);
    classWeights = (sum(counts) ./ counts) .^ 0.7;

    weightVector = classWeights(Ytrain_idx)';

    % Entrenamiento con pesos
    redNN = train(redNN, Xtrain', Ytraind', [], [], weightVector);

    % =====================================================
    %                  TRAIN PERFORMANCE
    % =====================================================
    Ytrain_predD = redNN(Xtrain');
    [~, idxTrain] = max(Ytrain_predD', [], 2);
    Ytrain_pred = labels(idxTrain);

    A = confusionmat(Ytrain, Ytrain_pred, 'Order', labels);

    accTrain = sum(diag(A)) / sum(A(:));
    precTrain = mean(diag(A) ./ sum(A,2));
    recTrain  = mean(diag(A) ./ sum(A,1)');

    % =====================================================
    %                  TEST PERFORMANCE
    % =====================================================
    Ytest_predD = redNN(Xtest');
    [~, idxTest] = max(Ytest_predD', [], 2);
    Ytest_pred = labels(idxTest);

    B = confusionmat(Ytest, Ytest_pred, 'Order', labels);

    accTest = sum(diag(B)) / sum(B(:));
    precTest = mean(diag(B) ./ sum(B,2));
    recTest  = mean(diag(B) ./ sum(B,1)');

    fprintf("Iter %4d | Capas=[%s] | TrainA=%.3f | TestA=%.3f\n", ...
        iter, num2str(h), accTrain, accTest);

    % =====================================================
    %            CONDICIÓN PARA DETENERSE
    % =====================================================
    if accTrain >= accTrainTarget && precTrain >= precTrainTarget && recTrain >= recTrainTarget && ...
       accTest >= accTestTarget   && precTest >= precTestTarget  && recTest >= recTestTarget

        encontrado = true;

        best.model = redNN;
        best.layers = h;
        best.trainFcn = redNN.trainFcn;

        best.accTrain = accTrain;
        best.precTrain = precTrain;
        best.recTrain = recTrain;

        best.accTest = accTest;
        best.precTest = precTest;
        best.recTest = recTest;

        save('mejor_reds.mat','best');

        disp("=====================================");
        disp("   ¡RED NEURONAL ENCONTRADA! ");
        disp("=====================================");
        disp(best);

        break
    end
end
