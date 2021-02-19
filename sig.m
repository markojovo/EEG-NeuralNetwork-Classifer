function output = sig(vec)
% Sigmoid Function
sz = size(vec);
rows = sz(1);
cols = sz(2);
output(1:rows,1:cols) = (1+exp(-vec(1:rows,1:cols))).^-1; 
end

