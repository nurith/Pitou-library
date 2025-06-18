#! /bin/bash
# Prepare a 8 amino acid peptides
for b in `cat $1` ; do # Ex: bash vina_create_8aa.sh 8aa_seq.csv unique_8aa
    echo Processing ligand $b
   
    if [ ! -d ${2}/${b}_8aa ] ; then 
       sed s/AAAAAA/${b}/ script.txt > script_${b}.txt
      # pymol -cq tmp.pml
       chimerax --nogui < script_${b}.txt > out.txt
       #create the structure
       mv ${b}.pdb $2
       mkdir -p ${b}_8aa
       # Prepare the 8-version if it's not there yet
       if [ ! -f ${b}_8aa/${b}_8aa_full.pdbqt ] ; then
          # minimize the structure
            /bin/grep ATOM ${2}/${b}.pdb | /bin/grep -v H[A-D,H,1-9] | /bin/grep -v "[0-9,H]H[A-H]"> ${b}_8aa/tmp.pdb # HA doesn't work for glycine and H[B-E] doesn't work for HIS.
          chimera --nogui ${b}_8aa/tmp.pdb < script_ch.txt>& ${b}_8aa/chimera_out.txt
         # rm ${b}_8aa/tmp.pdb
          mv min1.pdb ${b}_8aa/${b}_8aa.pdb
        #  obabel -ipdb ${2}/${b}.pdb -O ${b}_8aa/${b}_8aa.pdb --minimize --noh --log --crit 1e-06 --ff UFF --steps 2500 --rvdw 10 --rele 10 --freq 101
          ~/Downloads/mgltools_x86_64Linux2_1.5.6/bin/python2.5 ~/Downloads/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ${b}_8aa/${b}_8aa.pdb -v -o ${b}_8aa/${b}_8aa_full.pdbqt
       fi
    date
  #  if  [ ! -f $2/${b}/${b}_rerun_b1_1.pdbqt ] ; then
  #  	echo $b
        ~/Downloads/PyRx/bin/vina --config Vina_Parameters_B1_8aa.txt --ligand ${b}_8aa/${b}_8aa_full.pdbqt --out ${b}_8aa/${b}_8aa_b1_smallergrid1.pdbqt --log ${b}_8aa/${b}_8aa_b1_smallergrid1.log 
        ~/Downloads/PyRx/bin/vina --config Vina_Parameters_B1_8aa.txt --ligand ${b}_8aa/${b}_8aa_full.pdbqt --out ${b}_8aa/${b}_8aa_b1_smallergrid2.pdbqt --log ${b}_8aa/${b}_8aa_b1_smallergrid2.log   
        ~/Downloads/PyRx/bin/vina --config Vina_Parameters_B1_8aa.txt --ligand ${b}_8aa/${b}_8aa_full.pdbqt --out ${b}_8aa/${b}_8aa_b1_smallergrid3.pdbqt --log ${b}_8aa/${b}_8aa_b1_smallergrid3.log
       mv ${b}_8aa ${2}
    fi
    date
done
