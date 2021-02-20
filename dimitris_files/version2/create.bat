 reset
 rm  *.out *.mod

#-- Now the library is created in MATLAB

#-- compile the fortran code/header to load and call the library
 ifort -C -traceback -fpe0 -warn all -o example.out example.f90              #-- create exe file       example.out

#-- run the compiled code
 ./example.out
