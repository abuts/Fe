""" Reduction script to calculate vanadium integrals for Ei=200 """
# Two rows necessary to run script outside of the mantid. You need also set up 
# appropriate python path-es

import os
#
from mantid import *
from Direct.ReductionWrapper import *
from fe_utilities import *

class MAPSReduction(ReductionWrapper):
#------------------------------------------------------------------------------------#
   @MainProperties
   def def_main_properties(self):
       """ Define main properties used in reduction. These are the property 
           a user usually wants to change
       """ 
       prop = {}
       # if energy is specified as a list (even with single value e.g. ei=[81])
       # The numbers are treated as a fraction of ei [from ,step, to ]. If energy is 
       # a number, energy binning assumed to be absolute (e_min, e_step,e_max)
       #
       prop['incident_energy'] = 200 # estimated to get elastic line at the centre. Bining accuracy does not allow
                                     # to identify elastic line position wich higher accuracy
       prop['energy_bins'] =[-20,0.25,180]

       # the range of files to reduce. This range ignored when deployed from autoreduction,
       # unless you going to sum these files. 
       # The range of numbers or run number is used when you run reduction from PC.
       #ws = mtd['w1']
       prop['sample_run'] = 15532 # 
       prop['wb_run']     = 15527
       #
       prop['sum_runs'] = False # set to true to sum everything provided to sample_run
       #                        # list
       # Absolute units reduction properties. Set prop['monovan_run']=None to do relative units
       prop['monovan_run'] = 15532 #  vanadium run in the same configuration as your sample 
       prop['sample_mass'] = 166
       prop['sample_rmm'] = 53.94
       return prop
#------------------------------------------------------------------------------------#
   @AdvancedProperties
   def def_advanced_properties(self):
      """  Set up advanced properties, describing reduction.
           These are the properties, usually provided by an instrument 
           scientist
            
           separation between simple and advanced properties depends
           on scientist, experiment and user.   All are necessary for reduction 
           to work properly
      """
      prop = {}
      prop['map_file'] = "4to1_102.map"  # "parker_rings.map"
      prop['monovan_mapfile'] = "parker_rings.map"
      prop['hardmaskOnly']="4to1_102.msk" #maskfile # disable diag, use only hard mask
      prop['hard_mask_file'] = ""
      prop['bkgd_range'] = [15000,19000]
      prop['fix_ei'] = True
      prop['normalise_method'] = 'current'
      prop['wb_for_monovan_run'] = 15527

      prop['monovan_lo_frac'] = -0.5 # default is -0.6
      #prop['monovan_hi_frac'] = 0.7 # default is 0.7, no need to change
      #prop['abs_units_van_range']=[-40,40] # specify energy range directly, to
                                     #override relative default energy range
      prop['diag_remove_zero'] = False
      prop['wb_integr_range'] = [20,100] 
      
      #prop['det_cal_file'] = "11060" what about calibration?
      prop['save_format'] = 'nxs' # nxs,nxspe or spe
      prop['data_file_ext']='.raw' # if two input files with the same name and
                                    #different extension found, what to prefer.
      prop['run_diagnostics'] = False
      
      return prop
      #
#------------------------------------------------------------------------------------#
   @iliad
   def reduce(self,input_file=None,output_directory=None):
      """ Method executes reduction over single file

          Overload only if custom reduction is needed or 
          special features are requested
      """
      results = ReductionWrapper.reduce(self,input_file,output_directory)
      #SaveNexus(ws,Filename = 'MARNewReduction.nxs')
      return results
   #
   #
   def set_custom_output_filename(self):
      """define custom name of output files if standard one is not satisfactory
        
          In addition to that, example of accessing complex reduction properties
          Simple reduction properties can be accessed as e.g.: value= prop_man.sum_runs
      """        
      return lambda : custom_name(self.reducer.prop_man,PropertyManager)
      # Uncomment this to use standard file name generating function
      #return None
   #
   def validation_file_place(self):
      """Redefine this to the place, where validation file, used in conjunction with
         'validate_run' property, located. Here it defines the place to this script folder.
          but if this function is disabled, by default it looks for/places it 
          in a default save directory"""
      return os.path.split(os.path.realpath(__file__))[0]
   
   def __init__(self,web_var=None):
       """ sets properties defaults for the instrument with Name"""
       ReductionWrapper.__init__(self,'MAP',web_var)
#---------------------------------------------------------------------------------------------------------------------------

       
if __name__ == "__main__" or __name__ == "mantidqt.widgets.codeeditor.execution":
#------------------------------------------------------------------------------------#
# SECTION USED TO RUN REDUCTION FROM MANTID SCRIPT WINDOW #
#------------------------------------------------------------------------------------#
##### Here one sets up folders where to find input data and where to save results ####
    # It can be done here or from Mantid GUI:
    #      File->Manage user directory ->Browse to directory
    # Folder where map and mask files are located:
    #import importlib
    #importlib.reload(set_data_dir)
    set_data_dir('ei200S_Cycle_10_02','cycle10_02','vanadium')    

###### Initialize reduction class above and set up reduction properties.        ######
######  Note no web_var in constructor.(will be irrelevant if factory is implemented)
    rd = MAPSReduction()
    # set up advanced and main properties
    rd.def_advanced_properties()
    rd.def_main_properties()

#### uncomment rows below to generate web variables and save then to transfer to   ###
    ## web services.
    run_dir = os.path.dirname(os.path.realpath(__file__))
    file = os.path.join(run_dir,'reduce_vars.py')
    rd.save_web_variables(file)

#### Set up time interval (sec) for reducer to check for input data file.         ####
    #  If this file is not present and this value is 0,reduction fails
    #  if this value >0 the reduction waits until file appears on the data
    #  search path checking after time specified below.
    rd.wait_for_file = 0  # waiting time interval in seconds

### Define a run number to validate reduction against future changes    #############
    # After reduction works well and all settings are done and verified, 
    # take a run number with good reduced results and build validation
    # for this result. 
    # Then place the validation run together with this reduction script.
    # Next time, the script will run reduction and compare the reduction results against
    # the results obtained earlier.
    #rd.validate_run_number = 21968  # Enabling this property disables normal reduction
    # and forces reduction to reduce run specified here and compares results against
    # validation file, processed earlier or calculate this file if run for the first time.
    #This would ensure that reduction script have not changed,
    #allow to identify the reason for changes if it was changed 
    # and would allow to recover the script,used to produce initial reduction
    #if changes are unacceptable.

####get reduction parameters from properties above, override what you want locally ###
   # and run reduction. Overriding would have form:
   # rd.reducer.prop_man.property_name (from the dictionary above) = new value e.g. 
   # rd.reducer.prop_man.energy_bins = [-40,2,40]
   # or 
   ## rd.reducer.prop_man.sum_runs = False
   # 
    
    red_vanadium_MAP15532 = rd.run_reduction()
    
    Eel = estimate_elastic_line_en(red_vanadium_MAP15532,(-20,1,200))


