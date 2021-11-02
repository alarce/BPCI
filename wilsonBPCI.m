function [lowerWilsonBPCI, upperWilsonBPCI] = wilsonBPCI(p_hat, sampleSize, confidence)

alpha = 1 - confidence;
prob = 1- alpha/2; 
z = norminv(prob); %probit/quantile
n = sampleSize;

centerValue = (p_hat + (z^2)/(2*n))/(1 + (z^2)/n); %center value of the CI
lowerWilsonBPCI = centerValue - (z/(1 + z^2/n)) * sqrt(((p_hat*(1-p_hat))/n) + (z^2/(4*n^2)));
upperWilsonBPCI = centerValue + (z/(1 + z^2/n)) * sqrt(((p_hat*(1-p_hat))/n) + (z^2/(4*n^2)));