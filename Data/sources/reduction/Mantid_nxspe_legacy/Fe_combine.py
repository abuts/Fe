WS_Name="RUN_WS"
ic =0;
i   =0;
MDWSF='';
for n in range(15835,15880):
	MDWSF=MDWSF+'MD'+str(ic)+'.nxs;'
	ic = ic+2
	i = i+1
	
MergeMDFiles(MDWSF,'ws4D',OutputFilename='testWS4D.nxs')
plotSlice('ws4D', xydim=["Q1","Q2"], slicepoint=[0,0] )

