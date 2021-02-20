/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: mpcmoveCodeGeneration_types.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 10-May-2018 18:57:01
 */

#ifndef MPCMOVECODEGENERATION_TYPES_H
#define MPCMOVECODEGENERATION_TYPES_H

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  double Plant[44];
  double Disturbance;
  double LastMove;
  double Covariance[2025];
} struct1_T;

#endif                                 /*typedef_struct1_T*/

#ifndef typedef_struct3_T
#define typedef_struct3_T

typedef struct {
  double ym[2];
  double ref[2];
  double md[162];
} struct3_T;

#endif                                 /*typedef_struct3_T*/

#ifndef typedef_struct2_T
#define typedef_struct2_T

typedef struct {
  struct3_T signals;
} struct2_T;

#endif                                 /*typedef_struct2_T*/

#ifndef typedef_struct6_T
#define typedef_struct6_T

typedef struct {
  double Uopt[81];
  double Yopt[162];
  double Xopt[3645];
  double Topt[81];
  double Slack;
  double Iterations;
  char QPCode[8];
  double Cost;
} struct6_T;

#endif                                 /*typedef_struct6_T*/
#endif

/*
 * File trailer for mpcmoveCodeGeneration_types.h
 *
 * [EOF]
 */
