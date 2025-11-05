require 'mkmf'

# Build the extension into blocking_sleep/blocking_sleep.so so the
# Ruby wrapper can load it via `require 'blocking_sleep/blocking_sleep'`.
create_makefile('blocking_sleep/blocking_sleep')
