#!/bin/bash -e

##########################################################################################################
############################################ SCRIPT FOR MD SIMULATION ####################################
##########################################################################################################

# Environmental configuration

export CUDA_VISIBLE_DEVICES=1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-6.5/lib64
export AMBEREXE=$AMBERHOME/bin


# Paths to the input files and creation of the workdir

GFP='GFP.1w7s'
ind_fold='gfp.1w7s'
workdir='../md.gfp.1w7s'
indir_GFP='../../3-system_parametrization/'$ind_fold''
mkdir -p $workdir
cd $workdir

$AMBEREXE/pmemd.cuda_SPFP -O -i min1.in -o $GFP.m1.out -p $indir_GFP/$GFP.top -r $GFP.m1.ncrst -c $indir_GFP/$GFP.crd -ref $indir_GFP/$GFP.crd
$AMBEREXE/pmemd.cuda_SPFP -O -i min2.in -o $GFP.m2.out -p $indir_GFP/$GFP.top -r $GFP.m2.ncrst -c $GFP.m1.ncrst -ref $GFP.m1.ncrst
$AMBEREXE/pmemd.cuda_SPFP -O -i min3.in -o $GFP.m3.out -p $indir_GFP/$GFP.top -r $GFP.m3.ncrst -c $GFP.m2.ncrst -ref $GFP.m2.ncrst
$AMBEREXE/pmemd.cuda_SPFP -O -i min.in -o $GFP.min.out -p $indir_GFP/$GFP.top -r $GFP.min.ncrst -c $GFP.m3.ncrst
#
$AMBEREXE/pmemd.cuda_SPFP -O -i h.in -o $GFP.h.out -p $indir_GFP/$GFP.top -r $GFP.h.ncrst -c $GFP.min.ncrst -x $GFP.h.nc -ref $GFP.min.ncrst
#
$AMBEREXE/pmemd.cuda_SPFP -O -i eq1.in -o $GFP.eq1.out -p $indir_GFP/$GFP.top -r $GFP.eq1.ncrst -c $GFP.h.ncrst -x $GFP.eq1.nc -ref $GFP.min.ncrst
$AMBEREXE/pmemd.cuda_SPFP -O -i eq2.in -o $GFP.eq2.out -p $indir_GFP/$GFP.top -r $GFP.eq2.ncrst -c $GFP.eq1.ncrst -x $GFP.eq2.nc -ref $GFP.min.ncrst
$AMBEREXE/pmemd.cuda_SPFP -O -i eq3.in -o $GFP.eq3.out -p $indir_GFP/$GFP.top -r $GFP.eq3.ncrst -c $GFP.eq2.ncrst -x $GFP.eq3.nc -ref $GFP.min.ncrst
$AMBEREXE/pmemd.cuda_SPFP -O -i eq4.in -o $GFP.eq4.out -p $indir_GFP/$GFP.top -r $GFP.eq4.ncrst -c $GFP.eq3.ncrst -x $GFP.eq4.nc -ref $GFP.min.ncrst
$AMBEREXE/pmemd.cuda_SPFP -O -i eq5.in -o $GFP.eq5.out -p $indir_GFP/$GFP.top -r $GFP.eq5.ncrst -c $GFP.eq4.ncrst -x $GFP.eq5.nc -ref $GFP.min.ncrst

$AMBEREXE/cpptraj $indir_GFP/$GFP.top <<EOF
trajin $GFP.eq5.ncrst
autoimage :64 
center :1-228 origin
trajout $GFP.eq5.orig.ncrst restartnc
go
EOF

ln -sf $GFP.eq5.orig.ncrst $GFP.md0.ncrst

#$AMBERHOME/bin/pmemd.cuda_SPFP -O -i mdRST.in       -o $GFP.mdRST.out -p $indir_GFP/$GFP.top -c $GFP.eq5.ncrst \
#                                  -r $GFP.mdRST.ncrst -x $GFP.mdRST.nc  -ref $GFP.eq5.ncrst -inf $GFP.mdRST.mdinfo
#ln -sf $GFP.mdRST.ncrst $GFP.md0.ncrst
 
for i in {1..10..1}; do
echo run $i
j=$((i-1))
$AMBEREXE/pmemd.cuda_SPFP -O -i mdunrestr.in    -o $GFP.md${i}.out -p $indir_GFP/$GFP.top         -c $GFP.md${j}.ncrst \
                             -r $GFP.md${i}.ncrst -x $GFP.md${i}.nc  -ref $GFP.eq5.ncrst -inf $GFP.md${i}.mdinfo
$AMBEREXE/cpptraj $indir_GFP/$GFP.top <<EOF
trajin $GFP.md${i}.ncrst
autoimage :64 
reference $indir_GFP/$GFP.crd [ini]
rms ref [ini] :1-228@CA :1-228@CA
strip :Na+|:1-228@H=
#To keep the 30 WAT closest to ligand
closest 30 :64 first noimage outprefix closest
trajout $GFP.md${i}.pdb.gz dumpq
go
EOF

done
