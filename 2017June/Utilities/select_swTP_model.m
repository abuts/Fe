function [result,all_plots]=select_swTP_model(data_source,bragg,cut_direction,cut_p,dE,dK)
% Make range of 1D cuts, fits them with TF models and found model
% parameters, fit Gaussian maxima positions with parabola
% Estimate intensity along sw  from Gaussian fit amplitude and
% correct this intensity by cut properties, dependent on SW curvature
%Inputs:
% data_source -- full path and name of the sqw file to cut
% Bragg       -- hkl coordinates of Bragg peak to cut around
% cut_directio-- hkl vector pointing to the cut direction with central
%                point of Bragg
% cut_p       -- array of Q-dE points along cut direction to do 1D cuts
%                around
% dE          -- half of energy resolution of the cut
% dK          -- half of q-resolution of the cut.
%
q_range = cut_p(:,1);
e_sw = cut_p(:,2);
result = struct();

%-------------------------------------------------
% Projection
Kr = [-1,0.5*dK,1];
proj.type = 'ppp';
proj.uoffset = bragg;
[proj.u,proj.v,proj.w]=make_ortho_set(cut_direction);

%-------------------------------------------------
% 2D cut to investigate further:
w2 = cut_sqw(data_source,proj,Kr,[-dK,+dK],[-dK,+dK],[]);
%
%figure;
plot(w2);
lz 0 1
ly 0 400
hold on
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



