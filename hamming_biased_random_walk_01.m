% Biased Random Walk Simulation (Upward Bias) - MATLAB Code
clear; close all; clc
% --- Parameters and Initialization ---
rng(42);  % Set random seed for reproducibility

nSteps = 240;                         % Total number of steps in the walk
biasProb = [0.5, 0.1, 0.2, 0.2];       % Probabilities for [Up, Down, Left, Right] sum to 1
biasProb = biasProb / sum(biasProb);   % Ensure they sum to 1 (normalized)

avoidRecent = 100;  % (Optional) length of recent-memory to avoid revisiting (0 to disable)
recentPositions = [];  % initialize recent positions list

% Starting position (origin)
x = 0; 
y = 0;
pathX = zeros(nSteps+1, 1); 
pathY = zeros(nSteps+1, 1);
pathX(1) = x;
pathY(1) = y;

% --- Random Walk Simulation Loop ---
for i = 1:nSteps
    % Generate a random direction based on bias probabilities
    r = rand;
    if r < biasProb(1)
        stepDir = 'up';
    elseif r < biasProb(1) + biasProb(2)
        stepDir = 'down';
    elseif r < biasProb(1) + biasProb(2) + biasProb(3)
        stepDir = 'left';
    else
        stepDir = 'right';
    end

    % Determine the next position based on chosen direction
    switch stepDir
        case 'up'
            newX = x;
            newY = y + 1;
        case 'down'
            newX = x;
            newY = y - 1;
        case 'left'
            newX = x - 1;
            newY = y;
        case 'right'
            newX = x + 1;
            newY = y;
    end

    % Optional: Avoid revisiting very recent positions 
    if avoidRecent > 0
        % If the new position is in the recent memory list, 
        % choose a different direction (re-roll) up to a few tries.
        rerollCount = 0;
        while rerollCount < 10 && ~isempty(recentPositions) && any( newX == recentPositions(:,1) & newY == recentPositions(:,2) )
            r = rand;
            if r < biasProb(1)
                stepDir = 'up';
                newX = x; newY = y + 1;
            elseif r < biasProb(1) + biasProb(2)
                stepDir = 'down';
                newX = x; newY = y - 1;
            elseif r < biasProb(1) + biasProb(2) + biasProb(3)
                stepDir = 'left';
                newX = x - 1; newY = y;
            else
                stepDir = 'right';
                newX = x + 1; newY = y;
            end
            rerollCount = rerollCount + 1;
        end
    end

    % Update the current position to the new position
    x = newX;
    y = newY;
    pathX(i+1) = x;
    pathY(i+1) = y;

    % Update recent positions memory
    if avoidRecent > 0
        recentPositions = [recentPositions; x, y];
        if size(recentPositions, 1) > avoidRecent
            % Keep only the last 'avoidRecent' entries
            recentPositions(1, :) = [];
        end
    end
end
if ~strcmp(stepDir, 'up')
    nSteps = nSteps + 1;
    pathX(nSteps) = pathX(nSteps-1);
    pathY(nSteps) = pathY(nSteps-1) + 1;
end

% --- Plotting the Path ---
fig = figure('Color', [48 51 40]/255);            % Create figure with black background
axes('Color', [48 51 40]/255);                    % Set axes background to black
plot(pathX, pathY, '-','Color',[249 195 80]/255, 'LineWidth', 0.5);  % Plot yellow line
hold on
plot(pathX(1), pathY(1), '.','Color',[249 195 80]/255, 'LineWidth', 0.5, 'MarkerSize',10)
plot(pathX(end), pathY(end), 'x','Color',[249 195 80]/255, 'LineWidth', 0.5, 'MarkerSize',5)
axis equal off;                        % Equal scaling for x and y, turn off axes/ticks

% --- Printing the figure ---
% Specify window units
set(fig, 'units', 'inches')
% Change figure and paper size
set(fig, 'Position', [0.1 0.1 6 6], 'PaperPosition', [0.1 0.1 6 6],...
    'InvertHardcopy', 'off')
print(fig, '-dpng', 'hamming_art_science_01.png', '-r1200')
disp('Random Walk done!')