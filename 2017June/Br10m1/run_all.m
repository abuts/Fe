
root = fileparts(pwd);
data_source= fullfile(root ,'sqw','Data','Fe_ei401.sqw');



rp1=Ei200_uvw100_at10m1TpMod2P('nor');
rp2=Ei200_uvw110_at10m1TpMod2P('nor');
rp3=Ei200_uvw111_at10m1TpMod2P('nor');
rp4=Ei400_uvw100_at10m1TpMod2P('nor');
rp5=Ei400_uvw110_at10m1TpMod2P('nor');
rp6=Ei400_uvw111_at10m1TpMod2P('nor');


%rpAll = {rp1{:},rp2{:},rp3{:},rp4{:},rp5{:},rp6{:}};
rpAll = {rp4{:},rp5{:},rp6{:}};

parfor i=1:numel(rpAll)
    rp1 = rpAll{i};
    
    dir_tag = direction_id(rp1.cut_direction);
    do_fits(data_source,rp1.bragg,dir_tag,{rp1})
end
