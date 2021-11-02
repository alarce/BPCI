function lowerEndPointOneSided = chiSquareLowerOneSidedConfidenceInterval(sampleData, confidence)

alpha = 1 - confidence; %level of significance
n = size(sampleData, 2); %sample size
dof = n - 1; %degrees of freedom

s = std(sampleData); %standard deviation

prob = 1 - alpha;
c = chi2inv(prob, dof);

lowerEndPointOneSided = (s * sqrt(n - 1))/ sqrt(c);
