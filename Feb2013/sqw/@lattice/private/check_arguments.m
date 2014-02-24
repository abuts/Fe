function args = check_arguments(fieldName,varargin)
% function verifies if the arguments, assigned to the class are allowed and
% have correct format
%


allFields = {'alatt','angdeg'};

if ~any(ismember(allFields,fieldName))
    error('LATTICE:invalid_argument','The field %s does not recognized',fieldName);    
end


if numel(varargin{1})==3
   if(size(varargin{1},2)==3)
      varargin{1} = varargin{1}';
   end
elseif numel(varargin{1})==1
   varargin{1} = [varargin{1},varargin{1},varargin{1}];
else
   error('LATTICE:invalid_argument','The field %s has to be either single value or 3-vector',fieldName);       
end

% check the angles ratio
if strcmp(fieldName,'angdeg')
    angles = varargin{1};
    if any(arrayfun(@(x) x>=180||x<=-180,angles))
        error('LATTICE:invalid_argument','All lattice angles have to be in the range from -180 to +180 degrees, but got: %d,%d, %d',angles);               
    end
end

args = varargin;    
