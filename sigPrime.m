function output = sigPrime(vec)
% Derivative of Sigmoid Function
output = sig(vec).*(1-sig(vec));
end

