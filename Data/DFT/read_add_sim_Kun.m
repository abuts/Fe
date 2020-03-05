function [ses,qx_pts,en_pts,pxs,pys,pzs,ens]=read_add_sim_Kun(combine_with_1D,build_grid)
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
filler = NaN; %NaN; % 0 or NaN or negative
visualize = false;

[ese,mis_range] = cellfun(@(cl)expand_sim(cl,en_pts,filler,visualize),es,'UniformOutput',false);
ne = cellfun(@(x)(~isempty(x)),mis_range,'UniformOutput',true);
nex_tot = sum(ne);
fprintf(' Total number of points needing further calculations %d out of %d\n',...
    nex_tot,numel(qx));
%
%visualize = true;
%combine_with_1D = 2; % kill volume info and look at the lines only (debugging)
[pxs,pys,pzs,ses] = expand_sym_points(qx,qy,qz,ese,combine_with_1D,visualize);
%
% at this stage, ens is an energy axis (100 elements)
ens = en_pts';
if build_grid
    [ses,pxs,pys,pzs,qx_pts] = regrid_signal(pxs,pys,pzs,ses,21,en_pts,visualize);
else
    % find the
    expanded = cellfun(@(cl)(~isempty(cl)),ses,'UniformOutput',true);
    %regular = cellfun(@(cl)(size(cl,1)==100),ses(expanded),'UniformOutput',true);
    ses = [ses{expanded}]; % combine signal cellarray int 2D array
    %
    qx_pts = sort(unique(round(pxs,11)));
    %Nx = numel(qx_pts);
    pxs = pxs(expanded);
    pys = pys(expanded);
    pzs = pzs(expanded);
    
end




