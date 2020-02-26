function [number] = Check(activationFunction, hiddenWeights, outputWeights, inputVector)
%zwraca rozpoznan¹ liczbê

% INPUT:
% activationFunction             : Activation function
% hiddenWeights                  : Weights of the hidden layer.
% outputWeights                  : Weights of the output layer.
% inputValues                    : Input values for training (784 x 10000).

% OUTPUT:
% correctlyClassified            : Number of correctly classified values.
% classificationErrors           : Number of classification errors.

        outputVector = Evaluate(activationFunction, hiddenWeights, outputWeights, inputVector);
        
        number = decisionRule(outputVector) - 1;
end