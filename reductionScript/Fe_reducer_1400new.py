from qtiGenie import *
iliad_setup('MAP')


#print 'SL:',sl
#
#
config.appendDataSearchDir(r'd:\Data\Fe\Feb2013\EI400');
config.appendDataSearchDir(r'C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/');
mapfile ="C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/4to1"
mskfile  ="C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/4to1_022.msk"
bins     ='-71,2,381'
ei        = 400
LoadRaw(Filename="MAP15182.raw",OutputWorkspace="wb_wksp")
ic=0;
red_args={};
red_args['bkgd_range']=[12000,18000]
red_args['norm_method']='monitor-1';
red_args['samp_sig']=3;
red_args['diag_remove_zero']=False
red_args['det_cal_file']=in_file;
for n in range(15052,15097):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print '----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,**red_args)
#        SetUB(Workspace="run_wksp",a='2.4165',b='5.4165',c='5.4165',u='0,1,0',v='1,0,0')	
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+2;

ic=1;
for n in range(15098,15143):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
        print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,**red_args)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+2;

ic=-2;
for n in range(15143,15166):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,**red_args)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic-2;

ic=-1;
for n in range(15166,15179):
#for n in range(15174,15179):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,**red_args);
	ic=ic-2;
