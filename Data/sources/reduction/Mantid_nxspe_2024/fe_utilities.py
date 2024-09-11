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
    
def estimate_elastic_line_en(ws_name,bin_range):
    # Calculate energy distribution around elastic line and evaluate correct elastic line position
    #
    # Input:
    #
    Rebin(InputWorkspace=ws_name, OutputWorkspace=ws_name+'_reb', Params=bin_range)
    SumSpectra(InputWorkspace=ws_name+'_reb', OutputWorkspace=ws_name+'_sum', IncludeMonitors=False, RemoveSpecialValues=True, UseFractionalArea=False)
    ws = mtd[ws_name+'_sum']
    xp    = ws.readX(0)
    dist0 = ws.readY(0)
    Norm  = np.sum(dist0[:-1])
    energy = 0.5*(xp[:-1]+xp[1:])
    return np.sum(dist0*energy)/Norm
