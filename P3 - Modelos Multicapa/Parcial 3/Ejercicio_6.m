clear all; close all; clc;

%% Load Data
load Data_6.mat

%% Partición
% Ys
clases = forest_training{:,1};  % string
Ytrain = zeros(size(clases));

Ytrain(clases == "d") = 1;
Ytrain(clases == "h") = 2;
Ytrain(clases == "s") = 3;
Ytrain(clases == "o") = 4;

clases = forest_testing{:,1};  % string
Ytest = zeros(size(clases));

Ytest(clases == "d") = 1;
Ytest(clases == "h") = 2;
Ytest(clases == "s") = 3;
Ytest(clases == "o") = 4;

% Xs
Xtrain = table2array(forest_training(:, 2:end));  % Features for training
Xtest = table2array(forest_testing(:, 2:end));    % Features for testing

%% Modelo
% red = feedforwardnet([10 10 10 10 10]);  % Tipo de red
% red.trainFcn = 'trainrp';
% red = train(red, Xtrain', Ytrain');
load red_6a.mat

%% Simulación
Ygtrain = (red(Xtrain'))';

Ygtrain(Ygtrain > 4,:) = 4;
Ygtrain(Ygtrain < 1,:) = 1; 

Ygtrain = round(Ygtrain);

%% Medidas de desempeño
A = confusionmat(Ytrain, Ygtrain);

figure(1)
confusionchart(A, [1,2,3,4])

exatrain = sum(diag(A)) / sum(A(:));
pretrain = mean(diag(A) ./ sum(A, 2)); 
rectrain = mean(diag(A) ./ sum(A, 1)');

Jtrain = perform(red, Ytrain, Ygtrain)

Train_metrics = [exatrain, pretrain, rectrain]

%% Test
Ygtest = (red(Xtest'))';

Ygtest(Ygtest > 4,:) = 4;
Ygtest(Ygtest < 1,:) = 1; 

Ygtest = round(Ygtest);

B = confusionmat(Ytest, Ygtest);

figure(2)
confusionchart(B, [1,2,3,4])

exatest = sum(diag(B)) / sum(B(:));
pretest = mean(diag(B) ./ sum(B, 2)); 
rectest = mean(diag(B) ./ sum(B, 1)');

Jtest = perform(red, Ytest, Ygtest);

Test_metrics = [exatest pretest rectest]