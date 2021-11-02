function writeAutomaticLSAEBReport(LSAEBConfig_num, configs, sampleDistributions, PDFGraphs, PDFData, TPRate)

import mlreportgen.ppt.*
addpath(genpath('./'))
%INPUTS
Title = 'MLA LSAEB';
Subtitle = 'LSAEB KPIs';
pictureTitle = Picture(which('./Images/PictureTitle.jpg')); 
Author = "<Author>";
Role = "Subject Matter Expert";
Role_composed = compose("(" + Role + ")" + "\n");
datetype = 'datetime'; 
Date = today(datetype);
Date = datestr(Date);
%AuthorDate = [Author Role newline Date];
AuthorDate = strcat(Author, Role_composed, Date);

R = Presentation('LSAEB Report.pptx','REPORT_template.pptx');
open(R);

%% Title slide
slide = add(R,'1_Title Slide');
%find(slide.Children(1,1))
%find(slide, 'Title 1')
replace(slide,'Title 1',Title);
replace(slide, 'Subtitle 2',Subtitle); %
replace(slide.Children(1,4),AuthorDate); %'Text Placeholder 8 '
replace(slide.Children(1,3), pictureTitle); %"picture Placeholder 11"

%% CONTENT
%TODO

%% First slide
Title = "LSAEB KPIs";
Subtitle = "SUMMARY";
slide = add(R, 'Image');
picture = Picture(which('./Images/summary.png'));
replace(slide.Children(1,2),Title);
replace(slide.Children(1,3),Subtitle);
replace(slide.Children(1,1),picture);


%% SLIDE PER CONFIGURATION/VAR PROGRAMME
for i = 1:LSAEBConfig_num
    %first slide for an specific configuration -> Distribution
    slide = add(R, 'Image');
    Subtitle = 'Analyzed scenarios (Sample)';
    picture = Picture(which(sampleDistributions{i}));
    replace(slide.Children(1,2),Title);
    replace(slide.Children(1,3),Subtitle);
    replace(slide.Children(1,1),picture);
    
     %2nd slide -> TP RATE
    slide = add(R, 'Image');
    Subtitle = 'True Positive Rate';
    picture = Picture(which(TPRate{i}));
    replace(slide.Children(1,2),Title);
    replace(slide.Children(1,3),Subtitle);
    replace(slide.Children(1,1),picture);
    %3rd slide -> PDF
    slide = add(R, 'PDF_slide');
    Subtitle = 'PDF';
    
    text_mean = strcat("mean: ", num2str(PDFData{i}.mean), " cm");
    text_stddev = strcat("std deviation: ", num2str(PDFData{i}.stddev), " cm");
    text_dist = strcat("distribution: ", string(PDFData{i}.distribution));
    text_mode1 = strcat("mode 1: ", num2str(PDFData{i}.mode1), " cm");
    text_mode2 = strcat("mode 2: ", num2str(PDFData{i}.mode2), " cm");
    
    text_colProbEVT = strcat("Collision Prob (EVT): ", num2str(PDFData{i}.CollisionProbEVT), " %");
    text_colProbRaw = strcat("Collision Prob: ", num2str(PDFData{i}.CollisionProbRaw), " %");
    text_nuisanceProbEVT = strcat("Nuisance stop Prob (EVT): ", num2str(PDFData{i}.NuisanceProbEVT), " %");
    text_nuisanceProbRaw = strcat("Nuisance stop Prob: ", num2str(PDFData{i}.NuisanceProbRaw), " %");
    
    if (strcmp("bimodal", PDFData{i}.distribution))
        text_data = text_mean + '\n' + text_stddev + '\n' + text_dist + '\n' + text_mode1 + '\n' + text_mode2 + ...
            '\n' + text_colProbEVT + '\n'+ text_colProbRaw + '\n'+ text_nuisanceProbEVT + '\n' + text_nuisanceProbRaw;
    else
        text_data = text_mean + '\n' + text_stddev + '\n' + text_dist + ...
            '\n' + text_colProbEVT + '\n'+ text_colProbRaw + '\n'+ text_nuisanceProbEVT + '\n' + text_nuisanceProbRaw;
    end
    
    text_data = compose(text_data);
    p = Paragraph();
    textObj = Text(text_data);
    textObj.Style = {FontSize('11pt'), Bold(false), FontColor('black')};
    append(p,textObj);
    picture = Picture(which(PDFGraphs{i}));
    replace(slide.Children(1,2),Title);
    replace(slide.Children(1,3),Subtitle);
    replace(slide.Children(1,1),picture);
    replace(slide.Children(1,4),p);
    

end

%% Comparison slides
if(LSAEBConfig_num >= 2)
% TP RATE Comparison
    slide = add(R, 'Image');
    Subtitle = "TP Rate Comparison";
    picture = Picture(which('./Images/TPRateComparison.png'));
    replace(slide.Children(1,2),Title);
    replace(slide.Children(1,3),Subtitle);
    replace(slide.Children(1,1),picture);
% Prob late activation comparison
    slide = add(R, 'Image');
    Subtitle = "Prob late activation Comparison";
    picture = Picture(which('./Images/EVTProbComparison_config.png'));
    replace(slide.Children(1,2),Title);
    replace(slide.Children(1,3),Subtitle);
    replace(slide.Children(1,1),picture);
end
%% FINAL SLIDE THANK YOU
 slide = add(R, 'Thank You');
 txt1 = Author + "\n";
 email = "<author>@jaguarlandrover.com";
 txt2 =  Role + "\n" + "\n" + email;
 txt1 = compose(txt1);
 txt2 = compose(txt2);
 
 textObj1 = Text(txt1);
 textObj2 = Text(txt2);
 textObj1.Style = {FontSize('11pt') , Bold(true), FontColor('black')};  
 textObj2.Style = {FontSize('9pt'), Bold(false), FontColor('black'), FontFamily('JLR Emeric ExtraLight')};
 p = Paragraph(textObj1); %append(p,textObj1);
 append(p,textObj2);

replace(slide.Children(1,2),p);

txt1 = "Thank You";
textObj1 = Text(txt1);
p2 = Paragraph(textObj1);
replace(slide.Children(1,1),p2);
%% 
close(R);
pptview(R.OutputPath)