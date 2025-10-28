% [J,dJdW]=func_costo(W,Xa,Y)
% J is the cost
% dJdW is the gradient
% W are the weights

function [J,dJdW]=func_costo(W,Xa,Y)

    V = Xa*W;

    Yg = 1./(1+exp(-V));   %Logistic function
    
    n = size(Xa,1);  %Amount of data
    
    J = sum(-Y.*log(Yg)-(1-Y).*log(1-Yg))/n;  %Cost Function
    
    E = Yg-Y;   %Error
    
    dJdW = (E'*Xa)'/n; %Gradient

end