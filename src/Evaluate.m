function outputVector = Evaluate(activationFunction, hiddenWeights, outputWeights, inputVector)
%zwraca obliczony outputVector

% INPUT:
% activationFunction             : Activation function
% hiddenWeights                  : Weights of hidden layer
% outputWeights                  : Weights for output layer
% inputVector                    : Input vector to evaluate

% OUTPUT:
% outputVector                   : Output of the neuron

    outputVector = activationFunction(outputWeights*activationFunction(hiddenWeights*inputVector));
    
end