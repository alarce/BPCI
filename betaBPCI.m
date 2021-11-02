function [lowerBetaBPCI, upperBetaBPCI]= betaBPCI(numSuccess, sampleSize, confidence)

alpha = 1 - confidence;
prob1 = alpha/2;
prob2 = 1- alpha/2;
a = numSuccess + 0.5;
b = sampleSize - numSuccess + 0.5;

lowerBetaBPCI = betainv(prob1, a, b);
upperBetaBPCI = betainv(prob2, a, b);