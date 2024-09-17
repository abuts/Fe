# import mantid algorithms
from mantid.simpleapi import *

import os
import numpy as np
from mantid import *

def set_data_dir(source_folder,*args):
    """ function sets common folders used by Fe reduction scripts
        assuming standard folder structure and location wrt the reduction script location
        @inputs:
            source_folder -- the short name of the folder where source files are 
            taret_folder  -- the list of the directories names wrt the script directory
    """
    script_dir = os.path.dirname(os.path.realpath(__file__))
    #script_dir  = r"e:\SHARE\Fe\Data\sources\reduction\Mantid_nxspe_2024"
    red_dir,scr_folder = os.path.split(script_dir)
    # Folder where map and mask files are located:
    map_mask_dir = os.path.join(red_dir,"InstrumentFiles","maps")
    # folder where input data can be found
    data_dir     = os.path.join(red_dir,"raw",source_folder)
    vanadium_dir = os.path.join(data_dir,"vanadium")
    # use appendDataSearch directory to add more locations to existing Mantid 
    # data search path
    #config.appendDataSearchDir('{0};{1};{2}'.format(map_mask_dir,data_dir,vanadium_dir))
    # use setDataSearchDirs to clear all other path not to accumulate them
    config.setDataSearchDirs('{0};{1};{2}'.format(map_mask_dir,data_dir,vanadium_dir))
    
    # folder to save resulting spe/nxspe files.
    save_dir = os.path.join(script_dir,*args)
    config['defaultsave.directory'] = save_dir #data_dir
    
def av_value(ws,spec_number,min_idx=None,max_idx=None):
    """ Calculate average value defined by selected distribution """
    xp    = ws.readX(spec_number)
    dist0 = ws.readY(spec_number)
    if min_idx is None:
        min_idx=0
    if max_idx is None:
        max_idx = len(xp)
    Norm   = np.sum(dist0[min_idx:max_idx-1])
    energy = 0.5*(xp[min_idx:max_idx-1]+xp[min_idx+1:max_idx])
    av_energy = np.sum(dist0[min_idx:max_idx-1]*energy)/Norm    
    return av_energy
    
    
def estimate_elastic_line_en(ws_name,bin_range,last_spectrum = None):
    # Calculate energy distribution around elastic line and evaluate correct elastic line position
    #
    # Input:
    #
    if not isinstance(ws_name,str):
        ws_name = ws_name.name()
        
    if not last_spectrum is None:
        ExtractSpectra(InputWorkspace=ws_name+'_reb',OutputWorkspace=ws_name+'_reb', EndWorkspaceIndex=last_spectrum)        
    Rebin(InputWorkspace=ws_name, OutputWorkspace=ws_name+'_reb', Params=bin_range)
        
    SumSpectra(InputWorkspace=ws_name+'_reb', OutputWorkspace=ws_name+'_sum', IncludeMonitors=False, RemoveSpecialValues=True, UseFractionalArea=False)
    ws = mtd[ws_name+'_sum']
    av_energy = av_value(ws,0)
    print('Average Energy = {0}'.format(av_energy))    
    return av_energy

    