classdef EnCutBlock
    % The auxiliary class to work with a block of equivalent cuts and
    % store/restore sequence of these cuts to hdd
    %
    properties
        fits_list;
        fit_param;
    end
    properties(Dependent)
        cuts_list
        cut_energies
        % name of the cuts file
        filename
    end
    properties(Constant,Access=private)
        out_template_ = struct('cut_list',[],'w1D_arr1_tf',...
            [],'fp_arr1',[],'es_valid',[]);
    end
    properties(Access=private)
        cut_energies_;
        cuts_list_;
        filename_;
    end
    
    methods
        function obj = EnCutBlock(varargin)
            % Inputs:
            % cuts_list
            % fits_list
            % fit_parameters
            % Or:
            % old fashioned en_cuts structure
            %
            %
            if nargin>0
                if isstruct(varargin{1})
                    if nargin ==2
                        keep_only = false(size(varargin{1}.cut_list));
                        keep_only(varargin{2}) = true;
                        select = true;
                    else
                        keep_only = true(size(varargin{1}.cut_list));
                        select = false;
                    end
                    obj.cuts_list = varargin{1}.cut_list(keep_only);
                    obj.fits_list = varargin{1}.w1D_arr1_tf(keep_only);
                    if select
                        obj.fit_param   = select_fitpar(varargin{1}.fp_arr1,keep_only);
                    else
                        obj.fit_param   = varargin{1}.fp_arr1;
                    end
                    obj.cut_energies_ = ...
                        EnCutFormat.get_en_list(varargin{1});
                elseif isa(varargin{1},'EnCutBlock')
                    if nargin == 2
                        obj = varargin{1}.select_fitpar(varargin{2});
                    else
                        obj = varargin{1};
                    end
                    
                else
                    obj.cuts_list = varargin{1};
                    obj.fits_list = varargin{2};
                    obj.fit_param     = varargin{3};
                    obj.cut_energies_ = ...
                        obj.get_en_list(varargin{1});
                end
            end
        end
        %
        function en = get.cut_energies(obj)
            en = obj.cut_energies_;
        end
        % name of the cuts file
        function fn = get.filename(obj)
            fn = obj.filename_;
        end
        function obj = set.filename(obj,val)
            obj.filename_ = val;
        end
        
        function [obj,out]=save(obj,filename)
            out = obj.out_template_;
            
            out.cut_list = obj.cuts_list;
            out.w1D_arr1_tf = obj.fits_list;
            out.fp_arr1 = obj.fit_param;
            out.es_valid  = obj.cut_energies;
            if ~exist('filename','var')
                filename = obj.filename;
            else
                obj.filename_ = filename;
            end
            fld_names = fieldnames(out);
            save(filename,'-struct','out',fld_names{:});
        end
        function cl = get.cuts_list(obj)
            cl = obj.cuts_list_;
        end
        function obj = set.cuts_list(obj,val)
            obj.cuts_list_ = val;
            obj.cut_energies_ = EnCutBlock.get_en_list(val);
        end
        
        function cp = select_fitpar(obj,selection)
            cp = EnCutBlock();
            cp.cuts_list_ = obj.cuts_list(selection);
            cp.fits_list =  obj.fits_list(selection);
            cp.fit_param   = select_fitpar(obj.fit_param,selection);
            cp.cut_energies_ = ...
                EnCutBlock.get_en_list(cp.cuts_list);
            cp.filename_  = obj.filename_;
        end
        
        
    end
    methods(Static)
        function en_list = get_en_list(cut_list)
            en_list= arrayfun(@(x)(0.5*(x.data.iint(2,3)+x.data.iint(1,3))),...
                cut_list);
        end
        function obj=load(filename)
            ld = load(filename);
            obj = EnCutBlock();
            obj.cuts_list =ld.cut_list;
            obj.fits_list =ld.w1D_arr1_tf;
            obj.fit_param =   ld.fp_arr1;
            [~,fn,~] = fileparts(filename);
            obj.filename_ = fn;
        end
        
    end
    
end

