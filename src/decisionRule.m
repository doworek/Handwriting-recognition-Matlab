function iter = decisionRule(outputVector)
%zwraca iteracj�, przy kt�rej znaleziono najwi�ksz� warto��

% INPUT:
% outputVector      : Output vector of the network

% OUTPUT:
% class             : Class the vector is assigned to


    max = 0;
    iter = 1;
    for i = 1: size(outputVector, 1)
        if outputVector(i) > max
            max = outputVector(i);
            iter = i;
        end
    end
end