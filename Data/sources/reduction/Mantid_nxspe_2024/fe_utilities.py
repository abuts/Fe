# import mantid algorithms
from mantid.simpleapi import *

import os
import numpy as np
from mantid import *

def custom_name(instance,holder):
      """Sample function which builds filename from
        incident energy and run number and adds some auxiliary information
        to it.
      """
      map_file = instance.map_file
      if 'rings' in map_file:
          ftype = '_powder'
      else:
          ftype = ''
      # Note -- properties have the same names as the list of advanced and
      # main properties
      ei = holder.incident_energy.get_current()
      # sample run is more then just list of runs, so we use
      # the formalization below to access its methods
      run_num = holder.sample_run.run_number()
      name = "map{0}_ei{1:_<3.0f}meV{2}".format(run_num ,ei,ftype)
      return name


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
    if isinstance(ws,str):
        ws = mtd[ws]
    
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
    """ Calculate energy distribution around elastic line and evaluate correct elastic line position
    
       Input:
        ws_name     -- workspace pointer or workspace name to process
        bin_range   -- tuple with 3 elements defining requested bining ranges (min, step,max)
        last_spectrum
                    -- if present, define maximal number of spectra from input workspace to be included
                       in the result. If absent, all input workspace spectra are included
       Returns: 
         Average value of input workspace x-coordinate. x_av = integral(f(x)*x*dx)/integral(f(x)*dx)
           
         Adds to ADS 2 workspaces:
         one -- input workspace rebinned with parameters provided and limited
                by the last_spectrum.
                Name of the workspace is the name of the source workspace with suffix "_reb"
         two -- a single spectra workspace containing sum of all spectra of the first workspace
                Name of the second workspace is the name of the input workspace with suffix "_sum"
                
    """
    if not isinstance(ws_name,str):
        ws_name = ws_name.name()
     
    target_ws_name = ws_name+'_reb'
    sum_ws_name    = ws_name+'_sum'
    if not last_spectrum is None:
        ExtractSpectra(InputWorkspace=ws_name,OutputWorkspace=target_ws_name, EndWorkspaceIndex=last_spectrum)
        ws_name  = target_ws_name
    Rebin(InputWorkspace=ws_name, OutputWorkspace=target_ws_name, Params=bin_range)
        
    SumSpectra(InputWorkspace=target_ws_name, OutputWorkspace=sum_ws_name, IncludeMonitors=False, RemoveSpecialValues=True, UseFractionalArea=False)
    ws = mtd[sum_ws_name]
    av_energy = av_value(ws,0)
    print('Average Energy = {0}'.format(av_energy))    
    return av_energy

def select_det_at_distance(ws,distance,delta):
    """ Create workspace which contains spectras with detectors located at specific range of distances from sample
        and add these spectra together
    """
    
    if isinstance(ws,mantid.dataobjects._dataobjects.Workspace2D):
        ws_name = ws.name()
    else:
        ws_name = ws
        ws = mtd[ws_name]
    
    det_table = CreateDetectorTable(InputWorkspace=ws)
    ws_ids = []
    for id in range(0,ws.getNumberHistograms()):
        rw = det_table.row(id)
        if np.abs(rw['R'] - distance)<=delta:
            ws_ids.append(int(rw['Index']))
    new_name = ws_name+'_extract'
    ExtractSpectra(ws,WorkspaceIndexList= ws_ids,OutputWorkspace = new_name)
    SumSpectra(InputWorkspace=new_name,OutputWorkspace = new_name+'_sum')
    ws_sum = mtd[new_name+'_sum']
    xval = ws_sum.readX(0)
    bin_range = (xval[0],1,xval[-1])
    Rebin(InputWorkspace=new_name+'_sum',Params=bin_range,OutputWorkspace=new_name+'_sum')
    return mtd[new_name+'_sum']
