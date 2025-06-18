#! /bin/bash
#echo peptide,full1,full2 > automated_new.csv 
for d in `ls -d $1/*_${2}aa`; do # bash vina_get_results.sh HumanLibrary 8 
# removed b1_smallergrid1.pdbqt model1
   if [ -d $d ] ;
   then
     #python3 ~/mlsc/utils/dist2.py ${d} $2 $3 $4
     python3 ~/mlsc/utils/dist2_Asp320.py ${d} $2 b1_smallergrid1.pdbqt model1  >>  model1.txt
     /bin/grep ATOM ${d}/model1.pdb | sort -n -k 6 > tmp
     mv tmp ${d}/model1.pdb
     echo "END" >> ${d}/model1.pdb
     python3 ~/mlsc/utils/dist2_Asp320.py ${d} $2 b1_smallergrid2.pdbqt model2  | awk '{print ","$3","$5}' >> model2.txt
     /bin/grep ATOM ${d}/model2.pdb | sort -n -k 6 > tmp
     mv tmp ${d}/model2.pdb
     echo "END" >> ${d}/model2.pdb
         python3 ~/mlsc/utils/dist2_Asp320.py ${d} $2 b1_smallergrid3.pdbqt model3  | awk '{print ","$3","$5}'>> model3.txt
     /bin/grep ATOM ${d}/model3.pdb | sort -n -k 6 > tmp
     mv tmp ${d}/model3.pdb
     echo "END" >> ${d}/model3.pdb
   fi
done
echo "Seq,dist1,bind1,dist2,bind2,dist3,bind3" > sequence_${2}.csv 
#sed s/unique_${2}aa\/// model1.txt | sed s/_${2}aa// >  tmp 
paste model1.txt model2.txt model3.txt | sed s/'\t'//g>> sequence_${2}.csv 
#rm model1.txt model2.txt model3.txt
