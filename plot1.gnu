set terminal png
set output "P8-20-21-ﬁg1-c2.png"
set term png size 1100, 600


set title  "Convergència dels mètodes per la temperatura 15ºC" 
set title font "Times New Roman,20"
set xlabel font "Times New Roman,12"
set ylabel font "Times New Roman,12"
set xlabel "Iteracions" 
set ylabel "Temperatura a (x,y)=(18,12.5)[cm]"
set key bottom

plot "check1.dat" i 0 u 1:2 w l lw 2 t"Jacobi T_0= 15ºC","check2.dat" i 0 u 1:2 w l lw 2 t"Gauss-Seidel T_0= 15ºC","check3.dat" i 0 u 1:2 w l lw 2 t"Sobrerelaxació T_0= 15ºC"