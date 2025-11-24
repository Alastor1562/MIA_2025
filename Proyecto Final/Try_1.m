clear all; close all; clc;

rng(1234)

%% Carga de Datos
load datos.mat

data = [MaternalHealthRiskDataSet(:,1:6) MaternalHealthRiskDataSet(:,8)];

data = table2array(data);

%% Partición
X = data(:,1:6);
Y = data(:,7);

cv = cvpartition(Y, 'HoldOut', 0.15);

% Datos de entrenamiento.
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
% Datos de prueba.
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);

%% Escalamiento
maximo = max(Xtrain);
Xtrain = Xtrain./maximo;

%% Experimento: #neuronas vs costo

% lista_nn = 2:5;
% costos  = zeros(size(lista_nn));
% 
% for i = 1:numel(lista_nn)
%     nn = lista_nn(i);
% 
%     % Crear y entrenar red competitiva
%     red = competlayer(nn);
%     red.trainParam.epochs = 100;
%     red = train(red, Xtrain);
% 
%     % Pesos finales y asignaciones
%     Wf = red.IW{1,1}.';          % d x nn
%     Y  = vec2ind(red(Xtrain));        % 1 x N (índice de neurona ganadora por muestra)
% 
%     % Construir matriz de pesos asignados por muestra (d x N)
%     W_asignado = Wf(:, Y);
% 
%     % Costo (promedio de normas columna a columna)
%     costos(i) = funcs.func_costo_competitivas(Xtrain, W_asignado);
%     fprintf('nn=%d  ->  costo=%.6f\n', nn, costos(i));
% end
% 
% % Gráfica costo vs #neuronas
% figure; 
% plot(lista_nn, costos, '-o','LineWidth',1.5);
% xlabel('Número de neuronas'); 
% ylabel('Costo competitivo promedio');
% title('Costo vs número de neuronas'); 
% grid on;

%% Crear Modelo Neuronal
nn = 3;
red = competlayer(nn); % Tipo de modelo
red.trainParam.epochs=100;  % Configuración
Xtrain = Xtrain';
red = train(red, Xtrain);

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

X1 = data1(1:6,:);
Y1 = data1(7,:);

% Modelo
red1 = feedforwardnet([10 10 10]);  % Tipo de red
red1.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)
red1 = train(red1, X1, Y1);

% Simulación
Yg1 = round((red1(X1))');

% Corrección de etiquetas
Yg1(Yg1 > 3,:) = 3;
Yg1(Yg1 < 1,:) = 1;

% Métricas
A1 = confusionmat(Y1, Yg1);

figure(1)
confusionchart(A1, [1,2,3])

exa1 = sum(diag(A1)) / sum(A1(:));
pre1 = mean(diag(A1) ./ sum(A1, 2)); 
rec1 = mean(diag(A1) ./ sum(A1, 1)');

J1 = perform(red1, Y1, Yg1);

Scores = [J1 exa1, pre1, rec1];

%% Modelo 2
data2 = grupo2;

X2 = data2(1:6,:);
Y2 = data2(7,:);

% Modelo
red2 = feedforwardnet([10 10 10]);  % Tipo de red
red2.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)
red2 = train(red2, X2, Y2);

% Simulación
Yg2 = round((red2(X2))');

% Corrección de etiquetas
Yg2(Yg2 > 3,:) = 3;
Yg2(Yg2 < 1,:) = 1;

% Métricas
A2 = confusionmat(Y2, Yg2);

figure(2)
confusionchart(A2, [1,2,3])

exa2 = sum(diag(A2)) / sum(A2(:));
pre2 = mean(diag(A2) ./ sum(A2, 2)); 
rec2 = mean(diag(A2) ./ sum(A2, 1)');

J2 = perform(red2, Y2, Yg2);

Scores = [Scores; J2 exa2, pre2, rec2];

%% Modelo 3
data3 = grupo3;

X3 = data3(1:6,:);
Y3 = data3(7,:);

% Modelo
red3 = feedforwardnet([10 10 10]);  % Tipo de red
red3.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)
red3 = train(red3, X3, Y3);

% Simulación
Yg3 = round((red3(X3))');

% Corrección de etiquetas
Yg3(Yg3 > 3,:) = 3;
Yg3(Yg3 < 1,:) = 1;

% Métricas
A3 = confusionmat(Y3, Yg3);

figure(3)
confusionchart(A3, [1,2,3])

exa3 = sum(diag(A3)) / sum(A3(:));
pre3 = mean(diag(A3) ./ sum(A3, 2)); 
rec3 = mean(diag(A3) ./ sum(A3, 1)');

J3 = perform(red3, Y3, Yg3);

Scores = [Scores; J3 exa3, pre3, rec3]

%% Promedio
mean(Scores)

%% Test
Xtest = Xtest';
Ygtest = red(Xtest);  % Y estimada
Ygtest = vec2ind(Ygtest);  % Convierte de vectores a índices
grupos = unique(Ygtest);  % Devuelve valores únicos, quita repeticiones

%% Asignar los datos a cada grupo
Ytest=Ytest';

for k = 1:size(grupos,2)
    temp1 = Xtest(:,Ygtest == grupos(1,k));
    temp2 = Ytest(:,Ygtest == grupos(1,k));
    eval(sprintf('test%d=[temp1; temp2];', grupos(1,k)))
end

%% Modelo 1
X1 = test1(1:6,:);
Y1 = test1(7,:);

% Simulación
Yg1 = round((red1(X1))');

% Corrección de etiquetas
Yg1(Yg1 > 3,:) = 3;
Yg1(Yg1 < 1,:) = 1;

% Métricas
A1 = confusionmat(Y1, Yg1);

figure(4)
confusionchart(A1, [1,2,3])

exa1 = sum(diag(A1)) / sum(A1(:));
pre1 = mean(diag(A1) ./ sum(A1, 2)); 
rec1 = mean(diag(A1) ./ sum(A1, 1)');

J1 = perform(red1, Y1, Yg1);

Scorest = [J1 exa1, pre1, rec1];

%% Modelo 2
X2 = test2(1:6,:);
Y2 = test2(7,:);

% Simulación
Yg2 = round((red2(X2))');

% Corrección de etiquetas
Yg2(Yg2 > 3,:) = 3;
Yg2(Yg2 < 1,:) = 1;

% Métricas
A2 = confusionmat(Y2, Yg2);

figure(5)
confusionchart(A2, [1,2,3])

exa2 = sum(diag(A2)) / sum(A2(:));
pre2 = mean(diag(A2) ./ sum(A2, 2)); 
rec2 = mean(diag(A2) ./ sum(A2, 1)');

J2 = perform(red2, Y2, Yg2);

Scorest = [J2 exa2, pre2, rec2]

%% Modelo 3
X3 = test3(1:6,:);
Y3 = test3(7,:);

% Simulación
Yg3 = round((red3(X3))');

% Corrección de etiquetas
Yg3(Yg3 > 3,:) = 3;
Yg3(Yg3 < 1,:) = 1;

% Métricas
A3 = confusionmat(Y3, Yg3);

figure(6)
confusionchart(A3, [1,2,3])

exa3 = sum(diag(A3)) / sum(A3(:));
pre3 = mean(diag(A3) ./ sum(A3, 2)); 
rec3 = mean(diag(A3) ./ sum(A3, 1)');

J3 = perform(red3, Y3, Yg3);

Scorest = [Scorest; J3 exa3, pre3, rec3]

mean(Scorest)