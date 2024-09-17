

#AddSampleLog(Workspace=WS_Name,LogName='Psi',LogText='0',LogType='Number Series')
#SetGoniometer(Workspace=WS_Name,Axis0='Psi,1,0,0,1')


WS_Name="RUN_WS"
ic =0;
for n in range(15835,15880):
	in_file = 'MAP'+str(n)+'.RAW';
	LoadRaw(Filename=in_file,OutputWorkspace=WS_Name)
        SetUB(Workspace=WS_Name,a='2.8',b='2.8',c='2.8',u='0,1,0',v='0,0,1')	
	AddSampleLog(Workspace=WS_Name,LogName='Psi',LogText=str(ic),LogType='Number Series')
	SetGoniometer(Workspace=WS_Name,Axis0='Psi,0,1,0,1')
        AddSampleLog(Workspace=WS_Name,LogName='Ei',LogText='200',LogType='Number')	
	MDWS='MD'+str(ic)
	ConvertToMDEvents(InputWorkspace=WS_Name,OutputWorkspace=MDWS,QDimensions='QhQkQl',u='0,1,0',v='0,0,1',dEAnalysisMode='Direct',MinValues='-10,-10,-10,-20',MaxValues='10,10,10,180',SplitInto="20,20,20,20",SplitThreshold=1500,MaxRecursionDepth=1,MinRecursionDepth=1)
	ic = ic+2
	SaveMD(MDWS,MDWS+'.nxs',MakeFileBacked=True)
	DeleteWorkspace(MDWS)
	
