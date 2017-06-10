function [cuts_list,w1D_arr1_tf,fg_par_list,bg_par_list,e_sw] = make_and_fit_cuts(data_source,br_par)
% Prepare range of cuts in the energy range, defined by br_param class
% and fit them with spin wave

e_sw = br_par.getMaxErange();
q_sw = br_par.getQvsE(e_sw,1);

dE = br_par.dE;
dK = br_par.dk;
%-------------------------------------------------
% Projection
Kr = [-1,0.25*dK,1];
proj.type = 'ppp';
proj.uoffset = br_par.bragg;
cut_direction = br_par.cut_direction;

[proj.u,proj.v,proj.w]=make_ortho_set(cut_direction);

%-------------------------------------------------
% 2D cut to investigate further:
w2 = cut_sqw(data_source,proj,Kr,[-dK,+dK],[-dK,+dK],0.25*dE);
%
%figure;
plot(w2);
lz 0 2
%hold on
% remember the place of the last image and place the impage to proper
% posision
mff = MagneticIons('Fe0');
%w2=mff.fix_magnetic_ff(w2);
% pl1=plot(w2);
% lz 0 4
% hold on
%-------------------------------------------------
%
fwhh = 0.1;
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

w2 = set_sample_and_inst(w2,sample,@maps_instrument_for_tests,'-efix',600,'S');



D1FitRez = ones(8,numel(q_sw)).*NaN;
cut_list = repmat(sqw,numel(q_sw),1);
ws_valid = false(numel(q_sw),1);
for i=1:numel(q_sw)
    if isnan(q_sw(i)) || isnan(e_sw(i))
        continue
    else
        ws_valid(i) = true;
    end
    
    k_min = -q_sw(i)-5*dK;
    k_max =  q_sw(i)+5*dK;
    try
        w1=cut_sqw(w2,proj,[k_min,0.2*dK,k_max],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
        w0=cut_sqw(w2,proj,[-dK+q_sw(i),dK+q_sw(i)],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
        w1f = mff.correct_mag_ff(w1);
        w0  = mff.correct_mag_ff(w0);
    catch
        ws_valid(i) = false;
        continue
    end
    %-------
    
    
    
    const = w1f.data.s(1); % take background as the intencity at leftmost point
    grad  = 0;  % guess background gradient is 0
    amp=(w0.data.s-const)*(k_max-k_min)/2; % guess gausian amplitude
    
    ic = uint32(I_types.I_cut);     D1FitRez(ic,i)  =amp;
    di = uint32(I_types.dI_cut);    D1FitRez(di,i)  =w0.data.e*(k_max-k_min);
    
    IP=amp;
    %dIP = w0.data.e;
    peak_width = fwhh;
    try
        [w1_tf,fp3]=fit(w1f,@TwoGaussAndBkgd,...
            [IP,q_sw(i),peak_width,const,grad],[1,0,1,1,1],'fit',[1.e-4,40,1.e-6]);
    catch
        ws_valid(i) = false;
        continue
        
    end
    
    
    %kk = tobyfit2(w1);
    %ff_calc = mff.getFF_calculator(w1);
    
    %kk = kk.set_fun(@(h,k,l,e,par)gauss_shape(proj,ff_calc,h,k,l,e,par),[amp,q_sw(i),fwhh],[1,1,1]);
    %kk = kk.set_free([1,0,0]);
    %kk = kk.set_bfun(@lin_bg,[const,grad]);
    %kk = kk.set_bfree([1,0]);
    
    %kk = kk.set_mc_points(10);
    %kk = kk.set_options('listing',1);
    %[w1_tf, fp3] = kk.simulate;
    %[w1_tf,fp3]=kk.fit;
    cut_list(i) = w1;
    if fp3.converged && fp3.chisq < 3 && ~any(isnan(fp3.sig))
        ia = uint32(I_types.I_gaus_fit);   D1FitRez(ia,i) = fp3.p(1); %par.p(1)*sigma*sqrt(2*pi);
        iw = uint32(I_types.gaus_sig);     D1FitRez(iw,i) = fp3.p(3);
        ix = uint32(I_types.gaus_x0);      D1FitRez(ix,i) = fp3.p(2);
        id = uint32(I_types.dI_gaus_fit);  D1FitRez(id,i) = fp3.sig(1);
        dix= uint32(I_types.gaus_dx0);     D1FitRez(dix,i)= fp3.sig(2);
        bg1= uint32(I_types.bkg_level);    D1FitRez(bg1,i)= fp3.p(4);
        bg2= uint32(I_types.bkg_grad);     D1FitRez(bg2,i)= fp3.p(5);
        ws_valid(i) = true;
    else
        ws_valid(i) = false;
    end
    
    
    acolor('k')
    plot(w1f);
    acolor('r')
    pd(w1_tf);
    if ~ws_valid(i)
        hold on
        line([k_min,k_max],[const,amp+const],'Color','r','LineWidth',2)
        line([k_min,k_max],[amp+const,const],'Color','r','LineWidth',2)
        hold off
    end
    drawnow;
    pause(1);
end

ws_valid =  ws_valid & ~isnan(sum(D1FitRez,1)');
cuts_list = cut_list(ws_valid);
ind = 1:numel(ws_valid);
ind_valid = ind(ws_valid);
bg_par_list=arrayfun(@(i)([D1FitRez(bg1,i),D1FitRez(bg2,i)]),ind_valid,'UniformOutput',false);

ff = 1; % 1
T = 8;  % 2
%gamma = 10; % 3
%Seff = 2;   % 4
gap = 0;    % 5
J1 = 2.683324e+01;    % 6
%par = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];

fg_par_list =arrayfun(@(i)([ff,T,2/D1FitRez(iw,i),4*D1FitRez(ia,i),gap,J1,0,0,0,0]),ind_valid,'UniformOutput',false);

%
cut_list = cut_list(ws_valid);
kk = tobyfit2(cut_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,fg_par_list,[0,0,1,1,0,0,0,0,0,0]);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
%kk = kk.set_bind({1,[1,2],1},{2,[2,2],1},{3,[3,2],1});
if numel(cut_list) > 1
    kk = kk.set_bind({6,[6,2],1});
end

% set up its own initial background value for each background function
kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),bg_par_list);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w1D_arr1_tf,fp_arr1]=kk.fit;

