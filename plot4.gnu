set terminal png
set pm3d
set output "P8-20-21-ﬁg4-c2.png"
set term png size 1100, 600


set title  "Mapa de temperatures pel mètode de sobrerelaxació amb tres fonts" 
set title font "Times New Roman,20"
set xlabel font "Times New Roman,12"
set ylabel font "Times New Roman,12"
set xlabel "X[cm]" 
set ylabel "Y[cm]"
!set key outside

set xrange [0:44.5]
set yrange [0:32.5]


plot "check4.dat" w image