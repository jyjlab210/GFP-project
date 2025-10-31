#!/bin/bash 

##########################################################################################################
#################################### SCRIPT FOR STRUCTURAL ANALYSIS  #####################################
##########################################################################################################



# (1) Paths to the input files and creation of the workdir

GFP='GFP.2wsn'
ind_fold='gfp.2wsn'
workdir='../cpptraj.2wsn'
indir_GFP='../../../3-system_parametrization/'$ind_fold'/'$GFP''
indir_MD='../../../4-MD_simulations/md.'$ind_fold'/'$GFP''
mkdir -p $workdir
cd $workdir

# (2) create file analysis.in 

cpptraj -p $indir_GFP.top <<eoi
trajin $indir_MD.md1.nc
trajin $indir_MD.md2.nc
trajin $indir_MD.md3.nc
trajin $indir_MD.md4.nc
trajin $indir_MD.md5.nc
trajin $indir_MD.md6.nc
trajin $indir_MD.md7.nc
trajin $indir_MD.md8.nc
trajin $indir_MD.md9.nc
trajin $indir_MD.md10.nc
autoimage :62
reference $indir_MD.min.ncrst [min]
rmsd first :1-225@CA out ${GFP}.rmsd.dat
rmsd first :62 out TWG.rmsd.dat
atomicfluct out ${GFP}_atomic-fluctuations-md.dat :1-225 byres
hbond donormask :1-61,63-225 acceptormask :TWG@O2,O3,OG1,N1,N2,N3,NE1 out ${GFP}_nHBacc.dat avgout ${GFP}_avgHBacc.dat
hbond donormask :TWG@N1,NE1,OG1 acceptormask :1-61,63-225@O,OD1,OD2,OE1,OE2,OG,OG1,OH,NE2,ND1 out ${GFP}_nHBdon.dat avgout ${GFP}_avgHBdon.dat
go
quit
eoi
