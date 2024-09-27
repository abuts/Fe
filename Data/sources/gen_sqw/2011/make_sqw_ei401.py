inst = 'MAP'
MD_wsFiles = ''
#runs = range(15052,15179)
runs = range(15052,15054)
target_fName = 'fe_ei401.nxs'
ei = 400
cur_ws_base = 'Matr2D_wsRun:'
md_ws_balse = 'MD_wsRun:'

# it is both save and source folder here, if not, different has to be used 
save_dir = config.getString('defaultsave.directory')

# calculate partial MD event files or pick up existent one
for i in range(len(runs))  :
    runno = runs[i]
    # define resulting file name for this run
    source_fname=inst+str(runno)+'_ei'+str(ei)+'.nxspe'
    targ_fname  ='MD_'+inst+str(runno)+'_ei'+str(ei)+'.nxs' 
    longSName = os.path.join(save_dir ,source_fname)    

    
    # build the file list from exising files or the files we are creating
    if (len(MD_wsFiles) == 0):
       MD_wsFiles = targ_fname;
    else:
       MD_wsFiles=MD_wsFiles+','+targ_fname;   
    # if target file is already there, we do not need to deal with it any more
    if(os.path.isfile(targ_fname)):
        continue

    cur_ws  = cur_ws_base+str(runno);
    md_ws = md_ws_balse+str(runno);
    
    print 'Loading file: ',source_fname    
    LoadNXSPE(Filename=longSName, OutputWorkspace=cur_ws)
    
    SetUB(Workspace=cur_ws,a='2.87',b='2.87',c='2.87')
    print 'Converting to MD file: ', targ_fname       
    ConvertToMD(InputWorkspace=cur_ws,OutputWorkspace=md_ws,QDimensions='Q3D',PreprocDetectorsWS='PreprocDetMaps',MinValues='-4.2,-4.2,-4.2,-80',MaxValues='4.2,4.2,4.2,380',SplitInto='50',MaxRecursionDepth='1',MinRecursionDepth='1')
    SaveMD(InputWorkspace=md_ws,Filename=targ_fname);
    
    # save memory (for single file)
    DeleteWorkspace(md_ws);
    DeleteWorkspace(cur_ws);
    
# combine partial MD ws files into single workspace
MergeMDFiles(Filenames = MD_wsFiles,OutputFilename=target_fName,OutputWorkspace='WS4D',Parallel='0');    
    


