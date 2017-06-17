rootpath = fileparts(mfilename('fullpath'));


%Ei200_uvw100_at200TPmod2Peaks();
%Ei200_uvw110_at200TPmod2Peaks();
%Ei200_uvw111_at200TPmod2Peaks();

%Ei400_uvw100_at200TPmod2Peaks();
%Ei400_uvw110_at200TPmod2Peaks();
%Ei400_uvw111_at200TPmod2Peaks();
p_br01m1 = fullfile(rootpath,'Br01m1');
cd(p_br01m1)
pwd
Ei400_uvw100_at01m1TPmod2Peaks();
Ei400_uvw110_at01m1TPmod2Peaks();
Ei400_uvw111_at01m1TPmod2Peaks();
cd(rootpath);
p_br0m1m1 = fullfile(rootpath,'Br0m1m1');
cd(p_br0m1m1)
pwd
Ei400_uvw100_at0m1m1TPmod2Peaks();
Ei400_uvw110_at0m1m1TPmod2Peaks();
Ei400_uvw111_at0m1m1TPmod2Peaks();
cd(rootpath);
p_br0m11 = fullfile(rootpath,'Br0m11');
cd(p_br0m11)
pwd
Ei400_uvw100_at0m11TPmod2Peaks();
Ei400_uvw110_at0m11TPmod2Peaks();
Ei400_uvw111_at0m11TPmod2Peaks();
cd(rootpath);
p_br101 = fullfile(rootpath,'Br101');
cd(p_br101)
pwd
Ei200_uvw100_at101Tpmod2P();
Ei200_uvw110_at101Tpmod2P();
Ei200_uvw111_at101Tpmod2P();
Ei400_uvw100_at101Tpmod2P();
Ei400_uvw110_at101Tpmod2P();
Ei400_uvw111_at101Tpmod2P();
cd(rootpath);