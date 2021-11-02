function upperEndPointOneSided = chiSquareUpperOneSidedConfidenceInterval(sampleData, confidence)

alpha = 1 - confidence; %level of significance
n = size(sampleData, 2); %sample size
dof = n - 1; %degrees of freedom

s = std(sampleData); %standard deviation

prob = alpha;
c = chi2inv(prob, dof);

upperEndPointOneSided = (s * sqrt(n - 1))/ sqrt(c);