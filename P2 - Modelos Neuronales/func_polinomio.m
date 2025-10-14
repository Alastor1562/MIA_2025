function [Xp,coef]=func_polinomio (X,ngrado) 
% Function that creates a matrix with the values received in X and raises them 
%to the power n degree. The results are returned as a matrix with the following
% structure [1 x1 x2 x1x2 x1^2 x2^2 ....]
% Xp=func_polinomio (X,ngrado)

Xp=ones(size(X,1),1);
nvar=size(X,2);
coef=zeros(1,nvar);

for g=1:ngrado
    % Obtain the coefficient table
    Atemp=[[g-1:-1:1]' [1:1:g-1]'];
    A=[];
    for i=1:nvar-1
        for j=i+1:nvar
            Btemp=zeros(g-1,nvar);
            Btemp(:,i)=Atemp(:,1);
            Btemp(:,j)=Atemp(:,2);
            A=[A; Btemp];
        end
    end 
    A=[A;g*eye(nvar)];
 
    %%% raise to the nth degree
    for k=1:size(A,1)
        temp=ones(size(X,1),1);
        for j=1:nvar
            temp=temp.*(X(:,j).^A(k,j));
        end
        Xp=[Xp temp];
    end 
    %%%%%%%%%%%%%%%%%%%
    coef=[coef;A];
end
coef=coef';