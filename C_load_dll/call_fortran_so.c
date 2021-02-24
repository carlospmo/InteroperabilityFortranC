#include <stdio.h>
#include <dlfcn.h>

int main(void)
{
    void *my_lib_handle;
    void (*some_func)(float *a,float *b, float *c);
    float a = 3;
    float b = 5;
    float c;
    my_lib_handle = dlopen("./libfort.so", RTLD_NOW);
    if(my_lib_handle==NULL) {
        /* ERROR HANDLING */
    }
    some_func = (void (*)(float*, float*, float*))
                 dlsym(my_lib_handle,"my_sub");
    if(some_func==NULL) {
        /* ERROR HANDLING */
    }
    some_func(&a, &b, &c);
    printf("Return code is %f\n",c );
    dlclose(my_lib_handle);
    return 0;
}

