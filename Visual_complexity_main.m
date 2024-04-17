% Add paths to necessary directories
addpath 'Data/downloaded_videos/'
addpath 'Helper/June01/'
addpath 'Helper/matlabPyrTools-master/'
addpath 'IJRM_visual_complexity/Complexity/'
addpath 'IJRM_visual_complexity/Alternative_Complexity/'
addpath 'IJRM_visual_complexity/Helper/SFFCMCode/SFFCMCode/'

% Define the directory containing videos
videoDir = 'Data/downloaded_videos/';
videoFiles = dir(fullfile(videoDir, '*.mp4'));  % Ensure files are being found

if isempty(videoFiles)
    error('No video files found. Check the directory path and file extensions.');
end

% Preallocate a cell array for storing results
numVideos = length(videoFiles);
resultsData = cell(numVideos, 6);  % Ensure this matches the number of metrics

% Loop through each video file
for k = 1:numVideos
    videoPath = fullfile(videoFiles(k).folder, videoFiles(k).name);
    v = VideoReader(videoPath);

    fprintf('Processing %s\n', videoPath);  % Debug: output which file is being processed

    if ~hasFrame(v)
        warning('No frames in %s. Skipping this video.', videoPath);
        continue;
    end

    % Calculate the interval for sampling 30 frames evenly across the video
    totalFrames = floor(v.Duration * v.FrameRate);
    interval = floor(totalFrames / 30);  % Adjust if not correct

    % Initialize sum variables
    sumLc = 0; sumCc = 0; sumEd = 0; sumAh = 0; sumAv = 0; sumIrv = 0;
    frameProcessed = 0; frameCount = 0;

    % Loop through frames, sampling at calculated intervals
    while hasFrame(v)
        frame = readFrame(v);
        frameCount = frameCount + 1;

        if mod(frameCount, interval) == 1 || frameCount == 1
            % Debug: Check if this part of the loop is executing
            fprintf('Analyzing frame %d of %s\n', frameCount, videoPath);

            % Simulate the function calls and processing
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

    % Store results if any frames were processed
    if frameProcessed > 0
        [~, name, ~] = fileparts(videoPath);
        resultsData{k, 1} = name;
        resultsData{k, 2} = sumLc / frameProcessed;
        resultsData{k, 3} = sumCc / frameProcessed;
        resultsData{k, 4} = sumEd / frameProcessed;
        resultsData{k, 5} = ((sumAh + sumAv) / 2) / frameProcessed;
        resultsData{k, 6} = sumIrv / frameProcessed;
    else
        fprintf('No frames were processed for %s. Check interval calculation and frame conditions.\n', videoPath);
    end
end

% Convert the cell array to a table
resultsHeader = {'Video Name', 'Luminance Complexity', 'Color Complexity', 'Edge Density', 'Asymmetry of Object Arrangement', 'Irregularity of Object Arrangement'};
finalResultsTable = cell2table(resultsData, 'VariableNames', resultsHeader);

% Display the final table
disp(finalResultsTable);

% Optionally save the table to a CSV file
writetable(finalResultsTable, 'video_analysis_complexity_results.csv');
