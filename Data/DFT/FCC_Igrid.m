classdef FCC_Igrid
    % Clas builds an partial interpolant, based on caclulations
    % perfomred over FCC lattice symmetry directions
    properties(Access = private)
        orts_=[1,0,0;1/sqrt(2),1/sqrt(2),0;1/sqrt(3),1/sqrt(3),1/sqrt(3)]
        
        dr_ = 0.02;
        fcc_Q1_grid_
    end
    
    properties
    end
    properties(Constant)
        p_ = {...
            {[0,0,0;1,0,0];[0,0,0;0,1,0];[0,0,0;0,0,1];...
            [1,1,0;0,1,0];[1,1,0;1,0,0];[1,1,0;1,1,1];...
            [1,0,1;0,0,1];[1,0,1;1,0,0];[1,0,1;1,1,1];...
            [0,1,1;0,1,0];[0,1,1;0,0,1];[0,1,1;1,1,1]};... % All GH
            {[0,0,0;1,1,0];[0,0,0;1,0,1];[0,0,0;0,1,1];...
            [1,1,0;1,0,1];[1,1,0;0,1,1];[1,0,1;0,1,1]};... % All 2*GN
            {[0,0,0;1,1,1];[1,1,0;0,0,1];...
            [0,1,1;1,0,0];[0,1,1;1,0,0]};...  % All GP+PH
            {[1,0,0;0,1,0];[1,0,0;0,0,1];...
            [0,1,0;0,0,1];[0,1,0;1,1,1];...
            [1,1,1;1,0,0];[1,1,1;0,0,1]}};    % All 2*HN
        %obj.p_{5} = {[1,0,0;0,1,1];[0,1,0;1,1,1];[0,0,1;1,1,1]}; % All 2*HP
    end
    
    methods
        function obj = FCC_Igrid(dr)
            if ~exist('dr','var')
                dr = 0.02;
            end
            obj.dr_ = dr;
            obj = build_Q1_grid_(obj);
        end
        
        
    end
    methods(Access=private)
        function obj = build_Q1_grid_(obj)
            
            N1 = floor(1/obj.dr_);
            obj.dr_ = 1/N1;
            obj.fcc_Q1_grid_ = zeros(N1,N1,N1);
            %di = 0:N1-1;
            Ni = [N1-1;N1-1;N1-1];
            dr = obj.dr_;
            dr_r = dr/10;
            for i=1:numel(obj.p_)
                sym = obj.p_{i};
                for j=1:numel(sym)
                    dir= sym{j};
                    e0 = dir(1,:);
                    e1 = dir(2,:);
                    e01 = e1-e0;
                    l1 = sqrt(e01*e01');
                    ort = e01/l1;
                    orz = (ort == 0);
                    if any(orz)
                        ort1 = zeros(1,3);
                        z0 = find(orz,1);
                        ort1(z0)= 1;
                    else
                        ort1 =[0,-ort(3),ort(2)]/sqrt(ort(3)^2+ort(2)^2);
                    end
                    ort2 = cross(ort,ort1);
                    
                    d1 = ort.*(0:dr_r:l1-dr_r)';
                    grid = [d1-ort1*dr;d1+ort1*dr;d1-ort2*dr;d1+ort2*dr];
                    grid = grid + repmat(e0.*Ni'*dr,size(grid,1),1);
                    Ngrid = floor(grid/dr);
                    %Ngrid = Ngrid+repmat(e0.*Ni',size(Ngrid,1),1);
                    p_j1 = floor(Ngrid(:,1))+1;
                    p_j1 = obj.check_limits_(p_j1,1,N1);
                    p_j2 = floor(Ngrid(:,2))+1;                    
                    p_j2 = obj.check_limits_(p_j2,1,N1);                    
                    p_j3 = floor(Ngrid(:,3))+1;                    
                    p_j3 = obj.check_limits_(p_j3,1,N1);                    
                    linind = sub2ind(size(obj.fcc_Q1_grid_), p_j1, p_j2,p_j3);                    
                    linind = unique(linind);
                    obj.fcc_Q1_grid_(linind)=100*i+j;

                    %p_j =floor(e0'.*Ni+e01'*di)+1;
                    %obj.fcc_Q1_grid_(p_j(1,:),p_j(2,:),p_j(3,:))=i;
                end
            end
        end
    end
    methods(Static)
        function lin_ind = check_limits_(lin_ind ,i_min,i_max)
            lesser = lin_ind<i_min;
            if any(lesser)
                lin_ind(lesser) = i_min;
            end
            greater = lin_ind>i_max;
            if any(greater )
                lin_ind(greater) = i_max;
            end
            
        end
    end
end


