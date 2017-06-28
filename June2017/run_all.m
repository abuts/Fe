function run_all

rootpath = fileparts(mfilename('fullpath'));

fun_list = {...
    @proc_bragg_0m1m1,...
    @proc_bragg_0m11,...
    @proc_bragg_01m1,...
    @proc_bragg_10m1,... % checkit
    @proc_bragg_101,...
    @proc_bragg_110E200,@proc_bragg_110E400,...
    @proc_bragg_1m10E200,@proc_bragg_1m10E400,...
    @proc_bragg_200E200a,@proc_bragg_200E200b,@proc_bragg_200E400a,@proc_bragg_200E400b};
    
parfor i=1:numel(fun_list)
    f = fun_list{i};
    f(rootpath);
end



function proc_bragg_110E200(rootpath)

p_br110 = fullfile(rootpath,'Br110');
cd(p_br110);
pwd
Ei200_uvw100_at110TPmod2Peaks();
Ei200_uvw110_at110TPmod2Peaks();
Ei200_uvw111_at110TPmod2Peaks();
cd(rootpath);

function proc_bragg_110E400(rootpath)

p_br110 = fullfile(rootpath,'Br110');
cd(p_br110);
pwd
Ei400_uvw100_at110TPmod2Peaks();
Ei400_uvw110_at110TPmod2Peaks();
Ei400_uvw111_at110TPmod2Peaks();
cd(rootpath);


function proc_bragg_1m10E200(rootpath)

p_br1m10 = fullfile(rootpath,'Br1m10');
cd(p_br1m10);
pwd
Ei200_uvw100_at1m10TPmod2Peaks();
Ei200_uvw110_at1m10TPmod2Peaks();
Ei200_uvw111_at1m10TPmod2Peaks();
cd(rootpath);

function proc_bragg_1m10E400(rootpath)

p_br1m10 = fullfile(rootpath,'Br1m10');
cd(p_br1m10);
pwd
Ei400_uvw100_at1m10TPmod2Peaks();
Ei400_uvw110_at1m10TPmod2Peaks();
Ei400_uvw111_at1m10TPmod2Peaks();
cd(rootpath);


function proc_bragg_200E200a(rootpath)

p_br200 = fullfile(rootpath,'Br200');
cd(p_br200);
pwd
Ei200_uvw100_at200TPmod2Peaks
Ei200_uvw111_at200TPmod2Peaks
cd(rootpath);

function proc_bragg_200E200b(rootpath)

p_br200 = fullfile(rootpath,'Br200');
cd(p_br200);
pwd
Ei200_uvw110_at200TPmod2Peaks
cd(rootpath);

function proc_bragg_200E400a(rootpath)

p_br200 = fullfile(rootpath,'Br200');
cd(p_br200);
pwd
Ei400_uvw100_at200TPmod2Peaks
Ei400_uvw111_at200TPmod2Peaks
cd(rootpath);
function proc_bragg_200E400b(rootpath)

p_br200 = fullfile(rootpath,'Br200');
cd(p_br200);
pwd
Ei400_uvw110_at200TPmod2Peaks
cd(rootpath);


function proc_bragg_01m1(rootpath)

p_br01m1 = fullfile(rootpath,'Br01m1');
cd(p_br01m1)
pwd
Ei200_uvw100_at01m1TPmod2Peaks();
Ei200_uvw110_at01m1TPmod2Peaks();
Ei200_uvw111_at01m1TPmod2Peaks();

Ei400_uvw100_at01m1TPmod2Peaks();
Ei400_uvw110_at01m1TPmod2Peaks();
Ei400_uvw111_at01m1TPmod2Peaks();

cd(rootpath);

function proc_bragg_0m1m1(rootpath)
%--------------------------------------------------------------------------
p_br0m1m1 = fullfile(rootpath,'Br0m1m1');
cd(p_br0m1m1)
pwd
Ei200_uvw100_at0m1m1TPmod2Peaks();
Ei200_uvw110_at0m1m1TPmod2Peaks();
Ei200_uvw111_at0m1m1TPmod2Peaks();

Ei400_uvw100_at0m1m1TPmod2Peaks();
Ei400_uvw110_at0m1m1TPmod2Peaks();
Ei400_uvw111_at0m1m1TPmod2Peaks();
cd(rootpath);

%--------------------------------------------------------------------------
function proc_bragg_101(rootpath)

p_br101 = fullfile(rootpath,'Br101');
cd(p_br101)
pwd
%Ei200_uvw100_at101TpMod2P();
%Ei200_uvw110_at101TpMod2P();
%Ei200_uvw111_at101TpMod2P();
Ei400_uvw100_at101TpMod2P();
Ei400_uvw110_at101TpMod2P();
Ei400_uvw111_at101TpMod2P();

cd(rootpath);

function proc_bragg_0m11(rootpath)

p_br0m11 = fullfile(rootpath,'Br0m11');
cd(p_br0m11)
pwd
Ei200_uvw100_at0m11TPmod2Peaks();
Ei200_uvw110_at0m11TPmod2Peaks();
Ei200_uvw111_at0m11TPmod2Peaks();

Ei400_uvw100_at0m11TPmod2Peaks();
Ei400_uvw110_at0m11TPmod2Peaks();
Ei400_uvw111_at0m11TPmod2Peaks();
cd(rootpath);

function proc_bragg_10m1(rootpath)

p_br0m11 = fullfile(rootpath,'Br10m1');
cd(p_br0m11)
pwd
Ei200_uvw100_at10m1TpMod2P();
Ei200_uvw110_at10m1TpMod2P();
Ei200_uvw111_at10m1TpMod2P();

Ei400_uvw100_at10m1TpMod2P();
Ei400_uvw110_at10m1TpMod2P();
Ei400_uvw111_at10m1TpMod2P();
cd(rootpath);
