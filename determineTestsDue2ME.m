function numberofSamples = determineTestsDue2ME(ME, confidence, s)

alpha = 1 - confidence; %level of significance
prob = 1- (alpha/2);
for j = 1:5
    if (j > 1)
       t = tinv(prob, samplesize - 1);
       c = t;
    else
       z = norminv(prob);
       c = z;
    end
    samplesize = (c*s/ME)^2;

end
numberofSamples = round(samplesize);