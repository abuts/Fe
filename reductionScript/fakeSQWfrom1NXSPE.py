print 'start\n'
cur_ws='wsn';
md_ws='mdws4D';
MDWSF='';
LoadNXSPE(Filename='D:/Data/Fe/Fe_Mantid/MAP'+str(15052)+'.nxspe',OutputWorkspace=cur_ws)
maxNum = 20;
for n in range(1,maxNum):
	print "Step: ",n," of ",maxNum
	AddSampleLog(cur_ws,LogName='Psi',LogText=str(2*n),LogType='Number');
	SetGoniometer(cur_ws,Axis0='Psi,0,1,0,1');
	SetUB(Workspace=cur_ws,a='2.87',b='2.87',c='2.87')
	
	ConvertToMD(InputWorkspace=cur_ws,OutputWorkspace=md_ws,QDimensions='Q3D',QConversionScales='Orthogonal HKL',OverwriteExisting='0',MinValues='-4.2,-4.2,-4.2,-50',MaxValues='8.2,8.2,4.2,350')
	
SaveMD(md_ws,'FeFake_20rot.nxs');
######################################################################
#MergeMDFiles(Filenames='D:\Data\Fe\Fe_Mantid\MDMAP15052.nxs,D:\Data\Fe\Fe_Mantid\MDMAP15053.nxs,D:\Data\Fe\Fe_Mantid\MDMAP15054.nxs',OutputFilename=r'D:/Data/Fe/Fe_Mantid/tt.nxs',OutputWorkspace='WS4D')

