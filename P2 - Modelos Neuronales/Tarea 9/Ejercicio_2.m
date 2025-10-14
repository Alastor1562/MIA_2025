clear all;
close all;
clc;

%% Carga de datos
load simplecluster_dataset.mat

%% Sección a Borrar (Visualización)
data = simpleclusterInputs;

data(3,:) = simpleclusterTargets(1,:);

data = data';

% Separación de datos
G0 = data(data(:,3)==0,1:2); % Grupo 0

G1 = data(data(:,3)==1,1:2); % Grupo 1

%% Regresión Logística

X = data(:, 1:2);  % Variables de entrada

Y = data(:,3);  % salidas de 1s y 0s

n = size(X,1);  % Cantidad de datos

grado = 3;

[Xa coef] = func_polinomio2(X,grado);  % La forma del modelo

% Inicialización de parámetros
W = zeros(size(Xa, 2), 1);  % Pesos iniciales

[J, dJdW] = func_costo(W, Xa, Y);

options = optimset('GradObj', 'on', 'MaxIter', 1000);

[Wopt, Jopt] = fminunc(@(W)func_costo(W, Xa, Y), W, options);

%% Simulación con valores óptimos

V = Xa * Wopt;

Yg = round(1./(1+exp(-V)));

% Matriz de Confusión

TP = sum((Y==1) & (Yg==1));  % Verdaderos positivos
TN = sum((Y==0) & (Yg==0));  % Verdaderos negativos
FP = sum((Y==0) & (Yg==1));  % Falsos positivos
FN = sum((Y==1) & (Yg==0));  % Falsos negativos

confusionMatrix = confusionmat(Y, Yg);

%%  Medidas de desempeño

exa = (TP+TN) / (TP+TN+FP+FN);  % Exactitud

pre = TP / (TP+FP);  % Precisión

rec = TP / (TP+FN);  % Recall

[exa, pre, rec]

%% Sección a borrar (Visualización)

x1=-1:0.1:1.5;

x2=-1:0.1:1.5;

[x1,x2] = meshgrid(x1,x2);

[m,n] = size(x1);

x1temp = reshape(x1,m*n,1);
x2temp = reshape(x2,m*n,1);

Xtemp = [x1temp, x2temp];
Xatemp = func_polinomio2(Xtemp,grado);

Vtemp = Xatemp * Wopt;
Vtemp = reshape(Vtemp, m, n);

plot(G0(:,1), G0(:,2), 'bo', G1(:,1), G1(:,2), 'rx')
hold on
contour(x1,x2,Vtemp,[0,0],'LineWidth',2);
hold off

decod_func_polinomio2(Xa, coef, Wopt)

%% Dispersión de pesos

figure(2)
bar(Wopt)