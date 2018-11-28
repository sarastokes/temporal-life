% Conway basic

% Board size
N = 5;

% Iterations
nSteps = 20;

% Initial fraction set to living
initFrac = 0.5;

% Initialize the board
board = binornd(1, initFrac, [N, N]);

% Convolution kernel
kernel = [1, 1, 1; 1, 0, 1; 1, 1, 1];

% Store the steps
boardCube = board;
neighborCube = [];

% Initialize the plot
ax = axes('Parent', figure(), 'CLim', [0, 1]);
colormap(ax, 'bone');
im = imagesc(ax, board);
axis equal off
tightfig(gcf);

% Life!
for i = 1:nSteps
	oldBoard = board;
	neighbors = conv2(board, kernel, 'same');
	board(oldBoard == true & (neighbors < 2 | neighbors > 3)) = false;
	board(oldBoard == false & neighbors == 3) = true;
	% Plotting
	set(im, 'CData', board); 
	set(ax.Parent, 'Name', num2str(i));
	drawnow; pause(0.5);
	% Saving
	boardCube = cat(3, boardCube, board);
	neighborCube = cat(3, neighborCube, neighbors);
end

% Motion plot
figure(); imagesc(sum(boardCube, 3));
axis equal off
colormap(pmkmp(max(max(sum(boardCube, 3))), 'cubicl'));

% See the steps
SliceView(boardCube);
SliceView(neighborCube);
