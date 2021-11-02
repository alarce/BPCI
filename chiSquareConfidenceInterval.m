function [lowerEndPoint, upperEndPoint] = chiSquareConfidenceInterval(sampleData, confidence)

%sampleData = [775 780 781 795 803 810 823];
%confidence = 0.95;
alpha = 1 - confidence; %level of significance
s = std(sampleData); %standard deviation
n = size(sampleData,2); %sample size
dof = n - 1; %degrees of freedom

cLower = chi2inv(1-alpha/2, dof); %critical value for chi square distribution with 1-alpha/2
cUpper = chi2inv(alpha/2, dof); %critical value for chi square distribution with alpha/2

lowerEndPoint = (s*sqrt(n-1))/sqrt(cLower);
upperEndPoint = (s*sqrt(n-1))/sqrt(cUpper);
