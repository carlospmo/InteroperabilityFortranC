# Interoperability Fortran C

## Dimitris Files

The folder [initial_tests](./initial_tests) contains the first tests conducted to understand the dynamic libraries load and call process.

### Version 1

In the **Version 1** the *shared library* is created from the file [test.c](./initial_tests/version1/test.c), containing a series of functions. The file [example.f90](./initial_tests/version1/example.f90) contains the code in *Fortran* used for loading the shared library and calling its procedures.

The batch file [create.bat](./initial_tests/version1/create.bat) can be executed to generate the shared library, compile [example.f90](./initial_tests/version1/example.f90) and execute the output file in *Unix*.

The file [example_v2.f90](./initial_tests/version1/example_v2.f90) contains the necessary code to load and call the shared library on *Windows*. To generate the shared library on *Windows* the following command can be used
```
gcc -shared -fPIC -o test.dll test.c
```

Then, to compile the *Fortran* code on Windows simply type
```
gfortran example_v2.f90 -lknernel32 -o example.exe
```

### Version 2

