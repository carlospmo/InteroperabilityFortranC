PROGRAM fortran_calls_c

USE, INTRINSIC :: ISO_C_BINDING

INTERFACE

	SUBROUTINE calc(a, b, c) BIND(C)
		USE, INTRINSIC :: ISO_C_BINDING
		REAL(C_DOUBLE) :: a, b, c
	END SUBROUTINE calc

END INTERFACE

WRITE(*,*) 'Enter a:'
READ(*,*)  a
WRITE(*,*) 'Enter b:'
READ(*,*) b

CALL calc(a, b, c)

WRITE(*,*) 'In Fortran: a + b = ', c

END PROGRAM fortran_calls_c