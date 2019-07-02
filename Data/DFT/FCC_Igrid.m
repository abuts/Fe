classdef FCC_Igrid
    % Clas builds an partial interpolant, based on caclulations
    % perfomred over FCC lattice symmetry directions
    properties(Access = private)
        orts_=[1,0,0;1/sqrt(2),1/sqrt(2),0;1/sqrt(3),1/sqrt(3),1/sqrt(3)]
        
        dr_ = 0.02;
        fcc_Q1_grid_
        int_cell_
        cell_dir_
    end
    
    properties
        % the property to select one of five calculated symmetry directions
        % if empry, all directions are considered
        panel_dir    = []
        % the property selects one of the equivalend symmetry directions
        % from equivalent directions, appropriate for selected symmetry
        % directions. If empty, all directions are used
        equiv_sym    = []
    end
    properties(Constant)
        %p_ = {{[0,0,0;1,0,0];[0,0,0;0,1,0];[0,0,0;0,0,1];...
        %    [1,1,0;0,1,0];[1,1,0;1,0,0]}}
        %            {[0,0,0;1,0,0];[0,0,0;0,1,0];[0,0,0;0,0,1];...
        %            [1,1,0;0,1,0];[1,1,0;1,0,0];[1,1,0;1,1,1];...
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
            [1,1,1;1,0,0];[1,1,1;0,0,1]};...   % All 2*HN
            {[1/2,1/2,0;1/2,1/2,1];[1/2,0,1/2;1/2,1,1/2];...
            [0,1/2,1/2;1,1/2,1/2]}...           % All 2*NP
            };
        %obj.p_{5} = {[1,0,0;0,1,1];[0,1,0;1,1,1];[0,0,1;1,1,1]}; % All 2*HP
    end
    
    methods
        function obj = FCC_Igrid(dr)
            if ~exist('dr','var')
                dr = 0.02;
            end
            obj.dr_ = dr;
            obj = build_Q1_grid_(obj);
            [obj.int_cell_,obj.cell_dir_] = import_Kun_2Q1();
        end
        function [q_range,e_range,dir,center] = get_range(obj,n_sym,n_dir)
            sym = obj.p_{n_sym};
            ids = obj.int_cell_{n_sym};
            npt = size(ids{1},2);
            
            bc = ids{2}(:,1);
            be = bc(2:end)-bc(1:end-1);
            e_range = [bc(1)-0.5*be(1);be;bc(end)+0.5*be(end)];
            npe = numel(e_range);
            de = (max(e_range) - min(e_range))/(npe-1);
            i = 0:npe-1;            
            e_range = min(e_range)+de*i;
            
            q_dir = sym{n_dir};
            
            q0  = q_dir(1,:);
            dir = q_dir(2,:)-q0;
            q_step = dir/(npe-1);
            center = 0.5*(q0+q_dir(2,:));
            %start = q0-center;
            
            %i = 0:npe-1;
            q_range = q0+q_step.*i';
            q_var = 1.e-12*2*(rand(size(q_range))-0.5);
            q_range = q_range+q_var;
        end
        function disp = calc_sqw(obj,qh,qk,ql,en)
            qr = [qh,qk,ql];
            %
            % move all vectors into 0-1 quadrant where the interpolant is defined.
            brav = fix(qr);
            brav = brav+sign(brav);
            brav = (brav-rem(brav,2));
            %
            qr   = single(abs(qr-brav));
            enr  = single(en);
            
            ind = floor(qr/obj.dr_)+1;
            Nx = size(obj.fcc_Q1_grid_,1);
            on_edge = ind>Nx;
            ind(on_edge) = Nx;
            linind = sub2ind(size(obj.fcc_Q1_grid_), ind(:,1),  ind(:,2), ind(:,3));
            
            int_ind = obj.fcc_Q1_grid_(linind);
            disp = zeros(size(qh));
            if isempty(obj.panel_dir)
                all_dir = obj.p_;
            else
                all_dir = obj.p_(obj.panel_dir);
            end
            
            for i=1:numel(all_dir)
                sym = all_dir{i};
                sym_ind = floor(int_ind/100);
                this_ind = (sym_ind == i);
                selected_ind = find(this_ind);
                this_q = qr(this_ind,:);
                this_e = enr(this_ind);
                dir_ind = int_ind(this_ind) -sym_ind(this_ind)*100;
                interpol_coeff = obj.int_cell_{i};
                iX = interpol_coeff{1};
                iY = interpol_coeff{2};
                Z = interpol_coeff{3};
                
                sym_ind = 1:numel(sym);
                if isempty(obj.equiv_sym)
                    all_sym = sym;
                else
                    sym_ind = sym_ind(obj.equiv_sym);
                    all_sym = sym(obj.equiv_sym);
                end
                for j=1:numel(all_sym)
                    j_dir = sym_ind(j);
                    dir= all_sym{j};
                    [e1,e2,e3,l1] = build_ort(dir(1,:),dir(2,:));
                    this_dir = (dir_ind == j_dir);
                    e_dir = this_e(this_dir);
                    if isempty(e_dir)
                        continue;
                    end
                    q_dir = this_q(this_dir,:)-dir(1,:);
                    
                    dir_ind_sel = selected_ind(this_dir);
                    dist = sqrt((q_dir*e2').^2+(q_dir*e3').^2);
                    close_enough = dist<=obj.dr_;
                    e_line  = e_dir(close_enough);
                    if isempty(e_line)
                        continue
                    end
                    q_dir = q_dir(close_enough,:);
                    dir_ind_sel = dir_ind_sel(close_enough);
                    q_line = q_dir*e1';
                    
                    sig = interpn(iX(1,:),iY(:,1),Z',q_line,e_line,'linear',NaN);
                    disp(dir_ind_sel) = sig;
                end
            end
        end
        
        function gen_sqw2d(n_dir,n_sym)
        end
    end
    methods(Access=private)
        function obj = build_Q1_grid_(obj)
            
            N1 = floor(1/obj.dr_);
            obj.dr_ = 1/N1;
            obj.fcc_Q1_grid_ = zeros(N1,N1,N1);
            Ni = [N1-1;N1-1;N1-1];
            dr = obj.dr_;
            dr_r = dr/10;
            for i=1:numel(obj.p_)
                sym = obj.p_{i};
                for j=1:numel(sym)
                    dir= sym{j};
                    e0 = dir(1,:);
                    e1 = dir(2,:);
                    [ort,ort1,ort2,l1] = build_ort(e0,e1);
                    
                    d1 = ort.*(0:dr_r:l1-dr_r)';
                    grid = [d1;d1-ort1*dr;d1+ort1*dr;d1-ort2*dr;d1+ort2*dr];
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


