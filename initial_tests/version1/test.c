#include <stdio.h>
#include <stdlib.h> //maloc, sizeof


// 01. print integer communicated as variable
void print_int_var ( int  ii )
{
  printf ( "%d\n"  ,  ii );

  return;
}

// 02. print integer communicated as pointer
void print_int_pnt ( int *ii )
{
  printf ( "%d\n"  , *ii );

  return;
}

// 03. function sum of 2 integers communicated as variables
int sum_int_var ( int   ii, int  jj)
{
  return  ii+ jj;
}

// 04. function sum of 2 integers communicated as pointers
int sum_int_pnt ( int  *ii, int *jj)
{
  return *ii+*jj;
}

// 05. function sum of 2 doubles  communicated as variables
double sum_dbl_var (double input_1, double input_2) //my_first_so
{
  return input_1 + input_2;
}

// 06. function sum of 2 doubles  communicated as pointers
double sum_dbl_pnt (double *input_1, double *input_2) //my_first_so
{
  return *input_1 + *input_2;
}

// 07. function sum of L doubles  communicated as pointer
double sum_vec (double *x,int *L)
{

  double tmp=0.;

  for (int i=0;i<*L;++i) {
     tmp+=x[i]; 
  }
  return tmp;
}

// 08. subroutine getting as an input a structure
typedef struct {
  int    i;
  double a;
  double b[2];
} struct0_T;

//void  print_struct (const struct0_T *estructura, short *output1, double *output2, double output3[2])
  void  print_struct (const struct0_T *estructura, int   *output1, double *output2, double output3[2])
{
  int i0;
  *output1 = estructura->i;
  *output2 = estructura->a;
  for (i0 = 0; i0 < 2; i0++) {
    output3[i0] = estructura->b[i0];
  }
}

/*

// This is a simple main program in c to call the above routines //
void main(void)
{
// prepare the input vars
  int    ii = 2 ;  int    jj = 3;
  double aa = 2.;  double bb = 3.;
  int     L = 100;
  double *x = NULL;
  x         = (double*) malloc(L*sizeof(double));

  for (int i=0;i<L;++i) {
     *(x+i)=(double)i;       //x[i]=i;
  }

// call & test the simple routines
             print_int_var     (  ii     );                             //  call 01
             print_int_pointer ( &ii     );                             //  call 02
  int   isum = sum_int_pointer ( &ii, &jj); printf ("%d \n", isum);     //  call 03
        isum = sum_int_var     (  ii,  jj); printf ("%d \n", isum);     //  call 04
  double sum = sum_dbl_var     (  aa,  bb); printf ("%lf\n",  sum);     //  call 05
         sum = sum_dbl_pointer ( &aa, &bb); printf ("%lf\n",  sum);     //  call 06
         sum = sum_vec         (   x,  &L); printf ("%lf\n",  sum);     //  call 07
// printf ("%lf\n", (x[0]+x[L-1])*L/2.); GAUSS
}
*/
