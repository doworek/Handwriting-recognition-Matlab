function [correctlyClassified, classificationErrors] = Validate(activationFunction, hiddenWeights, outputWeights, inputValues, labels)
%zwraca statystykê b³êdów
%korzysta z funkcji decisionRule i Evaluate

% INPUT:
% activationFunction             : Activation function
% hiddenWeights                  : Weights of the hidden layer
% outputWeights                  : Weights of the output layer
% inputValues                    : Input values for training (784 x 10000)
% labels                         : Labels for validation (1 x 10000)

% OUTPUT:
% correctlyClassified            : Number of correctly classified values
% classificationErrors           : Number of classification errors

    testSetSize = size(inputValues, 2);
    classificationErrors = 0;
    correctlyClassified = 0;
    
    for n = 1: testSetSize
        inputVector = inputValues(:, n);
        outputVector = Evaluate(activationFunction, hiddenWeights, outputWeights, inputVector);
        
        iter = decisionRule(outputVector);
        if iter == labels(n) + 1
            correctlyClassified = correctlyClassified + 1;
        else
            classificationErrors = classificationErrors + 1;
        end
    end
end