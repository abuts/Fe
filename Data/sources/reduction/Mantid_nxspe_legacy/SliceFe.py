#
Load(Filename='D:/Data/Fe/Fe_Mantid/fe_E400_8K.nxs',OutputWorkspace='fe_E400_8K',FileBackEnd='1')
#
SliceMD(InputWorkspace='fe_E400_8K',AlignedDim0='Q_\\zeta,-0.6,0.6,1',AlignedDim1='Q_\\xi,-12.3403,14.4591,100',AlignedDim2='Q_\\eta,-0.6,0.6,1',AlignedDim3='E,0,380,200',OutputExtents='-0.2,0.2,-12,14,-0.2,0.2,0,400',OutputBins='1,200,1,100',OutputWorkspace='Slice2dAL',TakeMaxRecursionDepthFromInput='0')

SliceMD(InputWorkspace='fe_E400_8K',AxisAligned='0',BasisVector0='d1,A^-1,1,1,0,0',BasisVector1='d2,A^-1,1,-1,0,0',BasisVector2='d3,A^-1,0,0,1,0',BasisVector3='e,mEv,0,0,0,1',OutputExtents='-0.6,0.6,-12,14,-0.6,0.6,0,400',OutputBins='1,100,1,200',OutputWorkspace='Slice1',TakeMaxRecursionDepthFromInput='0')
