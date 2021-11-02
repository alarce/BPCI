function f = gauss_distribution(x, mu, s)
exponent = -.5 * ((x - mu)/s) .^ 2;
denom = (s * sqrt(2*pi));
f = exp(exponent) ./ denom;