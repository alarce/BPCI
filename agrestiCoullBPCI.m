function [lowerAC_BPCI, upperAC_BPCI] = agrestiCoullBPCI(sampleSize, numSuccess, confidence)

n = sampleSize;
alpha = 1 - confidence;
prob = 1- alpha/2; 
z = norminv(prob); %probit/quantile

n_tilde = n + z^2;
p_tilde = (1/n_tilde) * (numSuccess + z^2/2); %centerPointWilsonAdjustment 

lowerAC_BPCI = p_tilde - z*sqrt((p_tilde/n_tilde)*(1 - p_tilde));
upperAC_BPCI = p_tilde + z*sqrt((p_tilde/n_tilde)*(1 - p_tilde));