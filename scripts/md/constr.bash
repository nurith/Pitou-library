#!/usr/bin/bash

sed s/" 1.00  1.00    "/" 1.00  5.00    "/ namd-temp.pdb > ${1}_acet_preequ_constr_atoms_kfile_5.pdb
sed s/" 1.00  1.00    "/" 1.00  1.00    "/ namd-temp.pdb > ${1}_acet_preequ_constr_backbone_kfile_1.pdb
sed s/" 1.00  1.00    "/" 1.00  2.00    "/ namd-temp.pdb > ${1}_acet_preequ_constr_backbone_kfile_2.pdb
sed s/" 1.00  1.00    "/" 1.00  3.00    "/ namd-temp.pdb > ${1}_acet_preequ_constr_backbone_kfile_3.pdb
sed s/" 1.00  1.00    "/" 1.00  4.00    "/ namd-temp.pdb > ${1}_acet_preequ_constr_backbone_kfile_4.pdb
sed s/" 1.00  1.00    "/" 1.00  5.00    "/ namd-temp.pdb > ${1}_acet_preequ_constr_backbone_kfile_5.pdb
cp namd-temp.pdb ${1}_acet_preequ_constr_atoms_ref_5.pdb
for fn in `ls ../NGSKRTRR_acet/*.cnfg`; do
   echo $fn
   fname=$(basename $fn)
   newname=`echo $fname | sed s/NGSKRTRR/${1}/`
   echo $newname 
  cp $fn $newname
  sed -i s/NGSKRTRR/${1}/g $newname
done
cp ${1}_acet_namd_salt_charmm.psf ${1}_acet_ion.psf
cp ${1}_acet_namd_salt_charmm.pdb ${1}_acet_ion.pdb
sed s/NGSKRTRR/${1}/g ../NGSKRTRR_acet/production_unity.bash > production_unity.bash
sed -i s/NGSKRTRR/${1}/g production_unity.bash
