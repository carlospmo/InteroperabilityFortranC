 reset
 rm *.o *.out *.mod

#-- create simple library from c (called test.so)
#-- Later it will be loaded and called through fortran code example.f90
 gcc -std=c99 -c -Wall -fpic                        test.c                   #-- create object         test.o
 gcc      -shared                    -o test.so     test.o                   #-- create shared library test.so

#-- compile the fortran code/header to load and call the library
 ifort -C -traceback -fpe0 -warn all -o example.exe example.f90              #-- create exe file       example.out

#-- run the compiled code
 ./example.out
