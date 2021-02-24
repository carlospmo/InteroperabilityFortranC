#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <gnu/lib-names.h>

/* Function pointer type declaration */
typedef void (*contrFunc)(double, double*, double*);

int
main (void)
{
	/* ld declaration */
	void *handle;
	contrFunc func;
	char *error;
	/* variables declaration */
	double torque_d;
	double pitch_d;
	double omega;
	
	printf("Prepare to load the DLL\n");
	handle = dlopen("./example.so", RTLD_LAZY);
	if (!handle) {
		fprintf(stderr, "%s\n", dlerror());
		exit(EXIT_FAILURE);
	}
	printf("DLL loaded successfully\n");
	
	dlerror(); /* Clear any existing error */
	
	func = (contrFunc) 
			dlsym(handle, "example_step");
	
	error = dlerror();
	if (error != NULL) {
		fprintf(stderr, "%s\n", error);
		exit(EXIT_FAILURE);
	}
	printf("Procedure loaded successfully\n");
	omega = 1.1;
	
	func(omega, &torque_d, &pitch_d);
	printf("The torque demanded is %f\n", torque_d);
	printf("The pitch demanded is %f\n", pitch_d);
	dlclose(handle);
	exit(EXIT_SUCCESS);
}
