% Add paths to necessary directories
addpath '~/Thesis-2024/Thesis-2024/Data/downloaded_videos/'
addpath '~/Helper/June01/'
addpath '~/Helper/matlabPyrTools-master/'
addpath '~/IJRM_visual_complexity-main/Complexity/'
addpath '~/IJRM_visual_complexity-main/Alternative_Complexity/'
addpath '~/IJRM_visual_complexity-main/Helper/SFFCMCode/SFFCMCode/'
addpath '~/Thesis-2024/Thesis-2024/'

% Specify video file
video = '/Thesis-2024/Thesis-2024/This is Off the Wall.mp4';
v = VideoReader(video);

% Calculate the interval for sampling 30 frames evenly across the video
totalFrames = floor(v.Duration * v.FrameRate);
interval = floor(totalFrames / 30);  % Divide by 29 to ensure 30 frames are sampled

% Initialize variables to sum the metrics
sumLc = 0;
sumCc = 0;
sumEd = 0;
sumAh = 0;
sumAv = 0;
sumIrv = 0;
frameProcessed = 0;
frameCount = 0;

% Loop through frames, sampling at calculated intervals
while hasFrame(v)
    frame = readFrame(v);
    frameCount = frameCount + 1;
    
    % Process frames at intervals
    if mod(frameCount, interval) == 1 || frameCount == 1
        % Process the frame
        sumLc = sumLc + luminance_complexity(frame);
        sumCc = sumCc + colorfulness(frame);
        sumEd = sumEd + edge_density(frame);
        [ah, av, irv] = arrangement(frame);
        sumAh = sumAh + ah;
        sumAv = sumAv + av;
        sumIrv = sumIrv + irv;
        
        frameProcessed = frameProcessed + 1;
        if frameProcessed >= 30
            break;
        end
    end
end

% Calculate means of each metric
meanLc = sumLc / frameProcessed;
meanCc = sumCc / frameProcessed;
meanEd = sumEd / frameProcessed;
meanAh = sumAh / frameProcessed;
meanAv = sumAv / frameProcessed;
meanAs = (meanAh+meanAv)/2;
meanIrv = sumIrv / frameProcessed;

% Create data table with headers and values
resultsHeader = {'Video Name', 'Luminance Complexity', 'Color Complexity', 'Edge Density', 'Asymmetry Horizontal', 'Asymmetry Vertical', 'Irregularity of Object Arrangement'};
results = {video, meanLc, meanCc, meanEd, meanAh, meanAv, meanIrv};

% Combine headers and values in a single table
finalResultsTable = cell2table(results, 'VariableNames', resultsHeader);

% Display or save the table as needed
disp(finalResultsTable);
% Optionally save the table to a file
writetable(finalResultsTable, 'video_analysis_results.csv');