function [updatedLayerMatrices] = NNbackProp3(inputVec,trainingData,layerMatrices, trainingRate)
% FIX THIS NICE CODE SO THAT YOU CAN USE IT :)

G = trainingData; 
inputVec(1) = 1;
deltaMats = {};
%%
Phi = {};
Z = {};
for i=1:length(layerMatrices)
    if i == 1
        Phi{i} = inputVec*cell2mat(layerMatrices(i));       
    else
        Phi{i} = cell2mat(Z(i-1))*cell2mat(layerMatrices(i));
    end
    temp = sig(cell2mat(Phi(i)));
    temp(1) = 1;
    Z{i} = temp;    
end
t = cell2mat(Z(length(layerMatrices)));
dJdt = -G./t + (1-G)./(1-t);
%%
DbyDlayers = {};
DbyDoutputs = {};

for i=1:length(layerMatrices)
   if i==1
      DbyDlayers{i} = inputVec'.*sigPrime(cell2mat(Phi(i)));
   else
      DbyDlayers{i} = cell2mat(Z(i-1))'*sigPrime(cell2mat(Phi(i)));
   end
   DbyDoutputs{i} =  sigPrime(cell2mat(Phi(i))).*cell2mat(layerMatrices(i));
end

%%
deltaMats = {};
% for i=1:length(layerMatrices)
%        tot = dJdt;
%        for j=length(layerMatrices):-1:2
%            if j~= 1
%                 tot = tot*cell2mat(DbyDoutputs(j))';
%            end
%        end
%        size(tot)
%        size(cell2mat(DbyDlayers(j)))
%        tot = tot.*cell2mat(DbyDlayers(j));
%        deltaMats{length(layerMatrices)-i+1}= trainingRate*tot;
% end
%%
for i=length(layerMatrices):-1:1
   tot = dJdt;
   for j=length(layerMatrices):-1:2
        tot = tot*cell2mat(DbyDoutputs(j))';
   end
    size(tot)
    size(cell2mat(DbyDlayers(j)))
    tot = tot'.*cell2mat(DbyDlayers(j));
    deltaMats{length(layerMatrices)-i+1} = trainingRate*tot;
end
%% Updating Layer Matrices
for i=1:length(layerMatrices)
    size(cell2mat(deltaMats(i)))
%    updatedLayerMatrices{i} = cell2mat(layerMatrices(i)) - cell2mat(deltaMats(i));
end
end


