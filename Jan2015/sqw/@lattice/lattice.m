classdef lattice
    %The class representing crystall lattice.

    properties
     alatt=[1,1,1];      %   alatt   vector containing lattice parameters (Ang) 
     angldeg=[90,90,90];  %  vector containing lattice angles (degrees)    
    end
    
    methods
        function this=lattice(varargin)
        % function bulds the crslalline lattice class
        %
        %Usage:
        %lat = lattice();
        %lat = lattice(latConstant,latAngle);
        %lat = lattice([a,b,c])
        %lat = lattice([a,b,c],latAngle);
        %lat = lattice([a,b,c],[alpha,beta,gamma]));        
        %lat = lattice(struct) the struct is the structure with the fields
        %      named allat and angdeg and their values;
          if nargin==0
             return;
          end
          % convert various argiments to cell array in the form:
          % {'fieldName',value,'fieldName',value}
          in_args = to_cell_array(varargin{:});
          % extract the argument which correspont to the fields of this
          % class
          [this_arg_name,this_arg_value,extraargi] = parce_these_arguments(in_args,{'alatt','angldeg'});          
          if ~isempty(extraargi)
              error('LATTICE:invalid_argument',' Arguments %s are not recognized',extraargi{:});
          end         
          this = process_arguments(this_arg_name,this_arg_value);
        end
        
        function this = subsasgn(this, index, varargin)
        % method allows to assighn the values to arguments
        % verifying arguments first.
        % Deployed automatically within assigning to a field using 
        % "." operator.
            argi=check_arguments(index.subs,varargin{:});
            this= builtin('subsasgn',this,index,argi{:});
        end
        
    end
    
end

