#!/bin/bash

##########################################################################################################
# SCRIPT FOR THE PARAMETRIZATION OF GYG CHROMOPHORE AND OBTENTION OF MD INPUT FILES FOR THE 1YFP VARIANT #
##########################################################################################################


#(0) Paths to the input files

workdir='../gfp.1yfp'
indir_GFP='../../1-2-preparation_of_initial_structures/prepared_GFP_variants'
indir_CHR='../../1-2-preparation_of_initial_structures/prepared_chromophores'
CHRO='GYG'
GFP='GFP.1yfp'
mkdir -p $workdir
cd $workdir

#(1)Create  structure data file with charges and amber atom types

antechamber -fi pdb -i $indir_CHR/$CHRO.pdb -bk $CHRO -fo ac -o $CHRO.ac -c bcc -nc 0 -at amber
#sed -i 's/\bNT\b/ N/g' $CHRO-1.ac

#(2)Strip off the atoms at the beginning and the end to make an "amino acid"-like residue that is ready to be connected to other amino acids at its N- and C-termini

cat << EOI > $CHRO.mc

PRE_HEAD_TYPE C
HEAD_NAME N1
MAIN_CHAIN CA1
MAIN_CHAIN C1
MAIN_CHAIN N3
MAIN_CHAIN CA3
OMIT_NAME CH3
OMIT_NAME H31
OMIT_NAME H32
OMIT_NAME H33
OMIT_NAME C
OMIT_NAME O
OMIT_NAME N
OMIT_NAME H11
OMIT_NAME CH4
OMIT_NAME H41
OMIT_NAME H42
OMIT_NAME H43
TAIL_NAME C3
POST_TAIL_TYPE N
CHARGE 0.0

EOI

#(3)Obtain a prep file that contains the definition of the $CHRO residue

prepgen -i $CHRO.ac -o $CHRO.prep -m $CHRO.mc -rn $CHRO

#(4)Check that the covalent parameters (bonds, angles, and dihedrals) and put them in a frcmod file

parmchk2 -i $CHRO.prep -f prepi -o $CHRO.frcmod -a Y -p $AMBERHOME/dat/leap/parm/parm10.dat

#(5)Fill in the parameters that were either not represented at all, or poorly represented, with gaff parameters 

grep -v "ATTN" $CHRO.frcmod > $CHRO.1.frcmod
parmchk2 -i $CHRO.prep -f prepi -o $CHRO.2.frcmod

#(6)create the topology and coordinate files for simulation

cat << EOI > tleap.GFP.in

addPath $AMBERHOME/dat/leap/cmd
addPath $AMBERHOME/dat/leap/lib
addPath $AMBERHOME/dat/leap/parm

source leaprc.protein.ff14SB
source leaprc.water.tip3p
loadoff atomic_ions.lib
loadoff tip3pbox.off
set default PBRadii mbondi3

loadAmberPrep $CHRO.prep
loadAmberParams $CHRO.2.frcmod
loadAmberParams $CHRO.1.frcmod

unit = loadpdb $indir_GFP/$GFP.pdb
check unit

SolvateBox unit TIP3PBOX 12.0 0.9
addions unit Na+ 0
addions unit Cl- 0
SaveAmberParm unit $indir_GFP/$GFP.top $indir_GFP/$GFP.crd
quit

EOI

tleap -f tleap.GFP.in
