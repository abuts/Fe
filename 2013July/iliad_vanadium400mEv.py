#from qtiGenie import *
from mantid.simpleapi import *
from mantid import config

#import dgreduce_old as dgrd
import dgreduce as dgrd
import time

#dgrd = reload(dgrd)
#instrument name:
inst='map'
#iliad_setup(inst)
dgrd.setup(inst)
ext='.raw'

maps_dir = 'c:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/'
config.appendDataSearchDir(maps_dir)
data_dir = r'd:\Data\Fe\Feb2013\Ei400'
config.appendDataSearchDir(data_dir)
config['defaultsave.directory'] = r'd:\Data\Fe\July2013'

maskfile='4to1_022.msk' #'testMask2.msk'#hard mask out the edges of detectors, which tend to be noisy

#map file
mapfile='4to1' #single crystal mapping file
#mapfile='/opt/Mantid/instrument/mapfiles/maps/parker_rings' #powder mapping file
mv_mapfile='4to1_mid_lowang'

# latest white beam vanadium file for bad detector diagnosis
wbvan=15182

#Run numbers can be specified as a list:
#runno=[17422,17423, etc]
runno=[15181] #[19399] #,[00004] 19402]

#Incident energy list e.g. ei=[20,30,40]
ei=[400,400]

#Sample info
#sam_rmm=350.653
sam_rmm = 50.9415
#sam_mass= 2.465
sam_mass = 30.1
#If run number is 00000 (from updatestore) delete existing workspace so that new raw data file is loaded
try:
    map00000=CloneWorkspace('MAP00000')
    DeleteWorkspace('MAP00000')
    DeleteWorkspace('map00000')
except:
    print('Workspace zero did not exist anyway')


try:
    map00000=CloneWorkspace('MAP00000.raw')
    DeleteWorkspace('MAP00000.raw')
    DeleteWorkspace('map00000')
except:
    print('Workspace zero did not exist anyway')
    
rebin_pars=[-20,2,380]
monovan=15181
argi = {};
argi['bkgd_range'] = [13000,19000]
argi['hardmaskPlus']=maskfile 
#argi['hardmaskOnly']=maskfile 
argi['diag_remove_zero']=False
argi['abs_units_van_range']=[-40,40]   
argi['wb_integr_range'] = [20,100]
argi['sample_mass'] = sam_mass   
argi['sample_rmm']   =sam_rmm 
argi['save_format']   = []
#argi['save_and_reuse_masks']=False

for i in range(len(runno)):
    if ei[i]==400:

        
        #arb_units(wb_run,sample_run,ei_guess,rebin,map_file='default',monovan_run=None,**kwargs):
        w1=dgrd.arb_units(wbvan,runno[i],ei[i],rebin_pars,'default',monovan,**argi)         

        #w1=iliad_abs(wbvan,runno[i],ei[i],str(rebin_pars).strip('[]'),mapfile,bkgd_range=[13000,19000],hardmaskPlus=maskfile,diag_remove_zero=False,save_format='none')
    #Alternative (abs units):
    #w1=iliad_abs(wbvan,runno[i],monovan[i],wbvan,sam_rmm,sam_mass,ei[i],str(rebin_pars[i]).strip('[]'),mapfile,mapfile,bkgd_range=[14000,19000],hardmaskPlus=maskfile,diag_remove_zero=False)
    save_file=inst+str(runno[i])+'_ei'+str(ei[i])  
    SaveNXSPE(w1,save_file+'AbsWB.nxspe')
    SaveNexus(w1,save_file+'AbsWB.nxs')	
    DeleteWorkspace(w1)
    if runno[i]==0:
        DeleteWorkspace('MAP00000.raw')
    else:
        DeleteWorkspace('MAP'+str(runno[i])+'.raw')	




