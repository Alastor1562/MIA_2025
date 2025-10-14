%General cleaning
clear all;
close all;
clc;

%Data upload
load data2.txt
data=data2;

%% The section can be deleted
G0=data(data(:,3)==0,1:2); %Group Zero
G1=data(data(:,3)==1,1:2); %Group One

plot(G0(:,1),G0(:,2),'bo',G1(:,1),G1(:,2),'rx')

%% Logistic Regression
X=data(:,1:2);  %Input Variables 
Y=data(:,3); %Output

m=size(X,1); %Amount of data

%Xa=[ones(m,1) X]; %Model grade 1
%Xa=[ones(m,1) X.^2]; %Model grade 2 (not all combinations)
grado=2;
Xa=func_polinomio(X,grado);

W=zeros(size(Xa,2),1);  %Initial weights

[J,dJdW]=fun_costo(W,Xa,Y);

options=optimset('GradObj','on','MaxIter',1000); %Options configuration

[Wopt,Jopt]=fminunc(@(W)fun_costo(W,Xa,Y),W,options);  %Optimum weights


%% Simulate with the obtained model
V=Xa*Wopt;
Yg=1./(1+exp(-V));
Yg=round(Yg);  %Numeric output
%Yg=(Yg>=0.5);  %Boolean or logic output

%% Performance Measures
TP= sum((Y==1)&(Yg==1)); %True Positive
TN= sum((Y==0)&(Yg==0)); %True Negative
FP= sum((Y==0)&(Yg==1)); %False Positive
FN= sum((Y==1)&(Yg==0)); %False Negative

Accu=(TP+TN)/(TP+TN+FP+FN); %Accuracy
Pre=TP/(TP+FP);  %Precision
Rec=TP/(TP+FN);  %Recall

[Accu Pre Rec]

%%Border drawing can be deleted

x1=-1:0.1:1.5;
x2=-1:0.1:1.5;

[x1,x2]=meshgrid(x1,x2); %All combinations between x1 and x2
[m,n]=size(x1);

x1temp=reshape(x1,m*n,1); % Rearrange the matrices
x2temp=reshape(x2,m*n,1);

Xtemp=[x1temp x2temp];
Xatemp=func_polinomio(Xtemp,grado);

Ytemp=Xatemp*Wopt; %Values are passed through the function

Ytemp=reshape(Ytemp,m,n);

plot(G0(:,1),G0(:,2),'bo',G1(:,1),G1(:,2),'rx')
hold on;
contour(x1,x2,Ytemp,[0 0], 'LineWidth',2);
hold off

%% Using the model for new data

Xtest=[-1 1; 0 2; 0 1; .5 .5; .75 .75; 1 1; 2 3; 2 -1];
Xatest=func_polinomio(Xtest,grado);
Vtest=Xatest*Wopt;
Ygtest=1./(1+exp(-Vtest));
Ygtest=round(Ygtest);
