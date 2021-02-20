 module module_type
           use, intrinsic :: iso_c_binding

           type, bind(c) :: type_statedata
            real(c_double) :: Plant       (44)  !(0:43)   !state1x22, 1st time derivative
            real(c_double) :: Disturbance                 !
            real(c_double) :: LastMove                    ! previous collective pitch
            real(c_double) :: Covariance  (2025)!(0:2024) ! needs to be defined
           END type type_statedata

           type, bind(c) :: type_onlinedata
            real(c_double) :: ym  (2) ! (0:1)             ! omega, tower top acceleration controlled variable
            real(c_double) :: ref (2) ! (0:1)             ! reference =0.
            real(c_double) :: md  (2) ! (0:1)             !81,2  wind speed hub height perturbation Ux-15, electrical torque = 0
           END type type_onlinedata

           type, bind(c) :: type_info
            real(c_double) :: Uopt(  81)!(0:  80)
            real(c_double) :: Yopt( 162)!(0: 161)
            real(c_double) :: Xopt(3645)!(0:3644)
            real(c_double) :: Topt(  81)!(0:  80)
            real(c_double) :: Slack
            real(c_double) :: Iterations
!           char(c_char  ) :: QPCode(0:7)
            real(c_double) :: Cost
           END type type_info

 END module module_type

!statedata_Structure
!typedef struct {
!  double Plant[44];
!  double Disturbance;
!  double LastMove;
!  double Covariance[2025];
!} struct1_T;
!
!!online data_structure
!typedef struct {
!  double ym[2];
!  double ref[2];
!  double md[2];
!} struct3_T;

!typedef struct {
!  double uopt[81];
!  double yopt[162];
!  double xopt[3645];
!  double topt[81];
!  double slack;
!  double iterations;
!  char qpcode[8];
!  double cost;
!} struct6_t;
!---2017
!typedef struct {
!  double Uopt[101];
!  double Yopt[202];
!  double Xopt[4545];
!  double Topt[101];
!  double Slack;
!  double Iterations;
!  char QPCode[8];
!  double Cost;
!} struct6_T;

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

       subroutine called_controller   (struct1, struct2, u, info ) bind(c)
           use, intrinsic :: iso_c_binding
           use module_type
           implicit none

           type(type_statedata ), intent(in   ) :: struct1
           type(type_onlinedata), intent(in   ) :: struct2
           real(c_double)       , intent(  out) :: u
           type(type_info      ), intent(  out) :: info

       end subroutine called_controller

   END interface

   type(c_funptr)                                    :: address !addr_print_int_var, addr_sum_int_var, addr_sum_dbl_var
   type(c_ptr   )                                    :: handle
   procedure(called_controller   ), bind(c), pointer :: controller

   character(256) :: libpath
   character(256) :: procname

   type(type_statedata ) :: statedata
   type(type_onlinedata) :: onlinedata
   real(c_double)        :: u
   type(type_info      ) :: info

   integer               :: i

!--- initialization
   statedata%Plant       (:) = 0.d0; !  [44]
   statedata%Disturbance     = 0.d0;
   statedata%LastMove        = 0.d0;
   statedata%Covariance  (:) = 0.d0; ![2025]
   onlinedata%ym         (:) = 0.d0; !   [2]
   onlinedata%ref        (:) = 0.d0; !   [2]
   onlinedata%md         (:) = 0.d0; !   [2]

   onlinedata%md         (1) = 2.d0; !   [2] !Case1
   onlinedata%ym         (1) =-1.d0; !   [2] !Case2
   onlinedata%ym         (2) = 1.d0; !   [2]
   statedata%Plant       (1) = 0.5d0;!  [44] !Case3
   statedata%LastMove        = 1.d0; !       !Case4 

!--- load the library
   libpath = "./mi_MPC.so"
   handle  = dlopen(trim(libpath)//c_null_char, rtld_lazy)
   if (.not. c_associated(handle)) then
       print*, 'Unable to load DLL'; stop
   endif

!--- test the controller
   procname  = "mpcmoveCodeGeneration"
   address   = dlsym( handle, trim(procname)//c_null_char )
   if ( .not. c_associated(address) ) then
       write(*,*)'Unable to load the procedure', trim(procname); stop
   endif
   call c_f_procpointer(address, controller)
   write(*,*) "test controller"
   call       controller   (statedata, onlinedata, u, info)

   write(*,*) u

 do i=1,5
   statedata%Plant       (:) = 0.d0; !  [44]
   statedata%Disturbance     = 0.d0;
   statedata%LastMove        = 0.d0;
   statedata%Covariance  (:) = 0.d0; ![2025]
   onlinedata%ym         (:) = 0.d0; !   [2]
   onlinedata%ref        (:) = 0.d0; !   [2]
   onlinedata%md         (:) = 0.d0; !   [2]

!  onlinedata%md         (1) = 2.d0; !   [2] !Case1
   onlinedata%md         (1) = dble(i);
   onlinedata%ym         (1) =-1.d0; !   [2] !Case2
   onlinedata%ym         (2) = 1.d0; !   [2]
   statedata%Plant       (1) = 0.5d0;!  [44] !Case3
   statedata%LastMove        = 1.d0; !       !Case4 
   call       controller   (statedata, onlinedata, u, info)
   write(*,'(a,i5,f12.3)') 'i,u', i,u
 enddo

END program example
