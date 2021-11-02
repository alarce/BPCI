%CI Calculator
%This script determines the confidence interval (CI) of the mean of a
%population by means of the student's t distribution, and the CI of the
%standard deviation of a population by means of the chi square distribution
%two sided CI and one sided CI are considered.
%author: Alvaro Arroyo Cebeira (aarroyoc@jaguarlandrover.com)

clear all
clc

confidence = 0.9;
alpha = 1- confidence;

%% excel parser
filename = 'LSAEB_FDJ_SummaryData.xlsx';
T = readtable(filename);
%T = unique(T,'rows','stable');
% Categorize search parameters
T.Scenario = categorical(T.Scenario);
T.Speed = categorical(T.Speed);
T.Pass_Fail = categorical(T.Pass_Fail);

scenarios = unique(T.Scenario);
scenarios_num = size(scenarios, 1);
speedScenarios = unique(T.Speed);

rows_1 = T.Pass_Fail == "OK";
vars = {'Scenario','Speed', 'Pass_Fail', 'Distance_to_object'};
T1 = T(rows_1,vars);

totalSample_num = size(T, 1);
sampleOK_num = size(T1, 1);
sampleNOK_num = totalSample_num - sampleOK_num;

T1_AD_rows = string(T1.Scenario) == 'Adult Dynamic';%contains(string(T1.Scenario),'Adult Dynamic');
T1_AD_DS_rows = contains(string(T1.Scenario),'Adult Dynamic - Driver Side');
T1_AS_rows = contains(string(T1.Scenario),'Adult Static');
T1_B_rows = contains(string(T1.Scenario),'Bollard');
T1_C2C_rows = string(T1.Scenario) == 'Car2Car';%contains(string(T1.Scenario),'Car2Car');
T1_C2C_HB_rows = contains(string(T1.Scenario),'Car2Car - HeckBoxVeh');
T1_CD_rows = string(T1.Scenario) == 'Child Dynamic'; %contains(string(T1.Scenario),'Child Dynamic');
T1_CD_DS_rows = contains(string(T1.Scenario),'Child Dynamic - Driver Side');
T1_CS_rows = contains(string(T1.Scenario),'Child Static');
T1_P_rows = contains(string(T1.Scenario),'Pillar DoE');

    %rows_ChildStatic = T1.Scenario=='Child Static';
    %T_CS = T1(rows_ChildStatic,vars);
   
    
    data = str2double(T1.Distance_to_object);
    data(isnan(data)) = 0;
    
 %% Analyzed scenarios-sample
 count = [size(T1.Distance_to_object(T1_AD_rows),1); size(T1.Distance_to_object(T1_AD_DS_rows),1); size(T1.Distance_to_object(T1_AS_rows),1); size(T1.Distance_to_object(T1_B_rows),1); size(T1.Distance_to_object(T1_C2C_rows),1); size(T1.Distance_to_object(T1_C2C_HB_rows),1); size(T1.Distance_to_object(T1_CD_rows),1); size(T1.Distance_to_object(T1_CD_DS_rows),1); size(T1.Distance_to_object(T1_CS_rows),1); size(T1.Distance_to_object(T1_P_rows),1)];
    x = categorical([{'Adult Dynamic'} {'Adult Dyn.-Driver Side'} {'Adult Static'} {'Bollard'} {'Car2Car'} {'Car2Car - HeckBoxVeh'} {'Child Dynamic'} {'Child Dyn.-Driver Side'} {'Child Static'} {'Pillar DoE'}]);
    %x = reordercats(x,{'Combined', 'Cold Start', 'Warm Start', 'View Activation', 'View Switch', 'Parallel Transition', 'Market', 'Fast Init', 'Startup', 'Init Screen'});
    figure('WindowState','maximized');
    set(gcf,'Units', 'Inches', 'OuterPosition', [0, 0.04, 18, 12]);
    bar(x,count,'stacked');
    title(strcat('Test Data Sample Distribution')); 
    
    %save as
    barchart_name{1} = strcat('./Images/DistributionChart_config', num2str(1));
    barchart_name{1} = strcat(barchart_name(1), '.png');
    picture_name = string(barchart_name{1});
    saveas(gcf,picture_name);
 %% LOGIC
 
