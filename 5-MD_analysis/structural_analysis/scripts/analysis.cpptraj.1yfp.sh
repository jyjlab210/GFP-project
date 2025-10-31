#!/bin/bash 

##########################################################################################################
#################################### SCRIPT FOR STRUCTURAL ANALYSIS  #####################################
##########################################################################################################



# (1) Paths to the input files and creation of the workdir

GFP='GFP.1yfp'
ind_fold='gfp.1yfp'
workdir='../cpptraj.1yfp'
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
autoimage :63
reference $indir_MD.min.ncrst [min]
rmsd first :1-225@CA out ${GFP}.rmsd.dat
rmsd first :63 out GYG.rmsd.dat
atomicfluct out ${GFP}_atomic-fluctuations-md.dat :1-225 byres
hbond donormask :1-62,64-225 acceptormask :GYG@O2,O3,OH,N1,N2,N3 out ${GFP}_nHBacc.dat avgout ${GFP}_avgHBacc.dat
hbond donormask :GYG@N1,OH acceptormask :1-62,64-225@O,OD1,OD2,OE1,OE2,OG,OG1,OH,NE2,ND1 out ${GFP}_nHBdon.dat avgout ${GFP}_avgHBdon.dat
go
quit
eoi
