# Interoperability Fortran - C

This repository is part of a project consisting in studying, analysing and conducting an effective communication between *Fortran* and *Simulink*, in order to couple **wind turbine controllers** implemented in *Simulink* with the **servo-hydro-aero-elastic software tool _hGAST_**, whose source code is written in *Fortran*. 

## Initial Tests with Dynamic Libraries

The folder [initial_tests](./initial_tests) contains the first tests conducted to understand the dynamic libraries load and call process. These tests were conducted by *Dr. Manolas*, from the *National Technical University of Athens*, with the help in [Version 2](https://github.com/carlospmo/InteroperabilityFortranC/blob/main/README.md#version-2) of *Prof. Dr. Gallego*, from the *Polytechnic University of Madrid*, who generated a shared library from *MATLAB*.

### Version 1. Shared libraries generated from C

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

### Version 2. Shared libraries generated from MATLAB

In this case, the shared library is generated directly from a *MATLAB* code for a *Model Predictive Controller*, the file [mi_MPC.so](./initial_tests/version2/mi_MPC.so) is the shared library generated in *Unix*, and the file [mpcmoveCodeGeneration_types.h](./initial_tests/version2/mpcmoveCodeGeneration_types.h) is the header file where the data types used in the procedure are declared. To inspect the symbols of the shared library and obtain useful information, such as the name of the procedure, one can run the command in *Unix* `nm -D mi_MPC.so`. In *Windows* the program [Dependency Walker](https://www.dependencywalker.com/) can be used for the same purpose.
