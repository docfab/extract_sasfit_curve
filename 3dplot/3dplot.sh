#!/bin/bash

n_i=
n_f=




for ((i = $n_i ; i <= $n_f ; i++))
do

	#find time
	time=$(grep "^$i" temps.dat | awk '{print $2}' | head -1)
	echo "temps = $time min"
	
	paste ${i}_exp* ${i}_fit* | awk '{print $1,$2,$4}' > ${i}.dat

	sed -i "s/$/\t$time/" ${i}.dat	

	sed -i '/-/d' ${i}.dat 

done


#q-range
x_min=0.005
x_max=0.5

#intensity range
z_min=0.0001
z_max=100

#plot curves in eps format for LaTeX
gnuplot <<- EOF
	set zrange [${z_min}:${z_max}]
	set xrange [${x_min}:${x_max}]

	set logscale xz
	set xyplane at 0.001

	file(n) = sprintf("%d.dat",n)

	splot for [i=${n_i}:${n_f}:3] file(i) using 1:4:2 with points pt 7 ps 0.5 black notitle, for [i=${n_i}:${n_f}:3] file(i) using 1:4:3 with line linecolor rgb "red" lw 2 notitle
	
exit