for i=1:numel(w1D_arr1_tf)
    acolor('k');
    plot(cut_list(i));
    acolor('r');
    pd(w1D_arr1_tf(i));
    pause(1)
end

if iscell(fp_arr1.p)
    fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
    fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
    bg_err = reshape([fp_arr1.bsig{:}],2,numel(fp_arr1.bsig))';
else
    fitpar = fp_arr1.p;
    fiterr = fp_arr1.sig;
end
bg_par_list = fp_arr1.bp;
fg_par_list = fp_arr1.p;

cuts_valid = true(numel(fg_par_list),1);
for i=1:size(fitpar,1)
    if any(fiterr(i,:)./fitpar(i,:) > 1) || any(fitpar(i,:)<0) || any(bg_err(i,:) > 1) || any(fiterr(i,:) > 10)
        k1 = tobyfit2(cut_list(i));
        k1 = k1.set_fun(@sqw_iron,abs(fg_par_list{i}),[0,0,1,1,0,0,0,0,0,0]);
        k1 = k1.set_bfun(@(x,par)(par(1)+x*par(2)),bg_par_list{i});
        k1 = k1.set_mc_points(10);
        k1 = k1.set_options('listing',1,'fit_control_parameters',[1.e-4;60;1.e-6]);
        %kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
        %profile on;
        [fit_res,fp1_fit]=k1.fit;
        if fp1_fit.converged
            if any(fp1_fit.p./fp1_fit.sig > 2) || any(fp1_fit.p<0) || any(fp1_fit.bsig > 1) || any(fp1_fit.sig > 10)
                cuts_valid(i) = false;
                cross = true;
            else
                fg_par_list{i} = abs(fp1_fit.p);
                bg_par_list{i} = fp1_fit.bp;
                cross = false;
            end
            acolor('k');
            plot(cut_list(i));
            acolor('r');
            pd(fit_res);
            if cross
                hold on
                y_min = min(fit_res.data.s);
                y_max = max(fit_res.data.s);
                line([k_min,k_max],[y_min ,y_max ],'Color','r','LineWidth',2)
                line([k_min,k_max],[y_max, y_min ],'Color','r','LineWidth',2)
                hold off
            end
            pause(1)
        else
            cuts_valid(i) = false;
        end
        
    end
end

cuts_list =cuts_list(cuts_valid);
fg_par_list = fg_par_list(cuts_valid);
bg_par_list = bg_par_list(cuts_valid);
e_sw = e_sw(cuts_valid);
w1D_arr1_tf = w1D_arr1_tf(cuts_valid);



%
function y = TwoGaussAndBkgd(x, p, varargin)

y=(exp(-0.5*((x-p(2))/p(3)).^2)+exp(-0.5*((x+p(2))/p(3)).^2))*(p(1)/sqrt(2*pi)/p(3)) + (p(4)+x*p(5));
