from qtiGenie import *
iliad_setup('MAP')



#
#
# where to save resutls (usually specified in Mantid, data search directories)
config['defaultsave.directory']='/home/wkc26243/Fe400'
save_dir = config.getString('defaultsave.directory')
if len(save_dir) ==0 :
    config['defaultsave.directory']=os.getcwd()
    save_dir = config.getString('defaultsave.directory')
    
print "Data will be saved into: ",save_dir

config.appendDataSearchDir('/archive/ndxmaps/Instrument/data/Cycle_09_5');
config.appendDataSearchDir('/usr/local/mprogs/InstrumentFiles/maps')

ei        = 400
bins     =[-71,2,381]

sweep1  = zip(range(15052,15097+1),range(0,92,2));
sweep2  = zip(range(15098,15143+1),range(1,91,2));
sweep3  = zip(range(15143,15165+1),range(-2,-48,-2));
sweep4  = zip(range(15166,15179+1),range(-1,-27,-2));
exper = sweep1+sweep2+sweep3+sweep4;



par = {};
mapfile="4to1.map"
par['norm_method']='monitor-1'
par['bkgd_range']=[12000,18000];
par['sample_mass'] = 166.
par['sample_rmm']=53.94
par['det_cal_file']='detector_095_libisis.nxs'
par['monovan_mapfile']="mid-tubes_095.map"
par['abs_units_van_range']=[-0.4*ei,0.7*ei];



LoadRaw(Filename="MAP15182.raw",OutputWorkspace="wb_wksp")
run2angle={};



for opt in exper:
	(runn,psi) = opt;
	in_file = 'MAP'+str(runn)+'.raw';
	target  = 'MAP'+str(runn)+'.nxspe'
	if os.path.exists(target):
	   continue
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print '-----> reducing run N:',runn,' angle: ',psi,'\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,15181,**par)
	SaveNXSPE(w1,target,Psi=psi)
	

