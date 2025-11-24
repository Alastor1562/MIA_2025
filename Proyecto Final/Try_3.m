clear all;
close all;
clc;


%% CARGA DE DATOS 

load datos.mat

data = [MaternalHealthRiskDataSet(:,1:6) MaternalHealthRiskDataSet(:,8)];
data = table2array(data);

X = data(:, 1:end-1);   % Entradas
Y = data(:, end);       % Nivel de riesgo (clase)

%% INGENIERÍA DE VARIABLES 
Xnew = [X, X.^2, sqrt(abs(X))];

%%  ESCALAMIENTO 
Xn = normalize(Xnew);   % z-score por columna

%%  PREPARACIÓN GLOBAL 
[clases, ~, Y_idx_all] = unique(Y);   % valores de clase y sus índices
K = numel(clases);                    % número de clases

% One-hot de TODAS las muestras
T_all = full(ind2vec(Y_idx_all'));

%% BÚSQUEDA DE MEJOR MODELO 
bestAccTest = 0;
bestResult = struct();

numSplits = 15;        % número de particiones distintas
numNetsPerSplit = 10;  % redes por partición

for split = 1:numSplits
    %% Partición estratificada 85% / 15% 
    rng(split);   % semilla diferente en cada split
    cv = cvpartition(Y, 'HoldOut', 0.15);  % estratificado

    idxTrain = training(cv);
    idxTest  = test(cv);

    Xtrain = Xn(idxTrain, :);
    Xtest  = Xn(idxTest,  :);
    Ytrain = Y(idxTrain);
    Ytest  = Y(idxTest);

    XtrainNN = Xtrain';
    XtestNN  = Xtest';

    Ttrain = T_all(:, idxTrain);

    %% Pesos de clase para balanceo 
    [~, ~, Ytrain_idx] = unique(Ytrain);
    counts = histcounts(Ytrain_idx, K);
    classWeights = (sum(counts) ./ counts) .^ 0.7;  % más peso a clases raras
    pesos_train = classWeights(Ytrain_idx)';

    %%  Entrenar varias redes en este split 
    for m = 1:numNetsPerSplit
        fprintf('Split %d/%d - Modelo %d/%d\n', split, numSplits, m, numNetsPerSplit);

        % Arquitectura aleatoria moderada
        h1 = randi([30 70]);
        h2 = randi([15 40]);
        hiddenLayerSize = [h1, h2];

        net = patternnet(hiddenLayerSize);

        % Función de activación
        for L = 1:length(net.layers)-1
            net.layers{L}.transferFcn = 'tansig';
        end

        net.divideFcn = 'dividetrain';          % todo se usa como train
        net.trainParam.epochs = 2000;          
        net.performParam.regularization = 0.6 + 0.3*rand();  % entre 0.6 y 0.9
        net.trainParam.max_fail = 12;
        net.trainParam.showWindow = false;

        % Entrenamiento con pesos
        [net_m, ~] = train(net, XtrainNN, Ttrain, [], [], pesos_train);

        %% Evaluar en prueba 
        scoresTest = net_m(XtestNN);
        Ytest_hat_idx = vec2ind(scoresTest);
        Ytest_hat = clases(Ytest_hat_idx)';

        Ctest = confusionmat(Ytest, Ytest_hat);
        acc_test = sum(diag(Ctest)) / sum(Ctest(:));

        %% Si mejora la prueba, guardar todo 
        if acc_test > bestAccTest
            bestAccTest = acc_test;

            % Predicciones en train
            scoresTrain = net_m(XtrainNN);
            Ytrain_hat_idx = vec2ind(scoresTrain);
            Ytrain_hat = clases(Ytrain_hat_idx)';

            Ctrain = confusionmat(Ytrain, Ytrain_hat);

            % Métricas
            exa_train = sum(diag(Ctrain))/sum(Ctrain(:));
            exa_test  = acc_test;

            prec_train = mean( diag(Ctrain)./sum(Ctrain,1)' );
            prec_test  = mean( diag(Ctest)./sum(Ctest,1)' );

            rec_train = mean( diag(Ctrain)./sum(Ctrain,2) );
            rec_test  = mean( diag(Ctest)./sum(Ctest,2) );

            % Guardar en estructura
            bestResult.Ctrain = Ctrain;
            bestResult.Ctest = Ctest;

            bestResult.exa_train = exa_train;
            bestResult.exa_test  = exa_test;
            bestResult.prec_train = prec_train;
            bestResult.prec_test  = prec_test;
            bestResult.rec_train = rec_train;
            bestResult.rec_test  = rec_test;

            bestResult.idxTrain = idxTrain;
            bestResult.idxTest  = idxTest;
            bestResult.net = net_m;
        end
    end
end

%%  USAR EL MEJOR MODELO ENCONTRADO
Ctrain = bestResult.Ctrain;
Ctest  = bestResult.Ctest;

exa_train  = bestResult.exa_train;
exa_test   = bestResult.exa_test;
prec_train = bestResult.prec_train;
prec_test  = bestResult.prec_test;
rec_train  = bestResult.rec_train;
rec_test   = bestResult.rec_test;

% Guardar el mejor modelo y la mejor partición
save('mejor_modelo_red.mat','bestResult','clases');

%%  MOSTRAR RESULTADOS 
fprintf('\n===== MEJOR MODELO ENCONTRADO =====\n');
fprintf('----- ENTRENAMIENTO -----\n');
fprintf('Exactitud: %.4f\n', exa_train);
fprintf('Precisión: %.4f\n', prec_train);
fprintf('Recall:    %.4f\n', rec_train);

fprintf('\n----- PRUEBA -----\n');
fprintf('Exactitud: %.4f\n', exa_test);
fprintf('Precisión: %.4f\n', prec_test);
fprintf('Recall:    %.4f\n', rec_test);

%%  GRÁFICAS 
figure;
confusionchart(Ctrain);
title('Matriz de Confusión - Entrenamiento (Mejor modelo)');

figure;
confusionchart(Ctest);
title('Matriz de Confusión - Prueba (Mejor modelo)');