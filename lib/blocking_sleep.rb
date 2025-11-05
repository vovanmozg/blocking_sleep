require 'blocking_sleep/blocking_sleep'

# BlockingSleep module provides a native blocking sleep
# that doesn't release the GVL (Global VM Lock).
# This is useful for testing thread behavior and GVL interactions.
module BlockingSleep
  VERSION = "0.1.0"
end

