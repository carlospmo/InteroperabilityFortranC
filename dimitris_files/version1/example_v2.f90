 module module_type
           use, intrinsic :: iso_c_binding
           type, bind(c) :: type_struct
            integer(c_int) :: i
            real(c_double) :: a
            real(c_double) :: b(2)
           END type type_struct

 END module module_type


PROGRAM Main

  USE, INTRINSIC :: ISO_C_BINDING
  USE :: module_type
 ! IMPLICIT NONE

  INTERFACE 
     FUNCTION LoadLibrary(lpFileName) BIND(C,NAME='LoadLibraryA')
        USE, INTRINSIC :: ISO_C_BINDING
        IMPLICIT NONE 
        CHARACTER(KIND=C_CHAR) :: lpFileName(*) 
        !GCC$ ATTRIBUTES STDCALL :: LoadLibrary 
        INTEGER(C_INTPTR_T) :: LoadLibrary 
     END FUNCTION LoadLibrary 

     FUNCTION GetProcAddress(hModule, lpProcName)  &
         BIND(C, NAME='GetProcAddress')
       USE, INTRINSIC :: ISO_C_BINDING
       IMPLICIT NONE
       !GCC$ ATTRIBUTES STDCALL :: GetProcAddress
       TYPE(C_FUNPTR) :: GetProcAddress
       INTEGER(C_INTPTR_T), VALUE :: hModule
       CHARACTER(KIND=C_CHAR) :: lpProcName(*)
     END FUNCTION GetProcAddress      
  END INTERFACE

  abstract interface
!// 01. void   print_int_var ( int  ii )
!// 02. void   print_int_pnt ( int *ii )
!// 03. int    sum_int_var   ( int  ii, int  jj)
!// 04. int    sum_int_pnt   ( int *ii, int *jj)
!// 05. double sum_dbl_var   (double  input_1, double  input_2) //my_first_so
!// 06. double sum_dbl_pnt   (double *input_1, double *input_2)
!// 07. double sum_vec       (double *x     ,int L)
       subroutine called_print_int_var (i    ) bind(c) !01
           use, intrinsic :: iso_c_binding
           implicit none
           integer(c_int), intent(in ), VALUE :: i
       end subroutine called_print_int_var

       subroutine called_print_int_pnt (i    ) bind(c) !02
           use, intrinsic :: iso_c_binding
           implicit none
           integer(c_int), intent(in ) :: i
       end subroutine called_print_int_pnt

       function   called_sum_int_var   (i ,j ) bind(c) !03
           use, intrinsic :: iso_c_binding
           implicit none
           integer(c_int), intent(in ), VALUE :: i, j
           integer(c_int)              :: called_sum_int_var
       end function   called_sum_int_var

       function   called_sum_int_pnt   (i ,j ) bind(c) !04
           use, intrinsic :: iso_c_binding
           implicit none
           integer(c_int), intent(in ) :: i,j
           integer(c_int)              :: called_sum_int_pnt
       end function   called_sum_int_pnt

       function   called_sum_dbl_var   (a1,a2) bind(c) !05
           use, intrinsic :: iso_c_binding
           implicit none
           real(c_double), intent(in ), VALUE :: a1, a2
           real(c_double)              :: called_sum_dbl_var
       end function   called_sum_dbl_var

       function   called_sum_dbl_pnt   (a1,a2) bind(c) !06
           use, intrinsic :: iso_c_binding
           implicit none
           real(c_double), intent(in ) :: a1,a2
           real(c_double)              :: called_sum_dbl_pnt
       end function   called_sum_dbl_pnt

       function   called_sum_vec       (x ,L ) bind(c) !07
           use, intrinsic :: iso_c_binding
           implicit none
           real(c_double), intent(in ) :: x(*)
           integer(c_int), intent(in ) :: L
           real(c_double)              :: called_sum_vec
       end function   called_sum_vec

