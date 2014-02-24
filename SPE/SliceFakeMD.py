from numpy import *

def bin_xy(InwsName,eMin,eMax,z0):
    EnRange='DeltaE,'+str(eMin)+','+str(eMax)+',1'
    if eMin<0:
        eTag = 'm'+str(abs(eMin));
    else:
        eTag = str(eMin)
    slice_name = 'sliceXY_E'+eTag
    zMin = z0-0.2;
    zMax= z0+0.2;    
    zPos = '[0,0,L],'+str(zMin)+','+str(zMax)+',1'
    hw=BinMD(InputWorkspace=InwsName,AlignedDim0='[H,0,0],-1,5,121',AlignedDim1='[0,K,0],-3,5,161',AlignedDim2=zPos,AlignedDim3=EnRange,OutputWorkspace=slice_name)
    return (hw,slice_name)

def bin_xz(InwsName,eMin,eMax,y0):
    EnRange='DeltaE,'+str(eMin)+','+str(eMax)+',1'
    if eMin<0:
        eTag = 'm'+str(abs(eMin));
    else:
        eTag = str(eMin)

    yMin = y0-0.2;
    yMax = y0+0.2;    
    yPos = '[0,K,0],'+str(yMin)+','+str(yMax)+',1'
	
    slice_name = 'sliceXZ_E'+eTag
    hw=BinMD(InputWorkspace=InwsName,AlignedDim0='[H,0,0],-1,1,40',AlignedDim1=yPos,AlignedDim2='[0,0,L],-2.3,2.3,95',AlignedDim3=EnRange,OutputWorkspace=slice_name)
    return (hw,slice_name)


def write_slice(hw,slice_name):    
    signal=hw.getSignalArray();
    nEvents=hw.getNumEventsArray();
    
    f=open(slice_name+'.txt','w')
    ranges = signal.shape;
    if len(ranges)!=2:
	    raise IOError(' writing slice expects 2D histogram workspace')
    
    #ax0=hw.getAxis(0);
    #ax1=hw.getAxis(1);

    for i in range(0,ranges[0]):        
        for j in range(0,ranges[1]):        
            if (nEvents[i,j]>0):
                rez = signal[i,j]/nEvents[i,j]
                f.write('%10g' % rez);
            else:
                rez= 0
                f.write('%10g' % rez);            
        f.write('\n')        
    f.close();    
    DeleteWorkspace(hw)
          
fileName='FeFake_025.nxs'
wsName = 'FeFake_025'

try:
    ws=mtd[wsName];
except KeyError: 
    Load(fileName,OutputWorkspace=wsName)
 
(ws,slName) = bin_xy(wsName,30,40,0)
write_slice(ws,slName)
(ws,slName) = bin_xy(wsName,-5,5,0)
write_slice(ws,slName)
(ws,slName) = bin_xy(wsName,10,20,0)
write_slice(ws,slName)
(ws,slName) = bin_xy(wsName,60,70,0)
write_slice(ws,slName)
(ws,slName) = bin_xz(wsName,-5,5,0)
write_slice(ws,slName)

(ws,slName) = bin_xz(wsName,-5,5,-1.6)
write_slice(ws,slName)
(ws,slName) = bin_xz(wsName,10,20,-1.6)
write_slice(ws,slName)

(ws,slName) = bin_xz(wsName,40,50,-1.6)
write_slice(ws,slName)

nalWSname = 'nalSliceE30'
BinMD(InputWorkspace='FeFake_025',AxisAligned='0',BasisVector0='"[1:1:0]","A-^1",1,1,0,0',BasisVector1='"[1:-1:0]","A-^1",1,-1,0,0',
      BasisVector2='"[0:0:1]","A-^1",0,0,1,0',BasisVector3='"dE","mEv",0,0,0,1',OutputExtents='-4,4,-4,4,-0.2,0.2,30,40',
      OutputBins='100,100,1,1',OutputWorkspace=nalWSname)
nalWS=mtd[nalWSname]
write_slice(nalWS,nalWSname)      



