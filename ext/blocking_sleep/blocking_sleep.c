#include <ruby.h>
#include <unistd.h>

/*
 * Call native sleep() function without releasing GVL.
 * This blocks the entire Ruby VM, useful for testing thread behavior.
 */
static VALUE
blocking_sleep_sleep(VALUE self, VALUE seconds)
{
    unsigned int sleep_time;
    
    // Convert Ruby number to C unsigned int
    sleep_time = NUM2UINT(seconds);
    
    // Call native sleep() - this blocks without releasing GVL
    sleep(sleep_time);
    
    return Qnil;
}

void
Init_blocking_sleep(void)
{
    VALUE mBlockingSleep;
    
    // Define BlockingSleep module
    mBlockingSleep = rb_define_module("BlockingSleep");
    
    // Define BlockingSleep.sleep method
    rb_define_module_function(mBlockingSleep, "sleep", blocking_sleep_sleep, 1);
}

