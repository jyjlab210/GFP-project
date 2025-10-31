#!/bin/bash

##########################################################################################################
#################################### SCRIPT FOR STRUCTURAL ANALYSIS  #####################################
##########################################################################################################



# (1) Paths to the input files and creation of the workdir

GFP='GFP.2wsn'
ind_fold='gfp.2wsn'
workdir='../perl.2wsn'
indir_MD='../../../4-MD_simulations/md.'$ind_fold'/'$GFP''
mkdir -p $workdir
cd $workdir


# Run process_mdout.perl with files h, eq1-eq5 and md1-md10
process_mdout.perl \
        "$indir_MD.h.out" \
        "$indir_MD.eq1.out" \
        "$indir_MD.eq2.out" \
        "$indir_MD.eq3.out" \
        "$indir_MD.eq4.out" \
        "$indir_MD.eq5.out" \
        "$indir_MD.md1.out" \
        "$indir_MD.md2.out" \
        "$indir_MD.md3.out" \
        "$indir_MD.md4.out" \
        "$indir_MD.md5.out" \
        "$indir_MD.md6.out" \
        "$indir_MD.md7.out" \
        "$indir_MD.md8.out" \
        "$indir_MD.md9.out" \
        "$indir_MD.md10.out"
    
    # Keep only files containing energy properties
rm -f *DENSITY* *EKCMT* *ESCF* *PRES* *TEMP* *TSOLUTE* *TSOLVENT* *VOLUME*




