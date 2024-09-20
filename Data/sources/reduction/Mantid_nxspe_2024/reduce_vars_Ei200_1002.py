standard_vars = {
         'incident_energy':200.0,
         'energy_bins':[-20, 1, 162],
         'sample_run':[15835, 15836, 15837, 15838, 15839, 15840, 15841, 15842, 15843, 15844, 15845, 15846, 15847, 15848, 15849, 15850, 15851, 15852, 15853, 15854, 15855, 15856, 15857, 15858, 15859, 15860, 15861, 15862, 15863, 15864, 15865, 15866, 15867, 15868, 15869, 15870, 15871, 15872, 15873, 15874, 15875, 15876, 15877, 15878, 15879, 15880, 15881, 15882, 15883, 15884, 15885, 15886, 15887, 15888, 15889, 15890, 15891, 15892, 15893, 15894, 15895, 15896, 15897, 15898, 15899, 15900, 15901, 15902, 15903, 15904, 15905, 15906, 15907, 15908, 15909, 15910, 15911, 15912, 15913, 15914, 15915, 15916, 15917, 15918, 15919, 15920, 15921, 15922, 15923, 15924, 15925, 15926, 15927, 15928, 15929, 15930, 15931, 15932, 15933, 15934, 15935, 15936, 15937, 15938, 15939, 15940, 15941, 15942, 15943, 15944, 15945, 15946, 15947, 15948, 15949, 15950, 15951, 15952, 15953, 15954, 15955, 15956, 15957, 15958, 15959, 15960, 15961, 15962, 15963, 15964, 15965],
         'wb_run':15527,
         'sum_runs':False,
         'monovan_run':15532,
         'sample_mass':166,
         'sample_rmm':53.94
}
advanced_vars={
         'map_file':'4to1_065.map',
        'monovan_mapfile':'mid-tubes_065.map',
        'hardmaskOnly':'4to1_065.msk',
        'bkgd_range':[15000, 19000],
        'fix_ei':True,
        'normalise_method':'current',
        'wb_for_monovan_run':15527,
        'monovan_lo_frac':-0.5,
        'diag_remove_zero':False,
        'wb_integr_range':[20, 100],
        'det_cal_file':'detector_102_libisis.nxs',
        'save_format':'nxspe',
        'data_file_ext':'.raw'
}
variable_help={
         'standard_vars' : {
         'incident_energy':'Provide incident energy or range of incident energies to be processed.\n\n Set it up to list of values (even with single value i.e. prop_man.incident_energy=[10]),\n if the energy_bins property value to be treated as relative energy ranges.\n\n Set it up to single value (e.g. prop_man.incident_energy=10) to treat energy_bins\n as absolute energy values.\n ',
        'energy_bins':'Energy binning, expected in final converted to energy transfer workspace.\n\n Provide it in the form:\n propman.energy_bins = [min_energy,step,max_energy]\n if energy to process (incident_energy property) has a single value,\n or\n propman.energy_bins = [min_rel_enrgy,rel_step,max_rel_energy]\n where all values are relative to the incident energy,\n if energy(ies) to process (incident_energy(ies)) are list of energies.\n The list of energies can contain only single value.\n (e.g. prop_man.incident_energy=[100])/\n ',
        'sample_run':'Run number, workspace or symbolic presentation of such run\n containing data of scattering from a sample to convert to energy transfer.\n Also accepts a list of the such run numbers',
        'wb_run':'Run number, workspace or symbolic presentation of such run\n containing results of white beam neutron scattering from vanadium used in detectors calibration.',
        'sum_runs':'Boolean property specifies if list of files provided as input for sample_run property\n should be summed.\n ',
        'monovan_run':'Run number, workspace or symbolic presentation of such run\n containing results of monochromatic neutron beam scattering from vanadium sample\n used in absolute units normalization.\n None disables absolute units calculations.',
         },
         'advanced_vars' : {
         'map_file':'Mapping file for the sample run.\n\n The file used to group various spectra together to obtain appropriate instrument configuration\n and improve statistics.',
        'monovan_mapfile':'Mapping file for the monovanadium integrals calculation.\n\n The file used to group various monochromatic vanadium spectra together to provide\n reasonable statistics for these groups when calculating monovanadium integrals.',
        'hardmaskOnly':'Sets diagnostics algorithm to use hard mask file and to disable all other diagnostics.\n\n Assigning a mask file name to this property sets up hard_mask_file property\n to the file name provided and use_hard_mask_only property to True, so that\n only hard mask file provided is used to exclude failing detectors.\n ',
        'normalise_method':'Generic descriptor for property, which can have one value from a list of values.',
        'wb_for_monovan_run':'Run number, workspace or symbolic presentation of such run\n containing results of white beam neutrons scattering from vanadium, used to calculate monovanadium\n integrals for monochromatic vanadium.\n\n If not explicitly set, white beam for sample run is used.',
        'det_cal_file':'Provide a source of the detector calibration information.\n\n A source can be a file, present on a data search path, a workspace\n or a run number, corresponding to a file to be loaded as a\n workspace.\n ',
        'save_format':'The format to save reduced results using internal save procedure.\n\n Can be one name or list of supported format names. Currently supported formats\n are: spe, nxspe and nxs data formats.\n See Mantid documentation for detailed description of the formats.\n If set to None, internal saving procedure is not used.\n ',
         },
}
