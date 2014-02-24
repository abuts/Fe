WS_Name='MAP15175'
#Load(Filename=WS_Name+'.raw',OutputWorkspace=WS_Name)
#AddSampleLog(Workspace=WS_Name,LogName='Ei',LogText='3',LogType='Number')
#ConvertUnits(InputWorkspace='CNCS_7860_event',OutputWorkspace='CNCS_7860_event',Target='DeltaE',EMode='Direct',EFixed='3')
#Rebin(InputWorkspace='CNCS_7860_event',OutputWorkspace='CNCS_7860_event',Params='-1,0.05,3',PreserveEvents=False)
Ei=GetEi(InputWorkspace=WS_Name,Monitor1Spec='41474',Monitor2Spec='41475',EnergyEstimate='400');
print Ei
SetUB(Workspace=WS_Name,a='2.87',b='2.87',c='2.87',u='1,0,0',v='0,1,0')
AddSampleLog(Workspace=WS_Name,LogName='Ei',LogText=str(Ei[0]),LogType='Number')

AddSampleLog(Workspace=WS_Name,LogName='Psi',LogText='-18',LogType='Number Series')
SetGoniometer(Workspace=WS_Name,Axis0='Psi,0,1,0,1')
 #SeNXSPE(InputWorkspace='preMDpart'+str(i),Filename='d:/Data/Slicer/MD'+str(i)+'.nxspe',Efixed=3,Psi=i)
ConvertToMDEvents(InputWorkspace=WS_Name,OutputWorkspace=WS_Name+'MD',QDimensions='QhQkQl',dEAnalysisMode='Direct',MinValues='-2,-2,-2,-30',MaxValues='10,10,20,300',SplitInto="20,20,20,20")
#PlusMD(LHSWorkspace='MDpart0',RHSWorkspace='MDpart5',OutputWorkspace='MD')
#PlusMD(LHSWorkspace='MD',RHSWorkspace='MDpart10',OutputWorkspace='MD')
#PlusMD(LHSWorkspace='MD',RHSWorkspace='MDpart15',OutputWorkspace='MD')
plotSlice(WS_Name+'MD', xydim=["Q_x","Q_z"], slicepoint=[0,0] )
