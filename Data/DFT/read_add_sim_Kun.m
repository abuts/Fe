function [ses,qx_pts,en_pts,pxs,pys,pzs,ens]=read_add_sim_Kun(combine_with_1D)
% read Kun's volume simulation data and expand these data into the whole
% {[0,0,0];[1,1,1]} cuble
% Outputs:
% ses -- 4D array of calculated/extrapolated signals
% qr  -- 3xnPoints combined array of qx,qy,qz points, corresponding to the
%        q-axis of the simulated arra.
% en  -- energy axis of the simulated array.
%
[qx,qy,qz,En,Sig] = read_add_sim();

[qx,qy,qz,es] = compact3D(En,qx,qy,qz,Sig);
if ~exist('combine_with_1D','var')
    combine_with_1D = false;
end


en_pts = 8:8:800;
filler = NaN; % 0 or NaN or negative
visualize = false;

[ese,mis_range] = cellfun(@(cl)expand_sim(cl,en_pts,filler,visualize),es,'UniformOutput',false);
ne = cellfun(@(x)(~isempty(x)),mis_range,'UniformOutput',true);
nex_tot = sum(ne);
fprintf(' Total number of pints needing further calculations %d out of %d\n',...
    nex_tot,numel(qx));
%
%visualize = true;
%combine_with_1D = 2; % kill volume info and look at the lines only (debugging)
[pxs,pys,pzs,ses] = expand_sym_points(qx,qy,qz,ese,combine_with_1D,visualize);
%



expanded = cellfun(@(cl)(~isempty(cl)),ses,'UniformOutput',true);
%regular = cellfun(@(cl)(size(cl,1)==100),ses(expanded),'UniformOutput',true);
ens = repmat(en_pts',numel(ses(expanded)),1);
%
%ses = cellfun(@(cl)(cl'),ses,'UniformOutput',false);

ses = [ses{expanded}];
%
qx_pts = sort(unique(round(pxs,11)));
Nx = numel(qx_pts);
if Nx*Nx*Nx == size(ses,1)
    ses = ses';    
    ses = reshape(ses,Nx,Nx,Nx ,numel(en_pts));
else
    pxs = pxs(expanded);
    pys = pys(expanded);
    pzs = pzs(expanded);
    ens = ens(expanded);
end
if isnan(filler)
    szs = size(ses);
    pxs = repmat(pxs,1,szs(1));
    pys = repmat(pys,1,szs(1));
    pzs = repmat(pzs,1,szs(1));
    ses=reshape(ses,numel(ses),1);
    pxs=reshape(pxs',numel(ses),1);
    pys=reshape(pys',numel(ses),1);
    pzs=reshape(pzs',numel(ses),1);
    valid = ~isnan(ses);
    pxs = pxs(valid);
    pys = pys(valid);
    pzs = pzs(valid);
    ses = ses(valid);
    en_pts = repmat(en_pts',1,szs(2));
    en_pts = reshape(en_pts,numel(en_pts),1);
    en_pts = en_pts(valid);
end



function [s_exp,mis_range] = expand_sim(se_clc,en_range,filler,visualize)
% Inputs:
% se_clc 2D  -- array containing calulated enegry transfer and the DFT signal
% en_range -- array with energy transfers to expand signal onto
% outputs
% s_exp -- expanded signal
%
if isempty(se_clc)
    s_exp  = {};
    return;
end
if all(se_clc(:,2)==0)
    s_exp = {};
    mis_range = {en_range};
    return
end
if visualize
    plot(se_clc(:,1),se_clc(:,2),'*')
end
is_calc = ismember(en_range,se_clc(:,1));
s_exp = NaN(numel(en_range),1);
%sexp = zeros(numel(en_range),1);
if sum(is_calc) ~=size(se_clc,1)
    warning('point rejected');
    return
else
    s_exp(is_calc) = se_clc(:,2);
    en_out = en_range(~is_calc);
    sig_out = interp1(se_clc(:,1),se_clc(:,2),en_out,'linear','extrap');
    s_exp(~is_calc) = sig_out;
    
    if s_exp(1)>0 % signal in low energy range is not vanishing
        % is it interpolated:
        En_clc_start = se_clc(1,1);
        if En_clc_start > en_range(1) % yes
            % find interpolation range
            ind = find(en_range == En_clc_start);
            if s_exp(1) >= se_clc(1,2) % the function grows
                s_exp(1:ind-1) = filler;
                mis_range = {en_range(1:ind-1)};
            else % ok, let's lieve it as it is
                mis_range = {};
            end
        else   %fine -- we calculated it
            mis_range = {};
        end
    else
        mis_range = {};
    end
    if s_exp(end)>0 % signal in the high energy range is not vanishing
        % is it interpolated?
        En_clc_end = se_clc(end,1);
        if En_clc_end < en_range(end) % yes
            % find interpolation range
            ind = find(en_range == En_clc_end);
            if s_exp(end) >= se_clc(end,2) % the function grows
                s_exp(ind+1:end) = filler;
                sub_range = en_range(ind+1:end);
                if se_clc(end,2) > 0.5 % still ignore small signals from future calculations on the basis of the function shape
                    mis_range = {[mis_range{:},sub_range]};
                end
            else % ok, let's lieve it as it is
                %mis_range = {}; ;  The range remains unchanged
            end
        else   %fine -- we calculated it
            %mis_range = {};  The range remains unchanged
        end
    else
        %mis_range = {}; % the range remains unchanged
    end
    
    non_phys = s_exp<0;
    s_exp(non_phys) = filler;
    %
    if visualize
        hold on
        plot(en_range(~non_phys),s_exp(~non_phys))
        hold off
    end
end