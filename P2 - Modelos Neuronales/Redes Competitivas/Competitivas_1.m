clear all; close all; clc;

%% Carga de datos

load datos1.mat

data = datos1; % Renombrado

plot(data(1,:), data(2,:), '.')

nn = 4; % Numero de neuronas

eta = 0.01;  % Constante de actualización

% W = zeros(size(data,1),nn);  % Pesos iniciales

prom = mean(data,2);
W = prom .* ones(size(data,1),nn);

W0 = W;  % Guardar pesos iniciales

%% Competencia

for nepoc=1:35
    for k=1:size(data,2)  % Para cada dato
        for j=1:nn  % Para cada 
    
            dist(1,j) = sum((data(:,k) - W(:,j)).^2);
    
        end
    
        [val, ind] = min(dist);  % Función de activación (Ley de actualización por distancia mínima)
    
        W(:,ind) = W(:,ind) + eta*(data(:,k) - W(:,ind));
    
    end
end

Wf = W;  % Pesos finales

figure(2)
plot(data(1,:), data(2,:),'b.', ...
    W0(1,:), W0(2,:), 'r+', ...
    Wf(1,:), Wf(2,:), 'gp')