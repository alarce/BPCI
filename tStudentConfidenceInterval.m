function [lowerEndPoint, upperEndPoint] = tStudentConfidenceInterval(sampleData, confidence);

mu = mean(sampleData); %sample mean 
s = std(sampleData); %sample standard deviation
n = size(sampleData,2); %sample size
dof = n - 1; %degrees of freedom
alpha = 1 - confidence; %level of significance
prob = 1- (alpha/2);
c = tinv(prob, dof); %c= 2.0452;
lowerEndPoint = mu - ((c*s)/sqrt(n));
upperEndPoint = mu + ((c*s)/sqrt(n));