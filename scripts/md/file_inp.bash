#!/usr/bin/bash

for fn in `ls old_scripts/${1}*.inp`; do
   echo $fn
   fname=$(basename $fn)
   newname=`echo $fname | sed s/${1}/${2}/`
   echo $newname 
  cp $fn $newname
  sed -i s/${1}/${2}/g $newname
done