D1FitRez = ones(8,numel(q_range)).*NaN;
cut_list = repmat(sqw,size(cut_p,1),1);
fits_list = repmat(sqw,size(cut_p,1),1);
fitpar_list = cell(size(cut_p,1),1);
ws_valid = false(size(cut_p,1),1);
fs = fig_spread('-tight');
for i=1:size(cut_p,1)
    if isnan(q_range(i)) || isnan(e_sw(i))
        continue
    else
        ws_valid(i) = true;
    end
    if e_sw(i) <= 40
        width = 5;
        k_min = -q_range(i)-width*dK;
        k_max =  q_range(i)+width*dK;
        
    else
        %         width = 10;
        %         k_min = -q_range(i)-width*dK;
        %         k_max =  q_range(i)+width*dK;
        k_min = -1;
        k_max = 1;
        
    end
    
    try
        w1=cut_sqw(w2,proj,[k_min,0.5*dK,k_max],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
        w0=cut_sqw(w2,proj,[-dK+q_range(i),dK+q_range(i)],[-dK,dK],[-dK,dK],[e_sw(i)-dE,e_sw(i)+dE]);
        w1f = mff.correct_mag_ff(w1);
        w0  = mff.correct_mag_ff(w0);
    catch Err
        disp([' Cut rejected, ',Err.message]);
        ws_valid(i) = false;
        continue
    end
    %-------
    
    
    
    const = w1.data.s(1); % take background as the intensity at leftmost point
    grad  = 0;  % guess background gradient is 0
    amp=(w0.data.s-const); % guess Gaussian amplitude
    
    ic = uint32(I_types.I_cut);     D1FitRez(ic,i)  =amp;
    di = uint32(I_types.dI_cut);    D1FitRez(di,i)  =w0.data.e*(k_max-k_min);
    
    IP=amp;
    %dIP = w0.data.e;
    peak_width = fwhh*sqrt(log(256));
    try
        [w1_tf,fp3]=fit(w1f,@TwoGaussAndBkgd,...
            [IP,q_range(i),peak_width,const,grad],[1,1,1,1,1],'fit',[1.e-4,40,1.e-6]);
    catch ERR
        ws_valid(i) = false;
        continue
        
    end
    
    
 
    cut_list(i) = w1;
    fits_list(i) = w1_tf;
    fitpar_list{i} = fp3;
    if fp3.converged && fp3.chisq < 4 && ~any(isnan(fp3.sig))
        ig = uint32(I_types.I_gaus_fit);   D1FitRez(ig,i) = fp3.p(1); %par.p(1)*sigma*sqrt(2*pi);
        i0 = uint32(I_types.gaus_sig);     D1FitRez(i0,i) = fp3.p(3);
        ix = uint32(I_types.gaus_x0);      D1FitRez(ix,i) = fp3.p(2);
        id = uint32(I_types.dI_gaus_fit);  D1FitRez(id,i) = fp3.sig(1);
        dix= uint32(I_types.gaus_dx0);     D1FitRez(dix,i)= fp3.sig(2);
        bg1= uint32(I_types.bkg_level);    D1FitRez(bg1,i)= fp3.p(4);
        bg2= uint32(I_types.bkg_grad);     D1FitRez(bg2,i)= fp3.p(5);
        cross = false;
    else
        cross = true;
    end
    
    
    acolor('k')
    pl2=plot(w1f);
    acolor('r')
    pd(w1_tf);
    if cross
        hold on
        y_min = min( w1.data.s);
        y_max = max(w1.data.s);
        line([k_min,k_max],[y_min ,y_max ],'Color','r','LineWidth',2)
        line([k_min,k_max],[y_max, y_min ],'Color','r','LineWidth',2)
        hold off
    end
    fs = fs.place_fig(pl2);
    drawnow;
    
end
fs=reviewPictures(fs);
ws_selected = fs.get_valid_ind();
fs = fs.close_all();
ws_valid = ws_valid & ws_selected';
%
cut_list  = cut_list(ws_valid);
fits_list = fits_list(ws_valid);
fitpar_list = [fitpar_list{ws_valid}];
%
I   = abs(D1FitRez(uint32(I_types.I_cut),:));
dI  = D1FitRez(uint32(I_types.dI_cut),:);
Iaf = D1FitRez(uint32(I_types.I_gaus_fit),:);
dIaf= D1FitRez(uint32(I_types.dI_gaus_fit),:);
%---------------------------------------------------------------
caption =@(vector)['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];
% Plot all intensities as processed
pl3=figure('Name',['SW intensity along dE; peak: ',caption(bragg),' Direction: ',caption(cut_direction)]);
li1=errorbar(e_sw,I,dI,'b');
hold on
li2=errorbar(e_sw,Iaf,dIaf,'r');
%
plots = [li1, li2];
ly 0 1
legend(plots,'Integral intensity','fit intensity');
%---------------------------------------------------------------
% Fit and plot spin-wave shape
valid = ~isnan(D1FitRez(uint32(I_types.gaus_sig),:));

qswm = D1FitRez(uint32(I_types.gaus_x0),valid);
qswm_err =D1FitRez(uint32(I_types.gaus_dx0),valid );

parab = @(x,par)(par(1)+(par(2)+par(3)*x).*x);
s.x = qswm;
s.y = e_sw(valid)';
s.e = qswm_err;
if numel(s.y) > 3
    [~,fit_par] = fit(s,parab,[1,1,1]);
else
    fit_par.p=[0,0,1100];
end
parR  = fit_par.p;

xxpf=max(min(qswm),-0.8)-0.02:0.01:min(max(qswm),0.8)+0.02;
yypf=parab(xxpf,parR);

cut_id = [caption(bragg),' Direction: ',caption(cut_direction)];
pl4=figure('Name',['Spin wave for: ', cut_id ]);
plot(xxpf,yypf,['-','g']);
hold on
ind    = find(valid);
qswm_err_l = ones(numel(valid),1)*NaN;
qswm_err_l(ind(:))= qswm_err(:);
errorbar(q_range,e_sw,qswm_err_l,'r');
errorbar(qswm,e_sw(valid),D1FitRez(uint32(I_types.gaus_sig),valid),'b');
lx(min(xxpf)-0.01,max(xxpf)+0.01);
ly(0,1.1*max(yypf));


fhhw_all  = D1FitRez(uint32(I_types.gaus_sig),valid);
ampl = D1FitRez(uint32(I_types.I_gaus_fit),valid);
ampl_avrg = sum(ampl)/sum(valid);
fwhh_avrg = sum(fhhw_all)/sum(valid);
deltaSq = sum((fhhw_all - fwhh_avrg).^2)/sum(valid);
deltaASq  = sum((ampl    - ampl_avrg).^2)/sum(valid);
fprintf('Av_amplitude: %f +-%f; Full height Half width average: %f +- %f\n',...
    ampl_avrg,sqrt(deltaASq),fwhh_avrg,sqrt(deltaSq));
drawnow
pause(1)
all_plots = [pl2,pl3,pl4];
res_file = rez_name(data_source,bragg,cut_direction,'TF_NOF_');
es_valid = arrayfun(@(x)(0.5*(x.data.iint(1,3)+x.data.iint(2,3))),cut_list);
w1D_arr1_tf = fits_list;
fp_arr1     = fitpar_list;
save(res_file,'es_valid','data_source','bragg','cut_direction','dE','dK',...
    'cut_list','w1D_arr1_tf','fp_arr1');

%

function [u,v,w,Norm]=make_ortho_set(u)
% simple function which generate orthogonal right-hand set around
% specified vector

Rot=zeros(3,3,3);
% Rx
Rot(1,1,1)=1;
Rot(2,3,1)=-1;
Rot(3,2,1)=1;
% Ry
Rot(1,3,2)=-1;
Rot(2,2,2)= 1;
Rot(3,1,2)= 1;
%Rz
Rot(3,3,3)=1;
Rot(1,2,3)=-1;
Rot(2,1,3)=1;

[minv,im] = min(abs(u));

Norm = sqrt(u*u');
if Norm<1.e-6
    error('MAKE_ORTHO_SET:invalid_argument',' u can not be 0 vectror')
end

u = u/Norm; %;
wt = (Rot(:,:,im)*u')';
vt = cross(wt,u);
v = vt/sqrt(vt*vt');

w = cross(u,v);

