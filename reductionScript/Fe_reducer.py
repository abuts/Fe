from qtiGenie import *
iliad_setup('MAP')


#print 'SL:',sl
#
#
mapfile ="C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/4to1.map"
mskfile  ="C:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/4to1_022.msk"
bins     ='-30.5,1,190.5'
ei        = 200
LoadRaw(Filename="15527",OutputWorkspace="wb_wksp")
ic=0;
for n in range(15835,15880):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
        #getEi(InputWorkspace="run_wksp",Monitor1Spec='41474',Monitor2Spec='41475',EnergyEstimate='200');	
	print '----->\n'
	w1=iliad("wb_wksp","run_wksp",ei,bins,mapfile,det_cal_file=in_file,fixei=False,norm_method='monitor-1',bkgd_range=[12000,18000],diag_sigma=3,diag_remove_zero=False)
#    SetUB(Workspace="run_wksp",a='2.4165',b='5.4165',c='5.4165',u='0,1,0',v='1,0,0')	
	SaveNXSPE(w1,'MAP'+str(n)+'.nxspe',Psi=ic)
	ic=ic+2;
