from Bio.PDB.PDBParser import PDBParser
import numpy
import sys
import os
from Bio.PDB.PDBIO import PDBIO

# Example: python3 ~/mlsc/utils/dist.py ViralLibrary/NP_040154.2mini_10aa 10 b1_smallergrid1.pdbqt model1
# This version just minimizes the energy

pathname = "/home/nurith/mlsc/docking/" + sys.argv[1] #+ "/out_full_b1.pdbqt"
def search_ene(ligname):
    binding = []
    # string to search in file
    with open(ligname, 'r') as fp:
       # read all lines using readline()
       lines = fp.readlines()
       for row in lines:
          # check if string present on a current line
          word = 'VINA'
          #print(row.find(word))
          # find() method returns -1 if the value is not found,
          # if found it returns index of the first occurrence of the substring
          if row.find(word) != -1:
             fields = row.split()
             binding.append(fields[3]) # Binding energy
    return binding
   
parser = PDBParser(PERMISSIVE = True, QUIET = True)

rec = parser.get_structure("LIGAND", "/home/nurith/mlsc/docking/6TKK_ReceptorMini.pdbqt")
# Create a list of all the residues
models = rec.get_list()
chains = models[0].get_list()
resids = chains[0].get_list()
asp320 = resids[50]
dists = []
models = []

def find_dist(ligname):
   residues = []
   ligand = parser.get_structure("LIGAND", ligname)
   for model in ligand.get_list():
      for chain in model.get_list():
         for residue in chain.get_list():
            if residue.get_resname() == "ARG" and residue.id[1] == int(sys.argv[2]):
               residues.append(residue)
               diffasp320 = residue["CZ"].get_coord() - asp320["CG"].get_coord()
               avdist = numpy.sqrt(numpy.sum(diffasp320 * diffasp320))
               #print(avdist)
               dists.append(avdist)
               c = chain.get_id()
               chain.id = "B"
               models.append(chain)
   return models, dists

for names in os.listdir(pathname):
   #print(names, sys.argv[3])
   if(names.endswith(sys.argv[3])):
      [models,dists] = find_dist(pathname + "/" + names)
      binding = search_ene(pathname + "/" + names)   
      i=0
      for dist in dists:    
      	if(dist < 6.0):
           #   print(sys.argv[1],",","{:.2f}".format(dists[i]),",", i+1,"," ,binding[i])
           print(sys.argv[1],",","{:.2f}".format(dists[i]),"," ,binding[i]) # No need for rank anymore
           break
      	i=i+1
      # save the pdb file 
      if(i == 9): # Nothing inside the binding site, print the closest.
      	 #print(sys.argv[1],",","{:.2f}".format(numpy.min(dists)),",", numpy.argmin(dists)+1,"," ,binding[numpy.argmin(dists)])
      	 print(sys.argv[1],",","{:.2f}".format(numpy.min(dists)),",",binding[numpy.argmin(dists)])
      	 i = numpy.argmin(dists)
      io=PDBIO()
      io.set_structure(models[i])
      io.save(pathname + "/" + sys.argv[4] + ".pdb")
      #io.save(pathname + "/" + sys.argv[4] + "_" + str(i+1) + ".pdb") # for example 
   # Calculate the distance between the alpha carbons for a pair of residues
