%% Sara Patterson - 18Nov2018
% Machine Intelligence Final Project Proposal
% -------------------------------------------------------------------------
% Set to true to watch simulation as the sum of live cell locations 
% through time
timeView = false;

% Set to true to begin with pi heptomino, otherwise random
initPiHetomino = false;

% Worth seeing all 4 combinations of timeView and initPiHeptomino

%% Simulation parameters
% Board size
N = 100;

if initPiHetomino
	% Good number of generations:
	nSteps = 200;
else
	% Initial fraction set to living
	initFrac = 0.15;
	% Number of generations
	nSteps = 100;
end

%% Initialize
if initPiHetomino
	board = sparse(N, N);
	board(49:51, 49) = 1;
	board([49, 51], [50, 51]) = 1;
else
	board = sparse(binornd(1, initFrac, [N, N]));
end

% Store the steps
boardCube = full(board);

% Initialize the plot
ax = axes('Parent', figure('NumberTitle', 'off'), 'CLim', [0, 1]);
im = imagesc(ax, board);
hold(ax, 'on'); axis equal off;
if timeView
	colormap(parula);
else
	colormap(ax, [1, 1, 1; 0.2, 0.3, 0.9]);
end

%% Life!

% Neighbor arrays
p = [1, 1:N-1];
q = [2:N, N];

% Run the simulation
for i = 1:nSteps
	X = board;
    if nnz(X) == 0
        fprintf('Terminated on iteration %u\n', i);
        break
    end

    % Get the neighbors
    Y = X(:, p) + X(:, q) + X(p, :) + X(q,:) + ...
        X(p, p) + X(q, q) + X(p, q) + X(q, p);

    % Find the next board
    board = (X & (Y == 2) | (Y == 3));
    
	% Storing
	boardCube = cat(3, boardCube, full(board));

	% Plotting
	if timeView
		set(im, 'CData', sum(boardCube, 3));
	else
		set(im, 'CData', board); 
	end
	set(ax.Parent, 'Name', num2str(i));
	drawnow; pause(0.05);
end

%% Time plot
figure(); 
if initPiHetomino
	imagesc(log10(sum(boardCube, 3)));
	colormap(flipud(bone));
else
	imagesc(sum(boardCube, 3));
	colormap(parula);
end
axis equal off
