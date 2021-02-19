function [updatedLayerMatrices] = NNbackProp2(inputVec,trainingData,layerMatrices, trainingRate)
G = trainingData; 
u = cell2mat(layerMatrices(3));
w = cell2mat(layerMatrices(2));
v = cell2mat(layerMatrices(1));
inputVec(1) = 1;
deltaMats = {};
%Make sure this order is right

phi_1 = inputVec * v;
z = sig(phi_1);
z(1) = 1;

phi_2 = z * w;
y = sig(phi_2);
y(1) = 1;

phi_3 = y * u;
t = sig(phi_3);

dJdt = -G./t + (1-G)./(1-t); %Logistic Regression

dtdu = y'*sigPrime(phi_3);
dtdy = sigPrime(phi_3).*u;

dydw = z'*sigPrime(phi_2);
dydz = sigPrime(phi_2).*w;

dzdv = inputVec'.*sigPrime(phi_1);
dzdx = sigPrime(phi_1).*v;

%% Can use this pattern to repeat 
dJdu = dJdt.*dtdu;
dJdw = (dJdt*dtdy').*dydw;
dJdv = ((dJdt*dtdy')*dydz').*dzdv;
%% Implement a programatic, depth-agnostic solution
deltaMats{3} = trainingRate*dJdu;
deltaMats{2} = trainingRate*dJdw;
deltaMats{1} = trainingRate*dJdv;
%% Updating Layer Matrices
updatedLayerMatrices{1} = cell2mat(layerMatrices(1)) - cell2mat(deltaMats(1));
updatedLayerMatrices{2} = cell2mat(layerMatrices(2)) - cell2mat(deltaMats(2));
updatedLayerMatrices{3} = cell2mat(layerMatrices(3)) - cell2mat(deltaMats(3));
end


