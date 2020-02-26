function y = dsigm(x)
% derivative of the sigmoid function
    y = sigm(x).*(1 - sigm(x));
end