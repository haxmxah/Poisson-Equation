# Poisson-Equation
We use Gauss-Seidel, Jacobi and overrelaxation routines.

## Poisson 2D
The aim is to resolve the Poisson equation 2D with Dirichlet boundaries

$$\frac{\partial^2 T}{\partial x^2}+\frac{\partial^2 T}{\partial y^2}+\rho(x,y)=0$$.

Next, we study the convergency of the three methods.

# Compilation and execution of the program
This program was written in _Fortran_ 77 and the graphics were plotted with _Gnuplot_.
## Linux and Mac
### Compilation

```
gfortran -name_of_the_file.f -o name_of_the_output_file.out
```
### Execution
```
./name_of_the_output_file.out
```

## Windows
### Compilation
```
gfortran -name_of_the_file.f -o name_of_the_output_file.exe
```
### Execution
```
./name_of_the_output_file.exe
```
