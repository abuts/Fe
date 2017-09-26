classdef cut_id
    % Helper class generating a number, which uniquely defines bragg index
    % and cut direction or restores bragg index and cut direction from this
    % number.
    %
    % The id-s are uniquely defined for bragg indexes in -10+10 range.
    % [-10 +99]?
    properties(Constant,Access=private)
        bragg_base_ = [10,10,10,10];
    end
    methods(Static)
        function id = get_id(varargin)
            % id from bragg index and direction number
            if nargin == 1
                arr = varargin{1};
                
            else
                arr = [varargin{1},varargin{2},varargin{3},varargin{4}];
            end
            arr = arr + cut_id.bragg_base_;
            id = (10000*arr(1)+100*arr(2) +arr(3))*100+arr(4);
        end
        function varargout = id_to_bragg(id)
            res = zeros(1,4);
            all_bragg = floor(id/100);
            res(4) = id - all_bragg*100;
            hk = floor(all_bragg/100);
            res(3)  = all_bragg-hk*100;
            res(1)  = floor(hk/100);
            res(2)  = hk-res(1)*100;
            res = res - cut_id.bragg_base_;
            if nargout ==1
                varargout{1}=res;
            elseif nargout == 4
                varargout{1}=res(1); %h
                varargout{2}=res(2); %k;
                varargout{3}=res(3); %l;
                varargout{4}=res(4); %dir;
            else
                error('CUT_ID:invalid_argument',...
                    ' id_to_bragg method should have 1 or 4 outputs');
            end
        end
        
        
    end
end
