function lowerEndPointOneSided = tStudentLowerOneSidedConfidenceInterval(sampleData, confidence)

mu = mean(sampleData); %sample mean 
s = std(sampleData); %sample standard deviation
n = size(sampleData,2); %sample size
dof = n - 1; %degrees of freedom
alpha = 1 - confidence; %level of significance
prob = alpha;
c = tinv(prob, dof); %c= 2.0452;
lowerEndPointOneSided = mu + ((c*s)/sqrt(n));