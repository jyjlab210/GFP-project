#!/bin/bash 

##########################################################################################################
#################################### SCRIPT FOR STRUCTURAL ANALYSIS  #####################################
##########################################################################################################



# (1) Paths to the input files and creation of the workdir

GFP='GFP.1bfp'
ind_fold='gfp.1bfp'
workdir='../cpptraj.1bfp'
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
autoimage :65
reference $indir_MD.min.ncrst [min]
rmsd first :1-227@CA out ${GFP}.rmsd.dat
rmsd first :65 out SHG.rmsd.dat
atomicfluct out ${GFP}_atomic-fluctuations-md.dat :1-227 byres
hbond donormask :1-64,66-227 acceptormask :SHG@O2,O3,OG1,N1,N2,N3,ND1,NE2 out ${GFP}_nHBacc.dat avgout ${GFP}_avgHBacc.dat
hbond donormask :SHG@N1,ND1,OG1 acceptormask :1-64,66-227@O,OD1,OD2,OE1,OE2,OG,OG1,OH,NE2,ND1 out ${GFP}_nHBdon.dat avgout ${GFP}_avgHBdon.dat
go
quit
eoi
