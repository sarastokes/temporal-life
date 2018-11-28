classdef SliceView < handle
    % SLICEVIEW
    %
    % Description:
    %   Simple viewer for 3D matrices. Use the left and right arrow keys to
    %   move along the third dimension.
    %
    % Constructor:
    %   obj = SliceView(block, showColorbar);
    %
    % Inputs:
    %   block           Array with 3 dimensions, first 2 displayed
    %   showColorbar    Default = false
    %   
    % ---------------------------------------------------------------------
    
    properties (SetAccess = private)
        block
        stepNum
        axHandle
        imHandle
    end
    
    methods
        function obj = SliceView(block, showColorbar)
            assert(ndims(block) == 3, 'Input 3D array');
            
            if nargin < 2
                showColorbar = false;
            end
            
            obj.block = block;
            obj.stepNum = 1;
            
            obj.createUI(showColorbar);
        end
    end
    
    methods (Access = private)       
        function setTitle(obj)
            set(obj.axHandle.Parent, 'Name', ['Step ', num2str(obj.stepNum)]);
        end
        
        function setPlot(obj, N)
            set(obj.imHandle, 'CData', obj.block(:, :, N));
        end
        
        function stepUp(obj)
            if obj.stepNum == size(obj.block, 3)
                return;
            end
            obj.setPlot(obj.stepNum+1);
            obj.stepNum = obj.stepNum + 1;
            obj.setTitle();
        end
        
        function stepDown(obj)
            if obj.stepNum == 1
                return;
            end
            obj.setPlot(obj.stepNum - 1);
            obj.stepNum = obj.stepNum - 1;
            obj.setTitle();
        end
        
        function onKeyPress(obj, ~, evt)
            switch evt.Character
                case 28 
                    obj.stepDown();
                case 29
                    obj.stepUp();
            end
            
        end
        
        function createUI(obj, showColorbar)
            figHandle = figure(...
                'Menubar', 'none',...
                'Toolbar', 'none',...
                'NumberTitle', 'off',...
                'Color', 'w',...
                'KeyPressFcn', @obj.onKeyPress);          
            
            obj.axHandle = axes('Parent', figHandle);
            obj.setTitle();
            
            obj.imHandle = imagesc(obj.axHandle, obj.block(:, :, 1));             
            set(obj.axHandle, 'CLim',...
                [min(min(min(obj.block))), max(max(max(obj.block)))]);
            hold(obj.axHandle, 'on');
            if max(max(max(obj.block))) > 1
                colormap(figHandle, pmkmp(max(max(max(obj.block))), 'cubicl'));
            else
                colormap(figHandle, [1, 1, 1; 0.2, 0.3, 0.9]);
            end
            if showColorbar
                colorbar('Ticks', []);
            end
            
            axis(obj.axHandle, 'equal', 'off');
            
            %tightfig(figHandle);            
        end
    end
    
end