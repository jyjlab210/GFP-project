#!/bin/bash -e

##########################################################################################################
#################################### SCRIPT FOR ENERGETIC ANALYSIS  ######################################
##########################################################################################################



# (1) Paths to the input files and creation of the workdir

GFP='GFP.1w7s'
ind_fold='gfp.1w7s'
workdir='../mmismsa.1w7s'
indir_GFP='../../../3-system_parametrization/'$ind_fold'/'$GFP''
indir_MD='../../../4-MD_simulations/md.'$ind_fold'/'$GFP''
mkdir -p $workdir
cd $workdir


# (2) Create a single ASCII-formatted trajectory file 

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
autoimage :64
reference $indir_GFP.crd [ini]
rms ref [ini] :1-228@CA :1-228@CA
strip :Na+|:Cl-|:WAT outprefix mmismsa
trajout $GFP.md1-10.trj mdcrd
go
quit
eoi

# (3) execute mmismsa

MMISMSA --topology mmismsa.$GFP.top --mdcrd $GFP.md1-10.trj --mask 64 --output mmismsa.$GFP




 

