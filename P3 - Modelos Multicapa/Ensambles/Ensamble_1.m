clear all; close all; clc;

load BaseSangre.txt;

data = BaseSangre;

%% Partición

load blood_cv.mat

X = data(:,1:4);
Y = data(:,5);

% Datos de entrenamiento.
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
% Datos de prueba.
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);

%% Escalamiento
maximo = max(Xtrain);
Xtrain = Xtrain./maximo;

%% Crear Modelo Neuronal
nn = 3;
% red = competlayer(nn); % Tipo de modelo
% red.trainParam.epochs=100;  % Configuración
Xtrain = Xtrain';
% red = train(red, Xtrain);
load blood_red.mat

%% Simulación
Wf = red.IW{1,1}';
Ygtrain = red(Xtrain);  % Y estimada
Ygtrain = vec2ind(Ygtrain);  % Convierte de vectores a índices
grupos = unique(Ygtrain);  % Devuelve valores únicos, quita repeticiones

%% Asignar los datos a cada grupo
Ytrain=Ytrain';

for k = 1:size(grupos,2)
    temp1 = Xtrain(:,Ygtrain == grupos(1,k));
    temp2 = Ytrain(:,Ygtrain == grupos(1,k));
    eval(sprintf('grupo%d=[temp1; temp2];', grupos(1,k)))
end

%% Modelo 1
data1 = grupo1;

X1 = data1(1:4,:);
Y1 = data1(5,:);

% Modelo
red1 = feedforwardnet([10 10 10]);  % Tipo de red
red1.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)
red1 = train(red1, X1, Y1);

% Simulación
Yg1 = round((red1(X1))');

% Corrección de etiquetas
Yg1(Yg1 > 1,:) = 1;
Yg1(Yg1 < 0,:) = 0;

% Métricas
A1 = confusionmat(Y1, Yg1);

figure(1)
confusionchart(A1, [0,1])

exa1 = sum(diag(A1)) / sum(A1(:));
pre1 = mean(diag(A1) ./ sum(A1, 2)); 
rec1 = mean(diag(A1) ./ sum(A1, 1)');

J1 = perform(red1, Y1, Yg1);

Scores = [J1 exa1, pre1, rec1];

%% Modelo 2
data2 = grupo2;

X2 = data2(1:4,:);
Y2 = data2(5,:);

% Modelo
red2 = feedforwardnet([10 10 10]);  % Tipo de red
red2.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)
red2 = train(red2, X2, Y2);

% Simulación
Yg2 = round((red2(X2))');

% Corrección de etiquetas
Yg2(Yg2 > 1,:) = 1;
Yg2(Yg2 < 0,:) = 0;

% Métricas
A2 = confusionmat(Y2, Yg2);

figure(2)
confusionchart(A2, [0,1])

exa2 = sum(diag(A2)) / sum(A2(:));
pre2 = mean(diag(A2) ./ sum(A2, 2)); 
rec2 = mean(diag(A2) ./ sum(A2, 1)');

J2 = perform(red2, Y2, Yg2);

Scores = [Scores; J2 exa2, pre2, rec2];

%% Modelo 3
data3 = grupo3;

X3 = data3(1:4,:);
Y3 = data3(5,:);

% Modelo
red3 = feedforwardnet([10 10 10]);  % Tipo de red
red3.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)
red3 = train(red3, X3, Y3);

% Simulación
Yg3 = round((red3(X3))');

% Corrección de etiquetas
Yg3(Yg3 > 1,:) = 1;
Yg3(Yg3 < 0,:) = 0;

% Métricas
A3 = confusionmat(Y3, Yg3);

figure(3)
confusionchart(A3, [0,1])

exa3 = sum(diag(A3)) / sum(A3(:));
pre3 = mean(diag(A3) ./ sum(A3, 2)); 
rec3 = mean(diag(A3) ./ sum(A3, 1)');

J3 = perform(red3, Y3, Yg3);

Scores = [Scores; J3 exa3, pre3, rec3]

%% Promedio
mean(Scores)
