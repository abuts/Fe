from qtiGenie import *
iliad_setup('MAP')


#print 'SL:',sl
#
#
mapfile ="C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/4to1"
mskfile  ="C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/4to1_022.msk"

bins     ='-100, 2, 1352'
ei        = 1400
LoadRaw(Filename="MAP15527.raw",OutputWorkspace="wb_wksp")
ic=0;
for n in range(15618,15665):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print '----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+1;

ic=0;
for n in range(15665,15711):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
        print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic-1;

ic=-44.5;
for n in range(15711,15740):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+1;

ic=-15.5;
for n in range(15740,15801):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+1;

ic=-31.5;
for n in range(15801,15816):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+1;
	
ic=0;
for n in range(15816,15835):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
	print n,':----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+1;
	