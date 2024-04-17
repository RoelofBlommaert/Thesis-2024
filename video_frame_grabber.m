% Add necessary directories to the path
addpath 'Data/downloaded_videos/'
addpath 'Helper/June01/'
addpath 'Helper/matlabPyrTools-master/'
addpath 'IJRM_visual_complexity/Complexity/'
addpath 'IJRM_visual_complexity/Alternative_Complexity/'
addpath 'IJRM_visual_complexity/Helper/SFFCMCode/SFFCMCode/'

% Read the data table
dataTable = readtable('Data/complexity_and_variety_scores.csv');

% Calculate percentiles for each variable
percentiles = struct();
variables = {'LuminanceComplexity', 'ColorComplexity', 'EdgeDensity', 'AsymmetryOfObjectArrangement', 'IrregularityOfObjectArrangement'};
for var = variables
    percentiles.(var{1}) = prctile(dataTable{:, var{1}}, [25 50 75]);
end

% Prepare to store the closest frames for each percentile of each variable
closestFrames = struct();
for var = variables
    for p = {'P25', 'P50', 'P75'}
        closestFrames.(var{1}).(p{1}) = struct('VideoName', '', 'FrameIndex', 0, 'Score', Inf, 'Diff', Inf);
    end
end

% Define the directory containing videos
videoDir = 'Data/downloaded_videos/';
videoFiles = dir(fullfile(videoDir, '*.mp4'));

% Process only the first 5 videos
numVideos = 20;

% Loop through each video
for k = 1:numVideos
    videoPath = fullfile(videoFiles(k).folder, videoFiles(k).name);
    v = VideoReader(videoPath);
    totalFrames = floor(v.Duration * v.FrameRate);
    interval = floor(totalFrames / 30);

    % Loop through 30 evenly spaced frames
    for j = 1:30
        frameIdx = round((j - 1) * interval + 1);
        if frameIdx <= totalFrames
            v.CurrentTime = (frameIdx - 1) / v.FrameRate;
            frame = readFrame(v);
            
            % Calculate and evaluate each metric
            for var = variables
                score = evaluateMetric(frame, var{1});
                for pi = 1:3 % For each percentile (25, 50, 75)
                    percentileScore = percentiles.(var{1})(pi);
                    diff = abs(score - percentileScore);
                    pField = ['P', num2str(pi * 25)];
                    if diff < closestFrames.(var{1}).(pField).Diff
                        closestFrames.(var{1}).(pField) = struct('VideoName', videoFiles(k).name, 'FrameIndex', frameIdx, 'Score', score, 'Diff', diff);
                    end
                end
            end
        end
    end
end

% Save the closest frames and show results
% Save the closest frames and show results
for var = variables
    for p = {'P25', 'P50', 'P75'}
        frameInfo = closestFrames.(var{1}).(p{1});
        fprintf('Best frame for %s at %s: %s Frame %d, Score: %.2f\n', var{1}, p{1}, frameInfo.VideoName, frameInfo.FrameIndex, frameInfo.Score);
        videoPath = fullfile(videoDir, frameInfo.VideoName);
        if exist(videoPath, 'file')
            v = VideoReader(videoPath);
            v.CurrentTime = (frameInfo.FrameIndex - 1) / v.FrameRate;
            frame = readFrame(v);
            imshow(frame); % Display frame for visual confirmation
            frameFileName = sprintf('%s_%s_%s.jpg', var{1}, p{1}, erase(frameInfo.VideoName, '.mp4'));
            frameFileFullPath = fullfile('output_frames', frameFileName);
            imwrite(frame, frameFileFullPath); % Save the frame with detailed naming
            disp(['Frame saved as: ', frameFileFullPath]); % Display save path
        else
            disp(['Video not found: ' videoPath]);
        end
    end
end

function score = evaluateMetric(frame, metric)
    switch metric
        case 'LuminanceComplexity'
            score = luminance_complexity(frame);
        case 'ColorComplexity'
            score = colorfulness(frame);
        case 'EdgeDensity'
            score = edge_density(frame);
        case 'AsymmetryOfObjectArrangement'
            [ah, av, ~] = arrangement(frame);
            score = mean([ah, av]);
        case 'IrregularityOfObjectArrangement'
            [~, ~, score] = arrangement(frame);
    end
end