!      void my_fifth_so(const struct0_T *estructura, short *output1, double *output2, double output3[2])
       subroutine called_print_struct (struct, out1, out2, out3 ) bind(c)
           use, intrinsic :: iso_c_binding
           use module_type
           implicit none

           type(type_struct),               intent(in   ) :: struct
           integer(c_int)   ,               intent(  out) :: out1
           real(c_double)   ,               intent(  out) :: out2
           real(c_double)   , dimension(2), intent(  out) :: out3 ![value]

       end subroutine called_print_struct

   END interface

  INTEGER(C_INTPTR_T) :: module_handle
  TYPE(C_FUNPTR) :: proc_address
  procedure(called_print_int_var), bind(c), pointer :: print_int_var
  procedure(called_print_int_pnt), bind(c), pointer :: print_int_pnt
  procedure(called_sum_int_var  ), bind(c), pointer :: sum_int_var
  procedure(called_sum_int_pnt  ), bind(c), pointer :: sum_int_pnt
  procedure(called_sum_dbl_var  ), bind(c), pointer :: sum_dbl_var
  procedure(called_sum_dbl_pnt  ), bind(c), pointer :: sum_dbl_pnt
  procedure(called_sum_vec      ), bind(c), pointer :: sum_vec
  procedure(called_print_struct ), bind(c), pointer :: print_struct

  !**** Declare the variables
  type(type_struct) :: crist
  integer(c_int) :: out1
  real(c_double) :: out2
  real(c_double) :: out3(2)
 ! integer :: ii, jj, i, L
 ! real :: 

  !****      Initialize the variables
  integer(c_int) :: ii=2 ,jj=3 , i
  real(c_double) :: aa=2.,bb=3.
  integer(c_int) :: L=100
  real(c_double) :: x(0:99)

  

!--- prepare the vars
  do i =0,L-1
     x(i)=dble(i); write(*,*) i,x(i)
  enddo
  crist%i   =2
  crist%a   =3.
  crist%b(1)=1.
  crist%b(2)=5.
  
!**** LOAD THE DLL
  module_handle = LoadLibrary(C_CHAR_'test.dll' // C_NULL_CHAR)
  IF (module_handle == 0) STOP 'Unable to load DLL'
  
!**** LOAD THE FIRST PROCEDURE
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'print_int_var' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, print_int_var)
  CALL print_int_var(ii)
  
!**** LOAD THE SECOND PROCEDURE
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'print_int_pnt' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, print_int_pnt)
  CALL print_int_pnt(ii)
  
!**** LOAD THE THIRD PROCEDURE
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'sum_int_var' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, sum_int_var)
  WRITE (*,*) sum_int_var(ii, jj)

!**** LOAD THE FORTH PROCEDURE  
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'sum_int_pnt' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, sum_int_pnt)
  WRITE (*,*) sum_int_pnt(ii, jj)
  
!**** LOAD THE FIFTH PROCEDURE 
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'sum_dbl_var' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, sum_dbl_var)
  WRITE (*,*) sum_dbl_var(aa, bb)
  
!**** LOAD THE SIXTH PROCEDURE
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'sum_dbl_pnt' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, sum_dbl_pnt)
  WRITE (*,*) sum_dbl_pnt(aa, bb)
  
!**** LOAD THE SEVENTH PROCEDURE
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'sum_vec' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, sum_vec)
  WRITE (*,*) sum_vec (x, L)
  
!**** LOAD THE EIGTH PROCEDURE
  proc_address = GetProcAddress( module_handle,  &
      C_CHAR_'print_struct' // C_NULL_CHAR )
  IF (.NOT. C_ASSOCIATED(proc_address))  &
      STOP 'Unable to obtain procedure address'
  CALL C_F_PROCPOINTER(proc_address, print_struct)
  CALL print_struct(crist, out1, out2, out3)
  
  WRITE (*,*) out1
  WRITE (*,*) out2
  WRITE (*,*) out3(1:2)

END PROGRAM Main
