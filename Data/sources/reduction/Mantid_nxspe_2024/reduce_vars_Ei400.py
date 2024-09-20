standard_vars = {
         'incident_energy':401.1,
         'energy_bins':[-20, 2, 344],
         'sample_run':[15052, 15053, 15054, 15055, 15056, 15057, 15058, 15059, 15060, 15061, 15062, 15063, 15064, 15065, 15066, 15067, 15068, 15069, 15070, 15071, 15072, 15073, 15074, 15075, 15076, 15077, 15078, 15079, 15080, 15081, 15082, 15083, 15084, 15085, 15086, 15087, 15088, 15089, 15090, 15091, 15092, 15093, 15094, 15095, 15096, 15097, 15098, 15099, 15100, 15101, 15102, 15103, 15104, 15105, 15106, 15107, 15108, 15109, 15110, 15111, 15112, 15113, 15114, 15115, 15116, 15117, 15118, 15119, 15120, 15121, 15122, 15123, 15124, 15125, 15126, 15127, 15128, 15129, 15130, 15131, 15132, 15133, 15134, 15135, 15136, 15137, 15138, 15139, 15140, 15141, 15142, 15143, 15144, 15145, 15146, 15147, 15148, 15149, 15150, 15151, 15152, 15153, 15154, 15155, 15156, 15157, 15158, 15159, 15160, 15161, 15162, 15163, 15164, 15165, 15166, 15167, 15168, 15169, 15170, 15171, 15172, 15173, 15174, 15175, 15176, 15177, 15178],
         'wb_run':15182,
         'sum_runs':False,
         'monovan_run':15181,
         'sample_mass':166,
         'sample_rmm':53.94
}
advanced_vars={
         'map_file':'4to1_095.map',
        'monovan_mapfile':'4to1_mid_lowang.map',
        'hardmaskOnly':'4to1_095.msk',
        'bkgd_range':[15000, 19000],
        'fix_ei':True,
        'normalise_method':'current',
        'wb_for_monovan_run':15182,
        'monovan_lo_frac':-0.5,
        'diag_remove_zero':False,
        'wb_integr_range':[20, 100],
        'det_cal_file':'detector_095_libisis.nxs',
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
