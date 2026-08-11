if(~exist("instr_check",'var'))
    ld = load('2CutsEi200Ei800_peak110.mat');
    instr_check = ld.instr_check;
end

cuts   = {instr_check.w2e200dir010off100,instr_check.w2e800dir010off100};
bg_par = {instr_check.e200_bg_par.p,instr_check.e800_bg_par.p};

hkl_proj =cellfun(@(sobj)sobj.data.proj,cuts);

correct_ff = 1;
T   = 8;
gap = 0;    %
gamma = 20;
Seff0 =1;      %1.4489;
J0 = 30;

init_fg_param = [correct_ff,T,gamma,Seff0, gap, J0, 0,  0,  0,  0];
%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0, 0,  0];


kk = tobyfit(cuts{:});

%kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_param,hkl_proj});
kk = kk.set_free(free_sw_param);

kk = kk.set_bfun (@double_exp2D); % set_bfun sets the background functions

kk = kk.set_bpin (bg_par);  % initial background constant and gradient
bfree = zeros(1,4);
bfree(1)=1;
kk = kk.set_bfree (bfree);

kk = kk.set_options('list',2);
[fit_obj,fit_par] = kk.fit();