if isnan(filler) && ~build_grid
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
    ens = repmat(en_pts',1,szs(2));
    ens = reshape(ens,numel(ens),1);
    ens = ens(valid);
end
% if gen_grid
%     ses = ses';
%     %[pxg,pyg,pzg]= meshgrid(Xj,Xj,Xj);
%     %ses = reshape(ses,Nx,Nx,Nx ,numel(en_pts));
%     [ses,pxs,pys,pzs,ens] = regrid_signal(pxs,pys,pzs,ses,21);
% end

%
function [sesg,pxsg,pysg,pzsg,Xj] = regrid_signal(pxs,pys,pzs,ses,Nip,en_pts,visualize)
jn=@(N)(1:N);
Xn =@(N)(0.5-0.5*cos((jn(N)-0.5)*pi/N));

Xj = Xn(Nip);
[pxsg,pysg,pzsg] =meshgrid(Xj,Xj,Xj);


q_edges = [0,0.5*(Xj(1:end-1)+Xj(2:end)),1+eps];
in = pxs>=q_edges;
ibinx = sum(in,2);
in = pys>=q_edges;
ibiny = sum(in,2);
in = pzs>=q_edges;
ibinz = sum(in,2);
ibin = sub2ind([Nip,Nip,Nip],ibinx,ibiny,ibinz);
% sort signals over 3D bins
[ibin,inds] = sort(ibin);
ses = ses(inds);
if visualize
    pxs = pxs(inds);
    pys = pys(inds);
    pzs = pzs(inds);
    p_r = [pxs,pys,pzs];
else
    p_r = [];
end

[full_ibin,ia] = unique(ibin);
if numel(full_ibin)<Nip*Nip*Nip % empty bins are present
    % add empty signals to empty bins;
    ir = 1:Nip;
    [irx,iry,irz] = meshgrid(ir,ir,ir);
    irx = reshape(irx,1,numel(irx));
    iry = reshape(iry,1,numel(iry));
    irz = reshape(irz,1,numel(irz));
    all_bins = sub2ind([Nip,Nip,Nip],irx,iry,irz);
    missing = ~ismember(all_bins,full_ibin);
    add_bins = all_bins(missing);
    ses(end+1:end+numel(add_bins))=cell(1,numel(add_bins));
    full_ibin = [full_ibin;add_bins'];
    [full_ibin,inds] = sort(full_ibin);
    ses = ses(inds);
    if visualize
        pxs_a = pxsg(add_bins);
        pys_a = pysg(add_bins);
        pzs_a = pzsg(add_bins);        
        pr_a = [pxs_a,pys_a,pzs_a];
        p_r = [p_r;pr_a];
        p_r  = p_r(inds,:);
    end
    [~,ia] = unique(full_ibin);
    if numel(ia) ~=numel(full_ibin)
        warning('logical error');
    end
end
iae = [ia;numel(inds)+1];
bin_range = iae(2:end)-iae(1:end-1);


cont_size = numel(en_pts);
if visualize
    fh = figure('Name','Chebyshev''s grid');
    scatter3(reshape(pxsg,numel(pxsg),1),reshape(pysg,numel(pxsg),1),reshape(pzsg,numel(pxsg),1),...
        '.','MarkerFaceColor',[0 .75 .75]);      
else
   fh = [];
end
[sesg,mis_ind] = arrayfun(@(bl_ind,bl_size)combine_contents(ses,p_r,cont_size,bl_ind,bl_size,fh),...
    ia,bin_range,'UniformOutput',false);


sesg  = [sesg{:}];
sesg = sesg';
sesg = reshape(sesg,Nip,Nip,Nip,cont_size);
mis_ind = [mis_ind{:}];
if ~isempty(mis_ind)
    mis_ind = reshape(mis_ind,2,numel(mis_ind)/2)';
    empty_bins = full_ibin(mis_ind(:,1));
    [im,jm,km] = ind2sub([Nip,Nip,Nip],empty_bins);
    fprintf('******  some grid bins are empty:\n')
    for i = 1:numel(im)
        fprintf(' Bin: %d %d %d  Q: %f %f %f \n',im(i),jm(i),km(i),...
            pxsg(im(i),jm(i),km(i)), pysg(im(i),jm(i),km(i)), pzsg(im(i),jm(i),km(i)))
    end
end


function [cont,mis_ind] = combine_contents(all_pts,p_r,cont_size,this_block,block_size,fh)

mis_ind = [];
if block_size == 1
    cont = all_pts{this_block};
    if isempty(cont)
        cont = zeros(cont_size,1);
        mis_ind = [this_block,1];
        return;        
    end    
    invalid = isnan(cont);
    if any(invalid)
        cont(invalid) = 0;
    end
    return;
end
visualize = ~isempty(fh);
lh = [];


cont = zeros(cont_size,1);
weights = zeros(cont_size,1);
st = ones(cont_size,1);
for i=1:block_size
    cl = all_pts{this_block+i-1};
    if visualize 
        if isempty(lh)
            add_pp = p_r(this_block,:);
            lh = figure('Name','Combined Scattering signal');
        else
            figure(lh);
            hold on            
            add_pp = [add_pp;p_r(this_block+i-1,:)];
        end
        plot(cl);    
        
    end
    if isempty(cl)
        continue;
    end
    valid = ~isnan(cl);
    cont(valid) = cont(valid) + cl(valid);
    weights(valid) = weights(valid)+st(valid);
end
if visualize
    figure(fh);
    hold on
    scatter3(add_pp(:,1),add_pp(:,2),add_pp(:,3));
    pause(1);
    close(lh);
end
invalid = weights == 0;
if any(invalid)
    weights(invalid) = 1;
    cont(invalid) = 0;
end
if all(invalid)
    mis_ind = [this_block,block_size];
end
cont =  cont./weights;
%cont = {cont};



function [s_exp,mis_range] = expand_sim(se_clc,en_range,filler,visualize)
% Inputs:
% se_clc 2D  -- array containing calulated enegry transfer and the DFT signal
% en_range -- array with energy transfers to expand signal onto
% outputs
% s_exp -- expanded signal
%
s_exp = {};
mis_range = {en_range};

if isempty(se_clc)
    
    return;
end
if all(se_clc(:,2)==0)
    return
end
if visualize
    plot(se_clc(:,1),se_clc(:,2),'*')
end
% what energy range from total range needs caclulations
is_calc = ismember(en_range,se_clc(:,1));
% expanded signal:
s_exp = NaN(numel(en_range),1);
%sexp = zeros(numel(en_range),1);
if sum(is_calc) ~=size(se_clc,1)
    warning('point rejected');
    return
else
    % store existing signal:
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