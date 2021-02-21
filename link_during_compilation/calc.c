#include <stdio.h>

void calc (double *a, double *b, double *c)
{
	*c = *a + *b;
	printf(" In C: a + b = %d\n", *c);
}