%% CONWAY GAME OF LIFE DEMO #2
% - Adding wrapped board

%% Parameters
% Board size
N = 10;

% Iterations
nSteps = 50;

% Initial fraction set to living
initFrac = 0.25;

% Convolution kernel
kernel = [1, 1, 1; 1, 0, 1; 1, 1, 1];

%% Initialize random board
board = binornd(1, initFrac, [N, N]);
%% Initialize specific board
board = zeros(11,11);
board(6, [5, 7]) = 1;
board([4:5, 7:8], 6) = 1;
%% Game of life!
% Store the steps
boardCube = board;
neighborCube = [];

% Initialize the plot
ax = axes('Parent', figure('NumberTitle', 'off'), 'CLim', [0, 1]);
im = imagesc(ax, board);
hold(ax, 'on'); axis equal off;
colormap(ax, [1, 1, 1; 0.2, 0.3, 0.9]);
tightfig(gcf);

% Life!
for i = 1:nSteps
	oldBoard = board;
    if nnz(oldBoard) == 0
        fprintf('Terminated on iteration %u\n', i);
        break
    end
	neighbors = conv2(padarray(board, [1,1], 'circular', 'both'), kernel, 'same');
	neighbors = neighbors(2:end-1, 2:end-1);
	board(oldBoard == true & (neighbors < 2 | neighbors > 3)) = false;
	board(oldBoard == false & neighbors == 3) = true;
	% Plotting
	set(im, 'CData', board); 
	set(ax.Parent, 'Name', num2str(i));
	drawnow; pause(0.2);
	% Saving
	boardCube = cat(3, boardCube, board);
	neighborCube = cat(3, neighborCube, neighbors);
end

%% Motion plot
figure(); imagesc(sum(boardCube, 3));
axis equal off
colormap(pmkmp(max(max(sum(boardCube, 3))), 'cubicl'));

%% See the steps
SliceView(boardCube);
%% See the neighbors
SliceView(neighborCube, true);
