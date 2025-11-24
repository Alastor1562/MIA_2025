clear all; close all; clc;

%% Cargar datos
load dna.mat;

%% Separación de datos
X = dna(:, 2:end);  % Variables de entrada
Y = dna(:, 1);      % Etiquetas (pueden ser 0, 1, 2, ..., n)

%% Partición de entrenamiento y prueba
cv = cvpartition(Y, 'HoldOut', 0.2);
Xtrain = X(training(cv), :);
Ytrain = Y(training(cv), :);
Xtest = X(test(cv), :);
Ytest = Y(test(cv), :);

%% Determinar número de clases
labels = unique(Ytrain);
n = numel(labels);

%% Crear matriz dummy automáticamente
Ytraind = zeros(length(Ytrain), n);
for i = 1:n
    Ytraind(Ytrain == labels(i), i) = 1;
end

%% Definir y entrenar la red neuronal
red = feedforwardnet([10 10 10]);
red.trainFcn = 'trainrp';  % trainrp / trainscg
red = train(red, Xtrain', Ytraind');

%% Simulación
Ygtraind = round((red(Xtrain'))');
Ygtraind(Ygtraind > 1) = 1;
Ygtraind(Ygtraind < 0) = 0;

%% Cálculo automático de métricas por clase
exactitud = zeros(n,1);
precision = zeros(n,1);
recall = zeros(n,1);

for i = 1:n
    Ai = confusionmat(Ytraind(:, i), Ygtraind(:, i));
    
    figure(i)
    confusionchart(Ai, [0 1])
    title(['Matriz de confusión clase ', num2str(labels(i))])
    
    exactitud(i) = sum(diag(Ai)) / sum(Ai(:));
    precision(i) = Ai(2,2) / sum(Ai(2,:));
    recall(i) = Ai(2,2) / sum(Ai(:,2));
end

%% Promedios generales
exatrain = mean(exactitud, 'omitnan');
pretrain = mean(precision, 'omitnan');
rectrain = mean(recall, 'omitnan');

%% Función de desempeño
J = perform(red, Ytraind', Ygtraind');

%% Resultados finales
disp('=== MÉTRICAS GENERALES ===')
fprintf('J = %.4f\n', J);
fprintf('Exactitud promedio = %.4f\n', exatrain);
fprintf('Precisión promedio = %.4f\n', pretrain);
fprintf('Recall promedio = %.4f\n', rectrain);
