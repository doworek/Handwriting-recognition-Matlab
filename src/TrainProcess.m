function [hiddenWeights, outputWeights] = TrainProcess(activationFunction, dActivationFunction, numberOfHiddenUnits, inputValues, targetValues, epochs, batchSize, learningRate)
% tworzenie dwuwarstwowej sieci neuronowej i uczenie jej na bazie MNIST
%zwaraca wagi

% INPUT:
% activationFunction             : Activation function used in both layers
% dActivationFunction            : Derivative of the activation function
% numberOfHiddenUnits            : Number of hidden units
% inputValues                    : Input values for training (784 x 60000)
% targetValues                   : Target values for training (1 x 60000)
% epochs                         : Number of epochs to train
% learningRate                   : Learning rate to apply

% OUTPUT:
% hiddenWeights                  : Weights of the hidden layer
% outputWeights                  : Weights of the output layer


    % The number of training vectors
    trainingSetSize = size(inputValues, 2); %liczba kolumn MNIST = 60 000
    
    % Input vector has 784 dimensions
    inputDimensions = size(inputValues, 1); %%liczba wierszy MNIST = 784
    % We have to distinguish 10 digits
    outputDimensions = size(targetValues, 1); %liczba wierszy macierzy oczekiwanych wartoœci = 10
    
    % Initialize the weights for the hidden layer and the output layer
    hiddenWeights = rand(numberOfHiddenUnits, inputDimensions); %macierz wag np. 300x784
    outputWeights = rand(outputDimensions, numberOfHiddenUnits); %macierz wag np. 10x300
    
    hiddenWeights = hiddenWeights./size(hiddenWeights, 2); %zmniejszanie wag do rzêdu 3-4 miejsc po przecinku
    outputWeights = outputWeights./size(outputWeights, 2);

    for k = 1: epochs
       % Select which input vector to train on
       n = floor(rand(1)*trainingSetSize - batchSize); %choose a batch
            
       % Propagate the input vector through the network
       inputVector = inputValues(:, n: n + batchSize ); 
       hiddenActualInput = hiddenWeights*inputVector ;
       hiddenOutputVector = activationFunction(hiddenActualInput) ;
       outputActualInput = outputWeights*hiddenOutputVector ; 
       outputVector = activationFunction(outputActualInput);
       
       targetVector = targetValues(:, n: n + batchSize);
            
       % Backpropagate the errors
       outputDelta = dActivationFunction(outputActualInput).*(outputVector - targetVector); 
       hiddenDelta = dActivationFunction(hiddenActualInput).*(outputWeights'*outputDelta); 
            
       outputWeights = outputWeights - learningRate.*outputDelta*hiddenOutputVector' / batchSize;
       hiddenWeights = hiddenWeights - learningRate.*hiddenDelta*inputVector' / batchSize; 

    end
    
end