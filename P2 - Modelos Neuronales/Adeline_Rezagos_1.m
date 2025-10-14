clear all;
close all;
clc;

load CMGdata.mat

precios = CMGdata.AdjClose;

nrez = 3; % Número de rezagos

X = [];

for k = 0:nrez
    X = [X, precios(nrez + 1 - k: end - k)];
end

Y = X(:,1); % La salida, datos más actuales

%% datos de entrenamiento (Partición)

ntrain = round(0.6*size(X,1));

Xa = [ones(size(X,1),1), X(:,2:end)]; % La forma del modelo

Xatrain = Xa(1:ntrain, :);
Ytrain = Y(1:ntrain, :);

Xatest = Xa(ntrain + 1:end, :);
Ytest = Y(ntrain + 1:end, :);

Wmc = inv(Xatrain' * Xatrain) * Xatrain' * Ytrain;

Yg = Xa * Wmc;

%% Talacha para Yg

Yg_rec = Xatrain * Wmc;
    
Xtemp = Xatrain(end,:);

for k=ntrain+1:size(Xa,1)
    Xtemp = [1 Yg_rec(k-1,1) Xtemp(:,2:end - 1)];

    Yg_rec(k,1) = Xtemp * Wmc;
end

plot([1:size(Y,1)]', Y, 'b-', ...
    [1:size(Yg,1)]', Yg, 'r-', ...
    [1:size(Yg_rec,1)]', Yg_rec, 'g-')