%{ 
n = size(dist{1},2);
alpha = 1- confidence;

for i = 1:numScenarios
    % two-sided confidence interval: mean
    [lowerEndPoint, upperEndPoint] = tStudentConfidenceInterval(dist{i}, confidence);
    lower(i) = lowerEndPoint;
    upper(i) = upperEndPoint;
    % two-sided confidence interval: standard deviation
    [lowerEndPointStdDev, upperEndPointStdDev] = chiSquareConfidenceInterval(dist{i}, confidence);
    lowerStdDev(i) = lowerEndPointStdDev;
    upperStdDev(i) = upperEndPointStdDev;
    % lower one-sided confidence interval: mean
    [lowerEndPointOneSidedTStudent] = tStudentLowerOneSidedConfidenceInterval(dist{i}, confidence);
    lowerMeanOneSided(i) = lowerEndPointOneSidedTStudent;
    % lower one-sided confidence interval: standard deviation
    [upperEndPointOneSidedChiSquare] = chiSquareUpperOneSidedConfidenceInterval(dist{i}, confidence);
    upperStdDevOneSided(i) = upperEndPointOneSidedChiSquare;
    
    
nu(i) = mean(dist{i}); %sample mean 
s(i) = std(dist{i}); %sample standard deviation

figure(1)
plot([i; i], [lower(i); upper(i)], 'LineWidth', 5);
hold on
plot(i,nu(i),'*');
hold on

figure(2)
plot(i, s(i), '*');
hold on
errorbar(i,s(i), s(i) - lowerStdDev(i), upperStdDev(i) - s(i));
hold on

end

indexScenario = 0;
for k = 1:2:2*size(dist, 2)
    indexScenario = indexScenario + 1;
    %if (mod(k,2) == 1) %k is odd
        CIText = strcat(num2str(100*confidence), '%', {' '},'CI scenario', {' '}, num2str(indexScenario));
        legend_text(k) = CIText; 
        legend_text_StdDevCI(k) = CIText;
    %elseif (mod(k,2) == 0) % k is even
        CIText = strcat('raw mean: scenario', {' '}, num2str(indexScenario));
        legend_text(k+1) = CIText;
        CITextStdDev = strcat('raw sigma: scenario', {' '}, num2str(indexScenario));
        legend_text_StdDevCI(k+1) = CITextStdDev;
    %end
end

names = scenariosTitles

figure(1)
    title("mean of the stop distance: two-sided confidence interval [LSAEB]");
    xlabel('scenarios');
    ylabel('stop distance [cm]');
    set(gca,'xtick',[1:size(names, 1)],'xticklabel',names);
    xtickangle(45);
    ymin = 0;
    upperLimitGraph = upper + 10; %10 = margin to add more space to the graph
    ymax = ceil(max(upperLimitGraph));
    ylim = [ymin, ymax];
    xmax = size(dist,2) + 1;
    axis([0 xmax ylim]);
    yvector = 0:5:130;
    yticks(yvector); 
    yline(15, "--", "Target KPI"); %mark the target of 15 cm
    hold on
    legend(legend_text);
    grid on;


figure(2)
    title("standard deviation of the stop distance: two-sided confidence interval [LSAEB]");
    xlabel('scenarios');
    ylabel('std deviation of the stop distance [cm]');
    set(gca,'xtick',[1:size(names,1)],'xticklabel',names);
    xtickangle(45);
    ymin = 0;
    upperLimitGraph = upperStdDev + 10;
    ymax = ceil(max(upperLimitGraph));
    ylim = [ymin, ymax];
    xmax = size(dist,2) + 1;
    axis([0 xmax ylim]);
    yvectorStdDev = 0:5:80;
    yticks(yvectorStdDev); 
    yline(5, "--", "Target KPI"); %mark the target of 5 cm
    hold on
    legend(legend_text_StdDevCI);
    grid on;

 %}
  
    
    %% PDF
    pts = -10:0.5:100;
    percentile95 = prctile(data,95);
    percentile5 = prctile(data,5);
    percentile90 = prctile(data,90);
    percentile10 = prctile(data,10);
   
    mean_value(1) = mean(data);
    stddev_value(1) = std(data);
 
    PERCENTRANK = @(YourArray, TheProbes) reshape( mean( bsxfun(@le, YourArray(:), TheProbes(:).') ) * 100, size(TheProbes) );
    percentileOf15CM = PERCENTRANK(data, 15)
    
    [pdf,xi] = ksdensity(data, pts, 'Bandwidth', 2.7); %3
    
    h = figure('WindowState','maximized')
    plot(xi, pdf);
    hold on
    %xline(15, "--", "Target KPI");
    %hold on
    title("Probability Density Function of the stop distance [LSAEB]");
    xlabel('stop distance [cm]');
    ylabel('Probability');
    xline(percentile95, '--','percentile 95th');
    xline(percentile5, '--', 'percentile 5th');
    xline(percentile90, '--','percentile 90th');
    xline(percentile10, '--','percentile 10th');
    
    %tolerance interval
    [lowerTI, upperTI] = toleranceInterval(data', confidence, 0.9);
    xline(lowerTI, 'Label','lower Tolerance', 'LineStyle', '--','Color', 'r');
    xline(upperTI, 'Label','upper Tolerance', 'LineStyle', '--','Color','r');
     
    pdf_name{1} = strcat('./Images/PDF', num2str(1));
    pdf_name{1} = strcat(pdf_name(1), '.png');
    picture_name = string(pdf_name{1}); 
    saveas(h,picture_name);
    
    
    
    
    %% EXTREME VALUE THEORY
    
    %left tail
    [rawcollisionProb, probCollisionLSAEB] = EVT(data, percentile10,'left', 0);
        
    %right tail
    [rawProbNuisanceLSAEB, probNuisanceLSAEB] = EVT(data, percentile90,'right', 90);
        
        
        %% distribution unimodality/bimodality
    [distribution, unimodalProb] = unimodalityTest(data);
    if(strcmp(distribution, 'bimodal')) %bimodal
        %x = 0:0.1:100;
        %pdfObject = fitdist(dist{end}','Kernel','BandWidth',0.3);
        %pdfunction = pdf(pdfObject,x);
        pdfunction = pdf;
        [pks, locs] = findpeaks(pdfunction);
        pks = round(pks, 3);
        pksUnique = unique(round(pks,3));
        pksUniqueSorted = sort(pksUnique,'descend');
        %for i=1:size(pksUnique,2)
        %select the two bigger values
        pksMax(1) = max(pksUniqueSorted);
        indexModes(1) = find(pks == pksMax(1));
        mode1 = xi(locs(indexModes(1)))
        if (size(pksUniqueSorted, 2) > 1)
            pksMax(2) = pksUniqueSorted(2);
            indexModes(2) = find(pks == pksMax(2));
            mode2 = xi(locs(indexModes(2)))
        else
            distribution = "unimodal"
            mode1 = -1;
            mode2 = -1;
        end
    else
        mode1 = -1;
        mode2 = -1;
        
        
    end
    
        PDFStruct.mean = mean_value(1);
        PDFStruct.stddev = stddev_value(1);
        PDFStruct.distribution = distribution;
        PDFStruct.mode1 = mode1;
        PDFStruct.mode2 = mode2;
        PDFStruct.CollisionProbEVT = 'N/A'; %probCollisionLSAEB; %not applicable
        PDFStruct.CollisionProbRaw = rawcollisionProb;
        PDFStruct.NuisanceProbEVT = probNuisanceLSAEB;
        PDFStruct.NuisanceProbRaw = rawProbNuisanceLSAEB;
        PDFData{1} = PDFStruct;
        
        
        %% weighted PDF
        %nominal probability
    Weights.p_AD = 0.1;
    Weights.p_AD_DS = 0.1;
    Weights.p_AS = 0.1;
    Weights.p_B = 0.1;
    Weights.p_C2C = 0.1;
    Weights.p_C2C_HB = 0.1;
    Weights.p_CD = 0.1;
    Weights.p_CD_DS = 0.1;
    Weights.p_CS = 0.1;
    Weights.p_P = 0.1;
    n_AD = sum(T1.Scenario =='Adult Dynamic'); %n_xx = size(find(T_xx_rows), 1);
    n_AD_DS = sum(T1.Scenario=='Adult Dynamic - Driver Side'); %size(T1(rows_WS, 'ReverseTiming'), 1)
    n_AS = sum(T1.Scenario=='Adult Static');
    n_B = sum(T1.Scenario=='Bollard');
    n_C2C = sum(T1.Scenario=='Car2Car');
    n_C2C_HB = sum(T1.Scenario=='Car2Car - HeckBoxVeh');
    n_CD = sum(T1.Scenario=='Child Dynamic');
    n_CD_DS = sum(T1.Scenario=='Child Dynamic - Driver Side');
    n_CS = sum(T1.Scenario=='Child Static');
    n_P = sum(T1.Scenario=='Pillar DoE');
    
    TotalSample = n_AD + n_AD_DS + n_AS + n_B + n_C2C + n_C2C_HB + n_CD + n_CD_DS + n_CS + n_P;
    %TotalSample = size(T1, 1);
    
    %importance probability
    q_AD= n_AD/TotalSample;
    q_AD_DS = n_AD_DS/TotalSample;
    q_AS = n_AS/TotalSample;
    q_B = n_B/TotalSample;
    q_C2C = n_C2C/TotalSample;
    q_C2C_HB = n_C2C_HB/TotalSample;
    q_CD = n_CD/TotalSample;
    q_CD_DS = n_CD_DS/TotalSample;
    q_CS = n_CS/TotalSample;
    q_P = n_P/TotalSample;
    
    weight_AD = Weights.p_AD/q_AD;
    weight_AD_DS = Weights.p_AD_DS/q_AD_DS;
    weight_AS = Weights.p_AS/q_AS;
    weight_B = Weights.p_B/q_B;
    weight_C2C = Weights.p_C2C/q_C2C;
    weight_C2C_HB = Weights.p_C2C_HB/q_C2C_HB;
    weight_CD = Weights.p_CD/q_CD;
    weight_CD_DS = Weights.p_CD_DS/q_CD_DS;
    weight_CS = Weights.p_CS/q_CS;
    weight_P = Weights.p_P/q_P;
    total_weight = (n_AD*weight_AD) + (n_AD_DS*weight_AD_DS) + (n_AS*weight_AS) ...
                     + (n_B*weight_B) + (n_C2C*weight_C2C) + (n_C2C_HB*weight_C2C_HB) + (n_CD*weight_CD) ...
                     + (n_CD_DS*weight_CD_DS) + (n_CS*weight_CS) + (n_P*weight_P);
    normalizedWeight_AD = weight_AD / (total_weight);
    normalizedWeight_AD_DS = weight_AD_DS / (total_weight);
    normalizedWeight_AS = weight_AS / (total_weight);
    normalizedWeight_B = weight_B / (total_weight);
    normalizedWeight_C2C = weight_C2C / (total_weight);
    normalizedWeight_C2C_HB = weight_C2C_HB / (total_weight);
    normalizedWeight_CD = weight_CD / (total_weight);
    normalizedWeight_CD_DS = weight_CD_DS / (total_weight);
    normalizedWeight_CS = weight_CS / (total_weight);
    normalizedWeight_P = weight_P / (total_weight);
    
 
    T1.Weight =  ones(size(T1, 1), 1);
    T1(T1_AD_rows, 'Weight') = num2cell( normalizedWeight_AD .* ones(n_AD, 1));
    T1(T1_AD_DS_rows, 'Weight') = num2cell( normalizedWeight_AD_DS .* ones(n_AD_DS, 1));
    T1(T1_AS_rows, 'Weight') = num2cell( normalizedWeight_AS .* ones(n_AS, 1));
    T1(T1_B_rows, 'Weight') = num2cell( normalizedWeight_B .* ones(n_B, 1));
    T1(T1_C2C_rows, 'Weight') = num2cell( normalizedWeight_C2C .* ones(n_C2C, 1));
    T1(T1_C2C_HB_rows, 'Weight') = num2cell( normalizedWeight_C2C_HB .* ones(n_C2C_HB, 1));
    T1(T1_CD_rows, 'Weight') = num2cell( normalizedWeight_CD .* ones(n_CD, 1));
    T1(T1_CD_DS_rows, 'Weight') = num2cell( normalizedWeight_CD_DS .* ones(n_CD_DS, 1));
    T1(T1_CS_rows, 'Weight') = num2cell( normalizedWeight_CS .* ones(n_CS, 1));
    T1(T1_P_rows, 'Weight') = num2cell( normalizedWeight_P .* ones(n_P, 1));
    x = str2double(T1.Distance_to_object);
    xw = T1.Weight;
    x(isnan(x)) = 0;
    
    weightedMean = sum(x.*xw) / sum(xw);
    weightedStdDev = sum(xw.*(x - weightedMean).^2) / sum(xw);
    weightedPDFData_struct.mean = weightedMean;
    weightedPDFData_struct.stddev = weightedStdDev;
    weightedPDFData{1} = weightedPDFData_struct;
    
    if (q_AD > 0 && q_AD_DS > 0 && q_AS > 0 &&...
            q_B > 0 && q_C2C > 0 && q_C2C_HB > 0 && ...
            q_CD > 0 && q_CD_DS > 0 && q_CS > 0 && q_P > 0) % if a weight is zero or infinity-> weighted PDF is not applicable
        figure('WindowState','maximized')
        [f,xi] = ksdensity(x, 'Bandwidth', 3, 'Weights',xw);
        plot(xi,f)
        hold on
        title('Weighted PDF');
        xlabel('time [s]');
        ylabel('Probability Density');
        
        [prob, EVTProb_weighted] = EVTfromPDF(x, percentile90, xi, f,'right', 90);
       
        indexX = xi>=90;
        indexX = find(indexX);
        indexX = indexX(1);
        area(xi(xi >= 90), f(indexX:size(f,2)) );
        
    text = strcat('Prob. late auto rear view: ', {' '}, 'EVT = ', num2str(EVTProb_weighted),'%', {' '}, 'Raw = ', num2str(prob), '%');
    legend('PDF', text{1}, 'Location', "best");
    
        pdfWeighted_name{1} = strcat('./Images/PDFWeighted_config', num2str(1));
        pdfWeighted_name{1} = strcat(pdfWeighted_name(1), '.png');
        picture_name = string(pdfWeighted_name{1});
        saveas(gcf,picture_name);
        hold off;
    else %at least one weight is zero therefore weighted pdf cannot be compute
        pdfWeighted_name{config_num} = './Images/NotEnoughData.png';
    end
   
        %% PDF per scenario
        %
        
        T_AD = T1(T1_AD_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_AD.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3);
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Adult Dynamic';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
        
        T_AD_DS = T1(T1_AD_DS_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_AD_DS.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Adult Dynamic - Driver Side';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability'); 
        
        T_CS = T1(T1_CS_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_CS.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Child Static';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability'); 

         T_B = T1(T1_B_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_B.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Bollard';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
        
         T_B = T1(T1_B_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_B.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Bollard';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
        
         T_C2C = T1(T1_C2C_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_C2C.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for C2C';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');

          T_C2C_HB = T1(T1_C2C_HB_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_C2C_HB.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Car2Car - HeckBoxVeh';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
        
         T_CD = T1(T1_CD_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_CD.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Child dynamic';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
        
         T_CD_DS = T1(T1_CD_DS_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_CD_DS.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Child Dynamic - Driver Side';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
    
         T_CS = T1(T1_CS_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_CS.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Child Static';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');
   
        T_P = T1(T1_P_rows,vars);
        clear data_stop_dist
        data_stop_dist = str2double(T_P.Distance_to_object);
        [pdf,xi] = ksdensity(data_stop_dist, pts, 'Bandwidth', 3); 
        figure
        plot(xi, pdf);
        strtemp = 'PDF for Pillar DOE';
        title(strtemp);
        xlabel('stop distance [cm]');
        ylabel('Probability');

        %{
        for l= 1:numScenarios - 1
            figure()
            [pdf,xi] = ksdensity(dist{l}, pts, 'Bandwidth', 3);  
            plot(xi, pdf);
            strtemp = strcat('PDF for', {' '}, scenariosTitles(l));
            title(strtemp);
            xlabel('stop distance [cm]');
            ylabel('Probability'); 
        end
        %low speed
        figure()
            [pdf,xi] = ksdensity(lowSpeedScenarios, pts, 'Bandwidth', 3);  
            plot(xi, pdf);
            strtemp = strcat('PDF for low speed');
            title("PDF for low speed scenarios [LSAEB]");
            xlabel('stop distance [cm]');
            ylabel('Probability'); 
        %HIGH SPEED
        figure()
           [pdf,xi] = ksdensity(highSpeedScenarios, pts, 'Bandwidth', 3);  
            plot(xi, pdf);
            strtemp = strcat('PDF for high speed');
            title("PDF for high speed scenarios [LSAEB]");
            xlabel('stop distance [cm]');
            ylabel('Probability');
        
        %}

%% BPCI: BINOMIAL DISTRIBUTION AND CI for success propability
% estimator for success probability - raw success probability
numBernoulli = size(T, 1);
numSuccess = size(T1,1);
numFailure = numBernoulli - numSuccess;



p_hat = numSuccess / numBernoulli;

% normal
[lowerNormalBPCI, upperNormalBPCI] = normalBPCI(p_hat, numBernoulli, confidence);
% agresti-coull
 [lowerAC_BPCI, upperAC_BPCI] = agrestiCoullBPCI(numBernoulli, numSuccess, confidence);
% beta / Jeffreys
[lowerBetaBPCI, upperBetaBPCI] = betaBPCI(numSuccess, numBernoulli, confidence);
% wilson
[lowerWilsonBPCI, upperWilsonBPCI] = wilsonBPCI(p_hat, numBernoulli, confidence);
% binom tst

% clopper pearson 
[phat,pci] = binofit(numSuccess, numBernoulli, alpha);
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
    yline(0.95, "--", "Target KPI", 'color', 'r'); %mark the target of 95
    hold on
    
    rawProbLegend = strcat("Raw Probability:", "{ }", num2str(p_hat));
    legend_BPCI = ["CI-Normal","CI-AC","CI-Beta","CI-Wilson","CI-CP",rawProbLegend, "Target KPI: 0.95"];
    legend(legend_BPCI);
    
    
    BPCIMethod = {'Normal','Agresti-Coull','Beta','Wilson','Clopper-Pearson'};
    title("confidence interval: FN Probability  [LSAEB]");
    xlabel('BPCI method');
    ylabel('Probability');
    set(gca,'xtick',[1:size(BPCIMethod, 2)],'xticklabel',BPCIMethod);
    xtickangle(45);
    ymin = 0.9;
    ymax = 1;
    ylim = [ymin, ymax];
    xmax = 6;
    axis([0 xmax ylim]);
    %yvector = 0:5:130;
    %yticks(yvector);    
    grid on;

    bpci_name{1} = strcat('./Images/BPCI', num2str(1));
    bpci_name{1} = strcat(bpci_name(1), '.png');
    picture_name = string(bpci_name{1}); 
    saveas(h,picture_name);

    %% boxplot
    
    figure()
    carProgrammes = 1;
    for i = 1:carProgrammes
    subplot(1, carProgrammes, i);
    boxplot([data], 'labels', {'L460 22MY'} ); 
    title('L460 22MY');
    ylabel('stop distance [cm]');
    xlabel('Vehicle Programme');
    end
    %save as
    saveas(gcf,"./Images/summary.png");
    
    %% another KPIs
    % Maximum longitudinal deceleration
    % Maximum jerk
    % dead time (latency): time gap between when NFS request to brake, and when the
    % car actually starts braking
    
    %% create report
    for i =1:size(pdf_name,2)
    pdfGraph{i} = string(pdf_name{i});
    TPGraph{i} = string(bpci_name{i});
    sampleDistributions{i} = string(barchart_name{i});
    end
LSAEBConfig_num = 1;
configs = ["L460"];
writeAutomaticLSAEBReport(LSAEBConfig_num, configs, sampleDistributions, pdfGraph, PDFData, TPGraph)
