clear all;
close all;
clc;

data = xlsread('Consumo_E.xlsx', 'Hoja1', 'A2:C25');

X = [data(:, 1:2)] % Valores aleatorios
Y = [data(:, 3)] % Polinomio a identificar con la regresión
