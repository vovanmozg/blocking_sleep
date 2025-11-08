#include <ruby.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>
#include <math.h>

/*
 * Call native sleep() function without releasing GVL.
 * This blocks the entire Ruby VM, useful for testing thread behavior.
 */
static VALUE
blocking_sleep_sleep(VALUE self, VALUE seconds)
{
    double sleep_time;
    double integral;
    double fractional;
    struct timespec req;
    struct timespec rem;

    // Convert Ruby number to C double
    sleep_time = NUM2DBL(seconds);

    if (sleep_time < 0.0) {
        rb_raise(rb_eArgError, "sleep duration must be non-negative");
    }

    fractional = modf(sleep_time, &integral);

    req.tv_sec = (time_t)integral;
    req.tv_nsec = (long)(fractional * 1e9 + 0.5);

    if (req.tv_nsec >= 1000000000L) {
        req.tv_sec += 1;
        req.tv_nsec -= 1000000000L;
    }

    // Call native nanosleep() - this blocks without releasing GVL
    while (nanosleep(&req, &rem) == -1) {
        if (errno == EINTR) {
            req = rem;
            continue;
        }
        rb_sys_fail("nanosleep");
    }

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
