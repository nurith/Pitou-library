#! /bin/bash -v
# Prepare a 6 amino acid peptides
for b in `cat $1` ; do # Ex: bash vina_create_6aa.sh RXXR_6.csv unique_6aa
    echo Processing ligand $b
   
    if [ ! -d ${2}/${b}_6aa ] ; then 
       #create the structure
       sed s/AAAAAA/${b}/ script.txt > script_${b}.txt
      # pymol -cq tmp.pml
      chimerax --nogui < script_${b}.txt > out.txt
       mv ${b}.pdb $2
       mkdir -p ${b}_6aa
       # Prepare the 4-version if it's not there yet
       if [ ! -f ${b}_6aa/${b}_6aa_full.pdbqt ] ; then
          # minimize the structure
          #/bin/grep ATOM ${2}/${b}.pdb | /bin/grep -v H[A-D] | /bin/grep -v " HE"| /bin/grep -v "[0-9,H]HE"> ${b}_6aa/tmp.pdb # HA doesn't work for glycine and H[B-E] doesn't work for HIS.
          /bin/grep ATOM ${2}/${b}.pdb | /bin/grep -v H[1-9] |  /bin/grep -v [0-9]H > ${b}_6aa/tmp.pdb
          chimera --nogui ${b}_6aa/tmp.pdb < script_ch.txt >& ${b}_6aa/chimera_out.txt
      #    rm ${b}_6aa/tmp.pdb
          mv min1.pdb ${b}_6aa/${b}_6aa.pdb
        #  obabel -ipdb ${2}/${b}.pdb -O ${b}_6aa/${b}_6aa.pdb --minimize --noh --log --crit 1e-06 --ff UFF --steps 2500 --rvdw 10 --rele 10 --freq 101
          ~/Downloads/mgltools_x86_64Linux2_1.5.6/bin/python2.5 ~/Downloads/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ${b}_6aa/${b}_6aa.pdb -v -o ${b}_6aa/${b}_6aa_full.pdbqt
       fi
    date
        ~/Downloads/PyRx/bin/vina --config Vina_Parameters_B1_6aa.txt --ligand ${b}_6aa/${b}_6aa_full.pdbqt --out ${b}_6aa/${b}_6aa_b1_smallergrid1.pdbqt --log ${b}_6aa/${b}_6aa_b1_smallergrid1.log 
        ~/Downloads/PyRx/bin/vina --config Vina_Parameters_B1_6aa.txt --ligand ${b}_6aa/${b}_6aa_full.pdbqt --out ${b}_6aa/${b}_6aa_b1_smallergrid2.pdbqt --log ${b}_6aa/${b}_6aa_b1_smallergrid2.log   
        ~/Downloads/PyRx/bin/vina --config Vina_Parameters_B1_6aa.txt --ligand ${b}_6aa/${b}_6aa_full.pdbqt --out ${b}_6aa/${b}_6aa_b1_smallergrid3.pdbqt --log ${b}_6aa/${b}_6aa_b1_smallergrid3.log
        mv ${b}_6aa ${2}
    fi
    date
done
