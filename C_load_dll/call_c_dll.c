#include <windows.h>
#include <stdio.h>

// DLL function signature
typedef void (*importFunction1)(int);
typedef void (*importFunction2)(double);
typedef double (*importFunction3)(double, double);

int main(void)
{
	importFunction1 printInt;
	importFunction2 printDbl;
	importFunction3 addDbl;
	HINSTANCE hinstLib;
	double result;
	// Load DLL file
	hinstLib = LoadLibrary(TEXT("test1.dll"));
	if (hinstLib == NULL) {
		printf("ERROR: unable to load DLL\n");
		return 1;
	}
	// Get function 1 pointer
	printInt = (importFunction1) 
			GetProcAddress(hinstLib, "print_in_var");
	if (printInt == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	// Call function.
	printInt(6);
	// Get function 2 pointer
	printDbl = (importFunction2) 
			GetProcAddress(hinstLib, "print_dbl_var");
	if (printDbl == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	// Call function.
	printInt(6.5);
	// Get function 3 pointer
	addDbl = (importFunction3) 
			GetProcAddress(hinstLib, "add_dbl_var");
	if (addDbl == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	// Call function.
	result = addDbl(3.5, 4.5);
	printf("The result of the addition is %f\n", result);
	// Unload DLL file
	FreeLibrary(hinstLib);
	return 0;
}