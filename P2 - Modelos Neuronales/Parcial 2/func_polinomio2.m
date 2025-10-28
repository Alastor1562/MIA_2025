function [Xp,coef]=func_polinomio2(X,ngrado) 
% Function that creates an array with the values received in X and raises them to the nth power. 
%The results are returned as a matrix with the following structure [1 x1 x2 x1x2 x1^2 x2^2 ....]

% Xp=func_polinomio (X,ngrado)
Xp=ones(size(X,1),1); %Amount of data
nvar=size(X,2); %Number of variables

vec=zeros(1,nvar);
combina=vec;
reng=1;
col=1;
cont1=1;
cont2=1;
while cont1<=ngrado 
    if col==1
        vec(reng+1,:)=zeros(1,nvar);    
        vec(reng+1,col)=cont1; 
        combina=[combina; unique(perms(vec(reng+1,:)),'rows')];
    else
        vec(reng+1,:)=vec(reng,:);    
        vec(reng+1,col)=cont2;
        combina=[combina; unique(perms(vec(reng+1,:)),'rows')];
    end
        col=col+1;
        reng=reng+1;
    if sum(vec(reng,:))==ngrado|col==nvar+1
        cont1=cont1+1;
        cont2=1;
        col=1;
    end
end


ndat=size(X,1);
for i=2:size(combina,1)
    temp=ones(ndat,1);
    for j=1:size(combina,2)
        temp=temp.*X(:,j).^combina(i,j);
    end
    Xp=[Xp temp];
end
coef=combina;
end