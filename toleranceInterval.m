function [lowerEndPointTI, upperEndPointTI] = toleranceInterval(sampleData, confidence, prob)

%argument validation
if (prob > 1)
    prob = prob/100;
end

%logic
mu = mean(sampleData); %sample mean 
s = std(sampleData); %sample standard deviation
n = size(sampleData,2); %sample size
dof = n - 1; %degrees of freedom
alpha = 1 - confidence; %level of significance
z_prob = (1 + prob)/2;
chi_prob = 1 - alpha;
z = norminv(z_prob);
chi = chi2inv(chi_prob, dof);
k2 = z * sqrt((dof*(1+1/n))/(chi));

lowerEndPointTI = mu - k2*s;
upperEndPointTI = mu + k2*s;