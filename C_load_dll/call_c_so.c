#include <stdio.h>
#include <dlfcn.h>

int main(void)
{
    void *my_lib_handle;
    int (*some_func)(int a, int b);
    int a = 3;
    int b = 5;
    my_lib_handle = dlopen("libmylib.so", RTLD_NOW);
    if(my_lib_handle==NULL) {
        /* ERROR HANDLING */
    }
    some_func = (int (*)(int, int)) 
        dlsym(my_lib_handle,"some_function");
    if(some_func==NULL) {
        /* ERROR HANDLING */
    }
    printf("Return code is %i\n", (*some_func)(a, b));
    dlclose(my_lib_handle);
    return 0;
}

