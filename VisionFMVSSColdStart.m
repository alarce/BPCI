numSuccess = 403;
numBernoulli = 404;
confidence = 0.95;
alpha = 1 - confidence;

p_hat = numSuccess / numBernoulli;

% normal
[lowerNormalBPCI, upperNormalBPCI] = normalBPCI(p_hat, numBernoulli, confidence)
if (upperNormalBPCI > 1)
    upperNormalBPCI = 1;
end
% agresti-coull
 [lowerAC_BPCI, upperAC_BPCI] = agrestiCoullBPCI(numBernoulli, numSuccess, confidence)
 if (upperAC_BPCI > 1)
    upperAC_BPCI = 1;
end
% beta / Jeffreys
[lowerBetaBPCI, upperBetaBPCI] = betaBPCI(numSuccess, numBernoulli, confidence)
% wilson
[lowerWilsonBPCI, upperWilsonBPCI] = wilsonBPCI(p_hat, numBernoulli, confidence)
% binom tst

% clopper pearson 
[phat,pci] = binofit(numSuccess, numBernoulli, alpha)
lowerCP_BPCI = pci(1);
upperCP_BPCI = pci(2);


h = figure('WindowState','maximized')  
    plot([1; 1], [lowerNormalBPCI; upperNormalBPCI], 'LineWidth', 8);
    %errorbar(i,nu(i), nu(i) - lower(i), upper(i) - nu(i));
    hold on
    plot([2; 2], [lowerAC_BPCI; upperAC_BPCI], 'LineWidth', 8);
    hold on
    plot([3; 3], [lowerBetaBPCI; upperBetaBPCI], 'LineWidth', 8);
    hold on
    plot([4; 4], [lowerWilsonBPCI; upperWilsonBPCI], 'LineWidth', 8);
    hold on
    plot([5; 5], [lowerCP_BPCI; upperCP_BPCI], 'LineWidth', 8);
    hold on
    yline(p_hat, "--", "Raw probability", 'color', 'g');
    hold on
    yline(0.998, "--", "2R/1000 Target", 'color', 'r'); %mark the target of 95
    hold on
    
    
    
    rawProbLegend = strcat("Raw Probability:", "{ }", "99.75");
    legend_BPCI = ["CI-Normal [99.27-100]","CI-AC [98.47-100]","CI-Beta [98.85-99.97]","CI-Wilson [98.61-99.96","CI-CP [98.63-99.99",rawProbLegend, "Target: 99.8"];
    legend(legend_BPCI);
    
    
    BPCIMethod = {'Normal','Agresti-Coull','Beta','Wilson','Clopper-Pearson'};
    title("confidence interval: FN Probability  [LSAEB]");
    xlabel('BPCI method');
    ylabel('Probability');
    set(gca,'xtick',[1:size(BPCIMethod, 2)],'xticklabel',BPCIMethod);
    xtickangle(45);
    ymin = 0.984;
    ymax = 1;
    ylim = [ymin, ymax];
    xmax = 6;
    axis([0 xmax ylim]);   
    grid on;

    
    testsnum = determineTestsDue2ME(0.05, 0.95, 0.0498)