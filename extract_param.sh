#!/bin/bash

for f in *\ *; do mv "$f" "${f// /_}"; done 

rm exported_fit.dat

for i in *.csv
do

	echo $i
	N=$(cat $i | grep -m1 "^N;" | head -1 | awk -F ";" '{print $2}')
	s=$(cat $i | grep -m1 "^s;" | head -1 | awk -F ";" '{print $2}')
	R=$(cat $i | grep -m1 "^mu;" | head -1 | awk -F ";" '{print $2}')
	dR=$(cat $i | grep -m1 ";dR;" | head -1 | awk -F ";" '{print $5}')

	mu=$(cat $i | grep -m1 ";;;mu;" | head -1 | awk -F ";" '{print $5}')
	sigma=$(cat $i | grep -m1 ";;;sigma;" | head -1 | awk -F ";" '{print $5}')

	echo $i $N $s $R $nu $dR $mu $sigma >> exported_fit.dat
		
done



