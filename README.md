# BlockingSleep

A simple gem with native C extension for Ruby thread experiments.

## Description

`BlockingSleep` provides a `sleep` method that blocks execution at the native code level **without releasing the GVL** (Global VM Lock). This differs from the standard `Kernel.sleep`, which releases the GVL and allows other threads to execute.

## Installation

```bash
gem build blocking_sleep.gemspec
gem install blocking_sleep-0.2.0.gem
```

Or for development:

```bash
cd ext/blocking_sleep
ruby extconf.rb
make
cd ../..
```

## Usage

```ruby
require 'blocking_sleep'

# Blocking sleep for 2 seconds
BlockingSleep.sleep(2)
```

## Thread Experiment Example

```ruby
require 'blocking_sleep'

# Regular sleep - other threads can execute
Thread.new do
  puts "Thread 1: start"
  sleep(2)  # Releases GVL
  puts "Thread 1: end"
end

Thread.new do
  puts "Thread 2: running during sleep"
end

sleep(3)

# Blocking sleep - blocks entire VM
Thread.new do
  puts "Thread 3: start"
  BlockingSleep.sleep(2)  # Does NOT release GVL
  puts "Thread 3: end"
end

Thread.new do
  puts "Thread 4: will be blocked!"
end

sleep(3)
```

## Warning

This gem is created exclusively for educational purposes and GVL experiments.
DO NOT use in production code!
