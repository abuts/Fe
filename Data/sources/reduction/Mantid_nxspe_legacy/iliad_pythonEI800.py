#Script to perform data reduction for MAPS
from qtiGenie import *
import time

#instrument name:
inst='map'
iliad_setup(inst)
ext='.raw'
maskfile='4to1_065.msk'#hard mask out the edges of detectors, which tend to be noisy

#map file
mapfile='4to1_065.map' #single crystal mapping file
mapfile_monovan = 'mid_tubes_mid_lowang.map'
#mapfile='/opt/Mantid/instrument/mapfiles/maps/parker_rings' #powder mapping file

# latest white beam vanadium file for bad detector diagnosis
wbvan=11277
monovan=[11276]
monovan_wb = 11276
#11142:11201
runno=range(11142,11202);


#Incident energy list e.g. ei=[20,30,40]
ei=[800]
rebin_pars=[-102, 4, 752] #[[-3,0.3,27]]
sam_mass=166
sam_rmm=53.94
# temporary
#det_dir = 'c:/Users/wkc26243/Documents/work/Libisis/InstrumentFiles/maps/'
det_dir=''

#If run number is 00000 (from updatestore) delete existing workspace so that new raw data file is loaded
mybool=mtd.workspaceExists('MAP00000')
if mybool:
	mtd.deleteWorkspace('MAP00000')
	
for runno in range(11142,11202):
    #Alternative (abs units):
    w1=iliad_abs(wbvan,runno,
                monovan[0],monovan_wb,
                sam_rmm,sam_mass,
                ei[0],str(rebin_pars[0]).strip('[]'),
                mapfile,mapfile_monovan,
                bkgd_range=[12000,18000],
                det_cal_file ='detector_065.nxs' ,
                hardmaskPlus=maskfile,diag_remove_zero=False)
   
    save_file=inst+str(runno)+'_ei'+str(ei[0])+'.nxspe'
    SaveNXSPE('w1',save_file)




