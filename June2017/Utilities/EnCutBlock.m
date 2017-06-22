classdef EnCutBlock
    % The auxiliary class to work with a block of equivalent cuts and
    % store/restore sequence of these cuts to hdd
    %
    properties
        cuts_list
        fits_list;
        fit_param;
    end
    properties(Dependent)
        cut_energies
    end
    properties(Constant,Access=private)
        out_template_ = struct('cut_list',[],'w1D_arr1_tf',...
            [],'fp_arr1',[],'es_valid',[]);
    end
    properties(Access=private)
        cut_energies_;
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
                    obj.cuts_list = varargin{1}.cut_list;
                    obj.fits_list = varargin{1}.w1D_arr1_tf;
                    obj.fit_param   = varargin{1}.fp_arr1;
                    obj.cut_energies_ = ...
                        EnCutFormat.get_en_list(varargin{1});
                    
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
        function out=save(obj,filename)
            out = obj.out_template_;
            
            out.cut_list = obj.cuts_list;
            out.w1D_arr1_tf = obj.fits_list;
            out.fp_arr1 = obj.fit_param;
            out.es_valid  = obj.cut_energies;
            if exist('filename','var')
                fld_names = fieldnames(out);
                save(filename,'-struct','out',fld_names{:});
            end
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
            obj.cut_energies_ = EnCutBlock.get_en_list(ld.cut_list);
        end
        
    end
    
end

