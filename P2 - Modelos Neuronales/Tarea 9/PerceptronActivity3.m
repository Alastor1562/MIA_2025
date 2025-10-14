%General cleaning
clear all;
close all;
clc;

%Data upload
load BaseSangre.txt
data=BaseSangre;


%% Logistic Regression
X=data(:,[1 2 3]); %Input variables
%Data scaling
media=mean(X);
desviacion=std(X)
Xtemp=bsxfun(@minus,X,mean(X));
X=bsxfun(@rdivide,Xtemp,std(X));

Y=data(:,5); %Output

cv = cvpartition(Y,'holdout',0.2);
% holdout: randomly divides observations into a training and 
% test data set, using the group class information.

% Training data.
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));
% Test data.
Xtest = X(test(cv),:);
Ytest = Y(test(cv));

grado=3;
Xa=func_polinomio(Xtrain,grado);

W=zeros(size(Xa,2),1);  %Initial weights

load modelobueno.mat


%% Simulate with the obtained model
V=Xa*Wopt;
Yg=1./(1+exp(-V));
Yg=round(Yg);  %Numeric output
%Yg=(Yg>=0.5);  %Boolean or logic output

%% Performance Measures
TP= sum((Ytrain==1)&(Yg==1)); %True Positive
TN= sum((Ytrain==0)&(Yg==0)); %True Negative
FP= sum((Ytrain==0)&(Yg==1)); %False Positive
FN= sum((Ytrain==1)&(Yg==0)); %False Negative

Accu=(TP+TN)/(TP+TN+FP+FN); %Accuracy
Pre=TP/(TP+FP);  %Precision
Rec=TP/(TP+FN);  %Recall

[Accu Pre Rec]

% Test Simulation
Xatest=func_polinomio(Xtest,grado);
Vtest=Xatest*Wopt;
Ygtest=1./(1+exp(-Vtest));
Ygtest=round(Ygtest);

TPtest= sum((Ytest==1)&(Ygtest==1)); %True Positive
TNtest= sum((Ytest==0)&(Ygtest==0)); %True Negative
FPtest= sum((Ytest==0)&(Ygtest==1)); %False Positive
FNtest= sum((Ytest==1)&(Ygtest==0)); %False Negative

Accutest=(TPtest+TNtest)/(TPtest+TNtest+FPtest+FNtest); %Accuracy
Pretest=TPtest/(TPtest+FPtest);  %Precision
Rectest=TPtest/(TPtest+FNtest);  %Recall

[Accu Pre Rec; Accutest Pretest Rectest]

M=confusionmat(Ytest,Ygtest);
confusionchart(M)


%Classify new data
ndatos=[3 2 1000; 5 3 750; 4 1 1250; 8 10 2000]

temp=bsxfun(@minus,ndatos,media);
datosest=bsxfun(@rdivide,temp,desviacion);
Xaclasificar=func_polinomio(datosest,grado);

Vclasificar=Xaclasificar*Wopt;
Ygclasificar=1./(1+exp(-Vclasificar));
Ygclasificar=round(Ygclasificar)