clc
clear
MLINPUTSIZE = 36 + 1; %4 classes x 9 channels (+1 bias)
totScore = 0; % Score for tracking Accuracy
possibleClasses = 5 + 1; % Baseline Open, Left Fist, Right Fist, Both Fists, Both Feet
NNnodeNumbers = [10,6]+1;
%Add +1 to each of the layers and stuff for the bias. Remeber to ignore
%first item in output layer, it was just easier this way
trainingRate = 0.01;

inputVec = rand([1 MLINPUTSIZE])-0.5;
inputVec(1) = 1; %Very Important

% outputVec = rand([1 possibleClasses])-0.5;
outputVec = [1 0 0 0 0 1];

%NN Weights Initialize %%%%%%%%%%%%%%%%

for i=1:length(NNnodeNumbers)
   if i == 1
       layerWeights = {rand([MLINPUTSIZE NNnodeNumbers(1)])};
       layerWeights(2) = {rand([NNnodeNumbers(1) NNnodeNumbers(2)])};
   elseif i == length(NNnodeNumbers)
       layerWeights(i+1) = {rand([NNnodeNumbers(i) possibleClasses])-0.5};
   else
       layerWeights(i+1) = {rand([NNnodeNumbers(i) NNnodeNumbers(i+1)])-0.5}; 
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while true
    layerWeights = NNbackProp2(inputVec,outputVec, layerWeights, trainingRate);
    NNFF2(inputVec, layerWeights)
    sum(abs(NNFF2(inputVec, layerWeights)-outputVec));
%     pause(1/10)
end
