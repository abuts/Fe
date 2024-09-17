print 'start\n'
cur_ws='wsn';
md_ws='mdws4D';
MDWSF='';
print 'for\n'
ic = 0;
for n in range(15052,15179):
	print 'Load\n'	
	#LoadNXSPE(Filename='D:/Data/Fe/Fe_Mantid/MAP'+str(n)+'.nxspe',OutputWorkspace=cur_ws)
	#LoadNXSPE(Filename='D:/Data/Fe/Fe_Mantid/MAP15052.nxspe',OutputWorkspace=cur_ws)
	#print 'SetUB\n'		
	#SetUB(Workspace=cur_ws,a='2.87',b='2.87',c='2.87')
	   # rotated by proper number of degrees around axis Y
	#AddSampleLog(Workspace=cur_ws,LogName='Psi',LogText=str(ic),LogType='Number Series')
	#SetGoniometer(Workspace=cur_ws,Axis0='Psi,0,1,0,1')
  
	#md_ws=ConvertToMD(InputWorkspace=cur_ws,QDimensions='Q3D',PreprocDetectorsWS='preprDet',MinValues='-4.2,-4.2,-4.2,-50',MaxValues='4.2,4.2,4.2,350',SplitInto='50',MaxRecursionDepth='1',MinRecursionDepth='1')
        #fname = 'MDMAP'+str(n)+'.nxs';
	#SaveMD(md_ws,Filename=fname);
	#DeleteWorkspace(md_ws);
	#DeleteWorkspace(cur_ws);	
	if (len(MDWSF) == 0):
		MDWSF = fname;
	else:
		MDWSF=MDWSF+','+fname;
	ic=ic+1;

ws4D = MergeMDFiles(MDWSF,OutputFilename='fe400_8k.nxs',Parallel='0');
######################################################################


