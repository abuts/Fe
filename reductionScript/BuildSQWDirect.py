print 'start\n'
cur_ws='wsn';
md_ws='mdws4D';
MDWSF='';
print 'for\n'
for n in range(15052,15062):
	print 'Load\n'	
        LoadNXSPE(Filename='D:/Data/Fe/Fe_Mantid/MAP'+str(n)+'.nxspe',OutputWorkspace=cur_ws)
	print 'SetUB\n'		
	SetUB(Workspace=cur_ws,a='2.87',b='2.87',c='2.87')
	ConvertToMD(InputWorkspace=cur_ws,OutputWorkspace=md_ws,QDimensions='Q3D',QConversionScales='HKL',OverwriteExisting='0',MinValues='-4.2,-4.2,-4.2,-50',MaxValues='4.2,4.2,4.2,350')
        fname = 'MDMAP'+str(n)+'.nxs';
#	SaveMD(md_ws);
#	DeleteWorkspace(md_ws);
	DeleteWorkspace(cur_ws);	
	if (len(MDWSF) == 0):
		MDWSF = fname;
	else:
		MDWSF=MDWSF+','+fname;
	

#MergeMDFiles(MDWSF,OutputFilename='fe400_8k.nxs',OutputWorkspace='WS4D',Parallel='0');
SaveMD(md_ws,'FeE400_025.nxs');
######################################################################
#MergeMDFiles(Filenames='D:\Data\Fe\Fe_Mantid\MDMAP15052.nxs,D:\Data\Fe\Fe_Mantid\MDMAP15053.nxs,D:\Data\Fe\Fe_Mantid\MDMAP15054.nxs',OutputFilename=r'D:/Data/Fe/Fe_Mantid/tt.nxs',OutputWorkspace='WS4D')

