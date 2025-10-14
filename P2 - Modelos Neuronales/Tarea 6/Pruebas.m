clear all;
close all;
clc;
% Excel
data = xlsread('Regression Task.xlsx', 'Problem 2', 'A2:C301');
X1 = data(:,1);  
X2 = data(:,2);  
Y  = data(:,3);  
n  = size(data,1);
% Modelo ajustado:
% E(y) = b0 + b1*x1 + b2*x1^2 + b3*x2 + b4*(x1*x2) + b5*(x1^2*x2)
Xa = [ones(n,1), X1, X1.^2, X2, X1.*X2, X2.^2];
% Mínimos cuadrados
Wmc = inv(Xa' * Xa) * Xa' * Y;   % coeficientes
Yg  = Xa * Wmc;                 
E   = Y - Yg;                  
J   = (E' * E) / (2*n);         
% Resultados
disp('Coeficientes [b0 b1 b2 b3 b4 b5]:'); disp(Wmc');
disp('Costo J:'); disp(J);