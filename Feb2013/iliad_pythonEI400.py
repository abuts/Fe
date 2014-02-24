#Script to perform data reduction for MAPS
from qtiGenie import *
import time

#instrument name:
inst='map'
iliad_setup(inst)
ext='.raw'
maskfile='4to1_095.msk'#hard mask out the edges of detectors, which tend to be noisy

#map file
mapfile='4to1_095.map' #single crystal mapping file
mapfile_monovan = '4to1_mid_lowang.map'
#mapfile='/opt/Mantid/instrument/mapfiles/maps/parker_rings' #powder mapping file

# latest white beam vanadium file for bad detector diagnosis
wbvan=15182
monovan=15181
monovan_wb = 15182




#Incident energy list e.g. ei=[20,30,40]
ei=[400]
rebin_pars=['-71, 2, 381'] 
sam_mass=166
sam_rmm=53.94

psi= range(0,92,2)+range(1,91,2)+range(-2,-48,-2)+range(-1,-27,-2)
runs = range(15052,15179)
	
save_dir = config.getString('defaultsave.directory')


for i in range(len(runs))  :

    runno = runs[i]
    # define resulting file name for this run
    save_fname=inst+str(runno)+'_ei'+str(ei[0])+'.nxspe'
    longName = os.path.join(save_dir ,save_fname)    
    if(os.path.isfile(longName)):
        continue
    # load the data to process   
    in_file = getnumor(runno);   
    LoadRaw(Filename=in_file,OutputWorkspace="run_wksp")
        
    w1=iliad_abs(wbvan,"run_wksp",
                monovan,monovan_wb,
                sam_rmm,sam_mass,
                ei[0],rebin_pars[0],
                mapfile,mapfile_monovan,
                bkgd_range=[12000,18000],
                det_cal_file ='detector_095_libisis.nxs' ,
                hardmaskPlus=maskfile,diag_remove_zero=False)
   

    SaveNXSPE('w1',save_fname,Psi=psi[i])




