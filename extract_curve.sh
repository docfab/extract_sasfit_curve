#!/bin/bash

#select scattering vetor unit : angstrom or nm?
scat_vect_unit=A #nm

#intensity range
y_min=0.0001
y_max=100

#remove line from file
for f in *\ *; do mv "$f" "${f// /_}"; done 

#for each *.csv file
for file_name in *.csv
do

	echo $file_name

	#extract data into dat file
	sed -e '1,/Q;I(Q);Delta/d' -e '/size/,$d' $file_name > $file_name.dat

	#select exp pt. and fitted data
	cat $file_name.dat | awk -F ";" '{print $1,$2,$6}' > ${file_name}_all.dat

	#delete empty line
	sed -i '/^$/d' ${file_name}_all.dat

	#delete empty line or line with only space
	sed -i '/^[[:space:]]*$/d' ${file_name}_all.dat

	#create 2 files with exp pt. and fitted data
	cat  ${file_name}_all.dat | awk -F ";" '{print $1,$2}' > ${file_name}_fit.dat
	cat  ${file_name}_all.dat | awk -F ";" '{print $1,$6}' > ${file_name}_exp.dat

	#plot curves in eps format for LaTeX
	gnuplot <<- EOF
		unset key
		set xlabel "q (${scat_vect_unit}^{-1})"
		set ylabel "I(q) (cm^{-1})"
		set term eps size 4, 3
		set output "${file_name}.eps"
		set logscale xy
#		unset ytics
		set yrange [${y_min}:${y_max}]
		plot "${file_name}_exp.dat" using 1:2 with points pt 7 ps 0.5 black title "exp", "${file_name}_fit.dat" using 1:2 with line linecolor rgb "red" lw 2 title "fit"

	rm $file_name.dat

done
