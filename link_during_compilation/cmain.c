#include <stdio.h>

void my_sub (float*, float*, float*);

int main ()
{
	float a = 3;
	float b = 4;
	float c;
	
	my_sub (&a, &b, &c);
	
	printf("a = %f\n b = %f\n c = %f\n", a, b, c);
	return 0;
}