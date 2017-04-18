% University of British Columbia, Vancouver, 2017
%   Dr. Guy Nir
%   Shahriar Noroozi Zadeh
%   Amir Refaee
%   Lap-Tak Chu

close all; clear; clc  %#ok<*UNRCH>

global TRAIN_PATH TEST_PATH  RESULTS_PATH; 

TRAIN_PATH   = 'data/slides/SlidesTrainBright/';


if exist('RunTimeInfo.txt', 'file')
        [oldPath,~] = RunTimeInformation([],[],'r',0,0,0);
end
[~, NumSVSslides, ~] = RunTimeInformation(TRAIN_PATH,TEST_PATH,'w',...
                                           128, 128, 1);

%feature Selection and pre-processing
processSlides = false;
if (processSlides)
    for i=1:NumSVSslides
        brain_slide_process;
    end
    %SaveFigures('/Train Slide Process');
end

processTestSlides = true;
if (processTestSlides)
    brain_slide_process_test;
    %SaveFigures('/Test Slide Process');
end


%classification
isTesting = true;
isTrained = false;
if isTesting
    if ~isTrained
        brain_slide_train_test;
        isTrained = false; SaveResultsTesting;  %#ok<NASGU>
    end
    
    brain_slide_classify_test;
    isTrained = true; SaveResultsTesting;
    %SaveMatFiles('test');
else
    %classification and cross-validation
    brain_slide_classify;
    SaveResults;
end

%save figures results
%SaveMatFiles('train');
%SaveFigures('/Slide Classification');

%make interface
isInterfacing = true;
if isInterfacing
    InterfaceOutput;
end