%% CONWAY GAME OF LIFE DEMO #3
% - Converting to sparse matrices

%% Parameters
% Board size (larger 
N = 100;

% Iterations
nSteps = 200;

% Initial fraction set to living
initFrac = 0.15;

% Neighbor arrays
p = [1, 1:N-1];
q = [2:N, N];

%% Initialize random board
board = sparse(binornd(1, initFrac, [N, N]));

%% Initialize set board
board = sparse(N, N);
board(49:51, 49) = 1;
board([49, 51], [50, 51]) = 1;
nSteps = 200;

%% Game of life!
% Store the steps
boardCube = full(board);
neighborCube = [];

% Initialize the plot
ax = axes('Parent', figure('NumberTitle', 'off'), 'CLim', [0, 1]);
im = imagesc(ax, board);
hold(ax, 'on'); axis equal off;
colormap(ax, [1, 1, 1; 0.2, 0.3, 0.9]);
tightfig(gcf);

% Life!
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
    
	% Plotting
	set(im, 'CData', board); 
	set(ax.Parent, 'Name', num2str(i));
	drawnow; pause(0.1);
    
	% Saving
	boardCube = cat(3, boardCube, full(board));
	neighborCube = cat(3, neighborCube, full(Y));
end

%% Motion plot
figure(); imagesc(sum(boardCube, 3));
axis equal off
colormap(pmkmp(max(max(sum(boardCube, 3))), 'cubicl'));
tightfig(gcf);
%% Alternate motion plot
figure(); imagesc(log10(sum(boardCube, 3)));
axis equal off;
colormap(flipud(bone));
%colormap(pmkmp(max(max(sum(boardCube, 3))),'cubicl'));
tightfig(gcf);
%% Log2 motion plot
figure(); imagesc(log2(sum(boardCube, 3)));
axis equal off
colormap(pmkmp(max(max(sum(boardCube, 3))), 'cubicl'));
tightfig(gcf);
%% See the steps
SliceView(boardCube);
%% See the neighbors
SliceView(neighborCube, true);
