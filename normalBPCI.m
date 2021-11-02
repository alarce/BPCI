function [lowerNormalBPCI, upperNormalBPCI] = normalBPCI(p_hat, sampleSize, confidence)

alpha = 1 - confidence;
prob = 1- alpha/2; 
z = norminv(prob); %probit/quantile
lowerNormalBPCI = p_hat - z * sqrt((p_hat * (1 - p_hat))/sampleSize);

upperNormalBPCI = p_hat + z * sqrt((p_hat * (1 - p_hat))/sampleSize);


