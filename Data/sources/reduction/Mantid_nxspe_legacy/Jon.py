from qtiGenie import *
from PySlice import *

inst='mar'
iliad_setup(inst)
ext='.raw'
mapfile='mari_res'
#det_cal_file must be specified if the reduction sends out put to a workpsace
cal_file='MAR16637.raw'
#load vanadium file
whitebeamfile="16637"
LoadRaw(Filename=whitebeamfile,OutputWorkspace="wb_wksp",LoadLogFiles="0")
#---------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------
ei=100
rebin_params='-10,.5,95'
#load run
#runfile="16644"

runs=[16654]#,16643,16652,16642,16643,16644,16645,16648,16649]
#save .spe file
for runfile in runs:
	save_file=inst+str(runfile)+'_norm.spe'
	LoadRaw(Filename=runfile,OutputWorkspace="run_wksp",LoadLogFiles="0")
	w2=iliad("wb_wksp","run_wksp",ei,rebin_params,mapfile,det_cal_file=cal_file,diag_remove_zero=False,norm_method='current')
	#w1=iliad("wb_wksp","run_wksp",ei,rebin_params,mapfile,det_cal_file=cal_file,norm_method='current',diag_sigma=2,diag_remove_zero=False,hardmaskPlus='/Users/jon/Work-computing/mantid_test_data/mari/mask.dat')
	SaveNXSPE('w2',save_file,Psi=0)
	DeleteWorkspace('_wksp.spe-white')
	RenameWorkspace(w2,str(runfile))
