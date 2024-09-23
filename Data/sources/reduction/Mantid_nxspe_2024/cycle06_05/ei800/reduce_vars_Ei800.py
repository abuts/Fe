standard_vars = {
         'incident_energy':787,
         'energy_bins':[-100, 4, 726],
         'sample_run':[11014, 11015, 11016, 11017, 11018, 11019, 11020, 11021, 11022, 11023, 11024, 11025, 11026, 11027, 11028, 11029, 11030, 11031, 11032, 11033, 11034, 11035, 11036, 11037, 11038, 11039, 11040, 11041, 11042, 11043, 11044, 11045, 11046, 11047, 11048, 11049, 11050, 11051, 11052, 11053, 11054, 11055, 11056, 11057, 11058, 11059, 11060, 11063, 11064, 11065, 11066, 11067, 11068, 11069, 11070, 11071, 11072, 11073, 11074, 11075, 11076, 11077, 11078, 11079, 11080, 11081, 11082, 11083, 11084, 11085, 11086, 11087, 11088, 11089, 11090, 11091, 11092, 11093, 11094, 11095, 11096, 11097, 11098, 11099, 11100, 11101, 11102, 11103, 11104, 11105, 11106, 11107, 11108, 11109, 11110, 11111, 11112, 11113, 11114, 11115, 11116, 11117, 11118, 11119, 11120, 11121, 11122, 11123, 11124, 11125, 11126, 11127, 11128, 11129, 11130, 11131, 11132, 11133, 11134, 11135, 11136, 11137, 11138, 11139, 11140, 11141, 11142, 11143, 11144, 11145, 11146, 11147, 11148, 11149, 11150, 11151, 11152, 11153, 11154, 11155, 11156, 11157, 11158, 11159, 11160, 11161, 11162, 11163, 11164, 11165, 11166, 11167, 11168, 11169, 11170, 11171, 11172, 11173, 11174, 11175, 11176, 11177, 11178, 11179, 11180, 11181, 11182, 11183, 11184, 11185, 11186, 11187, 11188, 11189, 11190, 11191, 11192, 11193, 11194, 11195, 11196, 11197, 11198, 11199, 11200, 11201],
         'wb_run':10962,
         'sum_runs':False,
         'monovan_run':11270,
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
        'wb_for_monovan_run':11276,
        'abs_units_van_range':[-80, 80],
        'wb_integr_range':[20, 100],
        'det_cal_file':'detector_065_libisis.nxs',
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
