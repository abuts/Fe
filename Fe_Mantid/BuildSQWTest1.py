# Sample script to build Mantid's combined MD workspace -- Horace sqw equivalent
#config['defaultsave.directory']='/home/wkc26243/Fe400'
#save_dir = config.getString('defaultsave.directory')
save_dir='';
if len(save_dir) ==0 :
    config['defaultsave.directory']=os.getcwd()
    save_dir = config.getString('defaultsave.directory')
print "Data will be saved into: ",save_dir
config.appendDataSearchDir(save_dir)

print 'start\n'
cur_ws='wsn';
md_ws='mdws4D';
MDWSF='';


pars = dict();
pars['InputWorkspace']=''
pars['QDimensions']='Q3D'
pars['dEAnalysisMode']='Direct'
pars['Q3DFrames']='HKL'
pars['QConversionScales']='HKL'
pars['PreprocDetectorsWS']='preprDetMantide'
pars['MinValues']='-3,-3,-3.,-50.0'
pars['MaxValues']='3.,3.,3.,50.0'
pars['SplitInto']=50
pars['MaxRecursionDepth']=1
pars['MinRecursionDepth']=1

for n in xrange(1,231+1):
#for n in xrange(15052,15052+1):
	source = 'MER19566_22.0meV_one2one125.nxspe';
	target  = 'MDMAP_T1'+str(n)+'.nxs';
	if not(os.path.exists(target )):
		print 'Converting ',source
		LoadNXSPE(Filename=source,OutputWorkspace=cur_ws)	
		SetUB(Workspace=cur_ws,a='2.87',b='2.87',c='2.87')
		# save disk space, remove source file (it hshould  be stored somewhere) in arghive
		#os.remove(source);
		# rotated by proper number of degrees around axis Y
		AddSampleLog(Workspace=cur_ws,LogName='Psi',LogText=str(n)+'.',LogType='Number Series')  # -- sample log should be already there 
		SetGoniometer(Workspace=cur_ws,Axis0='Psi,0,1,0,1')

		pars['InputWorkspace']=cur_ws;
		md_ws=ConvertToMD(**pars)

		SaveMD(md_ws,Filename=target  );
		DeleteWorkspace(md_ws);
		DeleteWorkspace(cur_ws);	
		
	if (len(MDWSF) == 0):
		MDWSF = target;
	else:
		MDWSF=MDWSF+','+target;


ws4D = MergeMDFiles(MDWSF,OutputFilename='TestSQW_1.nxs',Parallel='0');
######################################################################


