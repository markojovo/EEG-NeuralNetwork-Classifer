%{
README:
Physionet SVM trained binary classification code
Author: Marko Jovanovic
        markoj285@gmail.com
        Last Updated: Dec 3, 2020
Use: 
Requires Physionet EEG dataset https://physionet.org/content/eegmmidb/1.0.0/
superfolder, titled "EEGdatasets"

Example dataset name format required: 'EEGdatasets\S003\S003R08.edf'

Main Code:
Proj1Code.m

Functions:
Eventread.m
ImportEvents.m
GetFileName.m
SVMFF.m

To train: Uncommment weight and bias random intialization and training code block
To Test: Comment out weight and bias random intialization and training code block
%}






clc
clear
addpath('M:\MATLAB\eeglab2020_0') % Change to include your EEGLAB path
eeglab nogui
warning('off')
channelList = [32 34 36 9 11 13 49 58 53 ]; %Choose channel numbers here
possibleClasses = 4+1; % Left Fist, Right Fist, Both Fists, Both Feet
totRuns = 14; %14 total, Only looking at first 2, which are "Baseline Eyes Open" and "Baseline Eyes Closed" in run number 1 and 2 respectively
totSpecimens = 109  ; %109 total
MLINPUTSIZE = length(channelList)*4+1; %4 features x 9 channels
totScore = 0; % Score for tracking Accuracy
trackedTrialNum = 0;
NNnodeNumbers = [24,18]+1;
trainingRate = 0.05;
%NN Weights Initialize %%%%%%%%%%%%%%%%
for i=1:length(NNnodeNumbers)
   if i == 1
       layerWeights = {rand([MLINPUTSIZE NNnodeNumbers(1)])};
       layerWeights(2) = {rand([NNnodeNumbers(1) NNnodeNumbers(2)])};
   elseif i == length(NNnodeNumbers)
       layerWeights(i+1) = {rand([NNnodeNumbers(i) possibleClasses])-0.5};
   else
       layerWeights(i+1) = {rand([NNnodeNumbers(i) NNnodeNumbers(i+1)])-0.5}; 
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


trialNum = 0;
ErrorValues = [];
ErrorPercent = [];
correctSum = 0;
maxAcc = 0;
maxAccRun = 0;
for specNum = 1:totSpecimens
    for runNum = 1:totRuns
        if runNum == 1 || runNum == 2
            'Baseline, skipped'
            continue
        end
        trialNum = trialNum + 1;
        specNum
        runNum
        %for example:  brainData = 'S038R08.edf'; 
        brainData = getFileName(specNum, runNum);
        EEG = pop_biosig(brainData);

        %PREPROCESS EEG DATA USING EEGLAB HERE
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'hicutoff',50);
        %DONE PREPROCESS
        
        
        %Extract Event-type labelled epoch (event labels not used in SVM)
        sampleRate = EEG.srate;
        EEGdata = EEG.data';
        EEGtimes = EEG.times';
        EEGevent = ImportEvents(brainData,EEG);
        if EEGevent == -1
           'Bad Dataset, Rejected'
           continue
        end
        [numEvents, ~] = size(EEGevent);
        for i=1:numEvents
            thisSample = EEGevent(i,2);
            nextSample = length(EEGtimes);
            if i < numEvents
                if numEvents>1
                    nextSample = EEGevent(i+1,2);
                end
            end

            %Inputs to be processed
            thisEpoch = EEGdata(thisSample:nextSample,1:end);
            thisEpochSelectChannels = thisEpoch(1:end,channelList(1:end));
            thisEventType = EEGevent(i,1);
            
            %Feature Extraction using:  thisEpochSelectChannels
            RMSvec = rms(thisEpochSelectChannels(1:end,1:end));
            MAVvec = mean(abs(thisEpochSelectChannels(1:end,1:end)));
%   (BAD)                     INTEGvec = sum(abs(thisEpochSelectChannels(1:end,1:end)));
%   (BAD)                     SQINTEGvec = sum(abs(thisEpochSelectChannels(1:end,1:end)).^2);
            MAVSQvec = mean(abs(thisEpochSelectChannels(1:end,1:end)).^2)/100;
            VARvec = var(thisEpochSelectChannels(1:end,1:end))/100;
%   (Not Implemented)         MAVSLOPEvec = [0 0 0];%Mean Absolute Value Slope (be sure to adjust size)
%   (Not Implemented)         WAVEFORMLENGTHvec = [0 0 0]; %Waveform Length (be sure to adjust size)
            
            
            MLinput = [RMSvec; MAVvec; MAVSQvec; VARvec];
            MLinput = MLinput(:)/100; %roughly normalize input
            NNinput = [1 MLinput'];
            
  
            outputVec = zeros(1,possibleClasses);
            outputVec(1) = 1;
            % [bias LeftFist RightFist BothFists BothFeet]
            if thisEventType == 1
                if runNum == 3 || runNum == 4 || runNum == 7 || runNum == 8 || runNum == 11 || runNum == 12
                    outputVec(2) = 1; %Left Fist
                end
                
                if runNum == 5 || runNum == 6 || runNum == 9 || runNum == 10 || runNum == 13 || runNum == 14
                   outputVec(4) = 1; %Both Fists
                end
                
            else if thisEventType == 2
                if runNum == 3 || runNum == 4 || runNum == 7 || runNum == 8 || runNum == 11 || runNum == 12
                   outputVec(3) = 1; %Right Fist     
                end
                
                if runNum == 5 || runNum == 6 || runNum == 9 || runNum == 10 || runNum == 13 || runNum == 14
                   outputVec(5) = 1; %Both Feet
                end
            end  
%                 if runNum == 1
%                    outputVec(2) = 1; 
%                 end
%                 
%                 if runNum == 2
%                    outputVec(3) = 1;
%                 end
          

           

% Training Code Start NN
    if thisEventType == 2 || thisEventType == 1
    if  specNum<=10
        layerWeights = NNbackProp2(NNinput,outputVec, layerWeights, trainingRate);
    end
    neuroOutput = NNFF2(NNinput, layerWeights);
    [~,I] = max(neuroOutput(2:end));
    tempVec = zeros(1,possibleClasses);
    tempVec(I+1) = 1;
    tempVec(1) = 1;
    rightWrong = tempVec - outputVec;   
    if specNum >= 10
        trackedTrialNum = trackedTrialNum + 1;
    end
%     correctSum = correctSum - 1;
    if (sum(rightWrong) == 0) && (specNum>=10)
       correctSum = correctSum + 1; 
    end    
    
    f = abs(neuroOutput-outputVec);
    ErrorValues = [ErrorValues sum(f(2:end))];
    ErrorPercent = [ErrorPercent correctSum/trackedTrialNum];
% Training Code End NN
    end
            end
        end    
    end

        
end
hold on
plot(ErrorValues);
plot(ErrorPercent);
warning('on')
