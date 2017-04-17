% University of British Columbia, Vancouver, 2017
%   Dr. Guy Nir
%   Shahriar Noroozi Zadeh
%   Amir Refaee
%   Lap-Tak Chu

%close all; clear; clc  %#ok<*UNRCH>

function [] = brain_analysis(impath,interpath)

    if exist('RunTimeInfo.txt', 'file')
            [oldPath,~] = RunTimeInformation([],[],'r',0,0,0);
    end

    [~, NumSVSslides, ~] = RunTimeInformation('..data/slides/SlidesTrainBright/','..data/slides/SlidesTest/','w',...
                                               128, 128, 1);

    %feature Selection and pre-processing
%     processSlides = false;
%     if (processSlides)
%         for i=1:NumSVSslides
%             brain_slide_process;
%         end
%         SaveFigures('/Train Slide Process');
%     end

    processTestSlides = true;
    if (processTestSlides)
        close all;
        brain_slide_process_test;
        SaveFigures('/Test Slide Process');
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
        SaveMatFiles('test');
    else
        %classification and cross-validation
        brain_slide_classify;
        SaveResults;
    end

    %save figures results
    SaveMatFiles('train');
    SaveFigures('/Slide Classification');

    %make interface
    isInterfacing = false;
    if isInterfacing
        InterfaceOutput;
    end
    
end