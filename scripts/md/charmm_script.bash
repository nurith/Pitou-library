#!/usr/bin/bash

/home/nurith/Downloads/charmm/charmm < ${1}_get_ini_coor.inp > ${1}_get_ini_coor.out
/home/nurith/Downloads/charmm/charmm < ${1}_mini_ini_coor.inp > ${1}_mini_ini_coor.out
/home/nurith/Downloads/charmm/charmm < ${1}_overlay1_1st_new.inp > ${1}_overlay1_1st_new.out
/home/nurith/Downloads/charmm/charmm < ${1}_overlay1_2nd_new.inp > ${1}_overlay1_2nd_new.out
/home/nurith/Downloads/charmm/charmm < ${1}_add_salt_mk_coor.inp > ${1}_add_salt_mk_coor.out
awk -F " " '{printf ("%-5s %4s %-4s %-4s %9s %9s %9s %s %-4s %9s\n", $1,NR-4,$4,$4,$5,$6,$7,$8,$9,$10)}' ../${1}_acet/temp_cla.crd 

