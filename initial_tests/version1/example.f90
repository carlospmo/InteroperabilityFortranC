 module module_type
           use, intrinsic :: iso_c_binding
           type, bind(c) :: type_struct
            integer(c_int) :: i
            real(c_double) :: a
            real(c_double) :: b(2)
           END type type_struct

 END module module_type

 program example

 use iso_c_binding
 use module_type

   implicit none

   integer(c_int), parameter :: rtld_lazy=1 ! value extracte from the C header file
!  integer(c_int), parameter :: rtld_now =2 ! value extracte from the C header file

!---- interface to linux API
   interface
       function dlopen(filename,mode) bind(c,name="dlopen")
           ! void *dlopen(const char *filename, int mode);
           use iso_c_binding
           implicit none
           type     (c_ptr )             :: dlopen
           character(c_char), intent(in) :: filename(*)
           integer  (c_int ), value      :: mode
       end function

       function dlsym(handle,name) bind(c,name="dlsym")
           ! void *dlsym(void *handle, const char *name);
           use iso_c_binding
           implicit none
           type(c_funptr)                :: dlsym
           type(c_ptr   )   , value      :: handle
           character(c_char), intent(in) :: name(*)
       end function

       function dlclose(handle) bind(c,name="dlclose")
           ! int dlclose(void *handle);
           use iso_c_binding
           implicit none
           integer(c_int)        :: dlclose
           type   (c_ptr), value :: handle
       end function
   END interface


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
           integer(c_int), intent(in ) :: i[value]
       end subroutine called_print_int_var

       subroutine called_print_int_pnt (i    ) bind(c) !02
           use, intrinsic :: iso_c_binding
           implicit none
           integer(c_int), intent(in ) :: i
       end subroutine called_print_int_pnt

       function   called_sum_int_var   (i ,j ) bind(c) !03
           use, intrinsic :: iso_c_binding
           implicit none
           integer(c_int), intent(in ) :: i[value], j[value]
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
           real(c_double), intent(in ) :: a1[value], a2[value]
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

   type(c_funptr)                                    :: address !addr_print_int_var, addr_sum_int_var, addr_sum_dbl_var
   type(c_ptr   )                                    :: handle
   procedure(called_print_int_var), bind(c), pointer :: print_int_var
   procedure(called_print_int_pnt), bind(c), pointer :: print_int_pnt
   procedure(called_sum_int_var  ), bind(c), pointer :: sum_int_var
   procedure(called_sum_int_pnt  ), bind(c), pointer :: sum_int_pnt
   procedure(called_sum_dbl_var  ), bind(c), pointer :: sum_dbl_var
   procedure(called_sum_dbl_pnt  ), bind(c), pointer :: sum_dbl_pnt
   procedure(called_sum_vec      ), bind(c), pointer :: sum_vec
   procedure(called_print_struct ), bind(c), pointer :: print_struct

   character(256) :: libpath
   character(256) :: procname

   integer(c_int) :: ii=2 ,jj=3 , i
   real(c_double) :: aa=2.,bb=3.
   integer(c_int) :: L=100
   real(c_double) :: x(0:99)

   type(type_struct) :: crist
   integer(c_int) :: out1
   real(c_double) :: out2
   real(c_double) :: out3(2)

!--- prepare the vars
   do i =0,L-1
      x(i)=dble(i); write(*,*) i,x(i)
   enddo
   crist%i   =2
   crist%a   =3.
   crist%b(1)=1.
   crist%b(2)=5.


!--- load the library
   libpath = "./test.so"
   handle  = dlopen(trim(libpath)//c_null_char, rtld_lazy)
   if (.not. c_associated(handle)) then
       print*, 'Unable to load DLL'; stop
   endif


!--- Test the simple programs

!--- How to pass var (instead of pointer) in fortran??
!--- test 01
   procname  = "print_int_var"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, print_int_var)
   write(*,*) "test 01 - input", ii
   call print_int_var (ii)

!--- test 02
   procname  = "print_int_pnt"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, print_int_pnt)
   write(*,*) "test 02 - input", ii
   call print_int_pnt (ii)

!--- test 03
   procname  = "sum_int_var"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, sum_int_var)
   write(*,*) "test 03 - inputs", ii, jj
   write(*,*) sum_int_var (ii,jj)

!--- test 04
   procname  = "sum_int_pnt"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, sum_int_pnt)
   write(*,*) "test 04 - inputs", ii, jj
   write(*,*) sum_int_pnt (ii,jj)

!--- test 05
   procname  = "sum_dbl_var"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, sum_dbl_var)
   write(*,*) "test 05 - inputs", aa, bb
   write(*,*) sum_dbl_var (aa,bb)

!--- test 06
   procname  = "sum_dbl_pnt"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, sum_dbl_pnt)
   write(*,*) "test 06 - inputs", aa, bb
   write(*,*) sum_dbl_var (aa,bb)

!--- test 07
   procname  = "sum_vec"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, sum_vec)
   write(*,*) "test 07 - inputs", x(0),x(L-1), L
   write(*,*) sum_vec     (x,L)

!--- test 08
   procname  = "print_struct"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, print_struct)
   write(*,*) "test 08 - inputs", crist%i, crist%a, crist%b(1:2)
   call       print_struct (crist,out1,out2,out3)

   write(*,*) out1
   write(*,*) out2
   write(*,*) out3(1:2)


END program example
