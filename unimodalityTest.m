function [distribution, unimodalProb ] = unimodalityTest(data)
%Hartigan method == dip test

reshapedData = computeInputForHartiganDipTest(data);
nboot = 500; %bootstrap samples to be generated
[dip, p_value, xlow, xup] = HartigansDipSignifTest(reshapedData, nboot);

unimodalProb = p_value;

if (unimodalProb > 0.5)
    distribution = 'unimodal';
elseif(unimodalProb < 0.05)
    distribution = 'bimodal';
else
    distribution = 'unknown';
end