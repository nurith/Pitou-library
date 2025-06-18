#!/usr/bin/bash

sed s/" 1.00  1.00    "/" 1.00  5.00    "/ namd-temp.pdb > ${2}_acet_preequ_constr_atoms_kfile_5.pdb
sed s/" 1.00  1.00    "/" 1.00  1.00    "/ namd-temp.pdb > ${2}_acet_preequ_constr_backbone_kfile_1.pdb
sed s/" 1.00  1.00    "/" 1.00  2.00    "/ namd-temp.pdb > ${2}_acet_preequ_constr_backbone_kfile_2.pdb
sed s/" 1.00  1.00    "/" 1.00  3.00    "/ namd-temp.pdb > ${2}_acet_preequ_constr_backbone_kfile_3.pdb
sed s/" 1.00  1.00    "/" 1.00  4.00    "/ namd-temp.pdb > ${2}_acet_preequ_constr_backbone_kfile_4.pdb
sed s/" 1.00  1.00    "/" 1.00  5.00    "/ namd-temp.pdb > ${2}_acet_preequ_constr_backbone_kfile_5.pdb
cp namd-temp.pdb ${2}_acet_preequ_constr_atoms_ref_5.pdb
cp ${2}_acet_namd_salt_charmm.psf ${2}_acet_ion.psf
cp ${2}_acet_namd_salt_charmm.pdb ${2}_acet_ion.pdb
sed s/${1}/${2}/g ../${1}_acet/production_unity.bash > production_unity.bash
for fn in `ls ../${1}_acet/*.cnfg`; do
   echo $fn
   fname=$(basename $fn)
   newname=`echo $fname | sed s/${1}/${2}/`
   echo $newname 
  cp $fn $newname
done
find . -name "*.cnfg" -exec sed -i s/${1}/${2}/g {} \;
