function outPut = NNFF2(inputVec,layerMatrices)
% LAYERS IS CELL ARRAY OF MATRICES
outPut = inputVec;
for i = 1:length(layerMatrices)
    outPut = sig(outPut * cell2mat(layerMatrices(i)));
    outPut(1) = 1;
end

end

