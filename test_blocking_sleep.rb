#!/usr/bin/env ruby
# Test script demonstrating the difference between regular and blocking sleep

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'blocking_sleep'

puts "=== Test 1: Regular Kernel.sleep (releases GVL) ==="
start = Time.now

t1 = Thread.new do
  puts "  Thread 1: starting 2 second sleep (Kernel.sleep)"
  sleep(2)
  puts "  Thread 1: woke up"
end

t2 = Thread.new do
  sleep(0.1)  # Small delay to let first thread start
  puts "  Thread 2: working while Thread 1 sleeps!"
  3.times do |i|
    puts "  Thread 2: iteration #{i + 1}"
    sleep(0.5)
  end
end

t1.join
t2.join

puts "Execution time: #{(Time.now - start).round(2)} sec\n\n"

puts "=== Test 2: BlockingSleep.sleep (does NOT release GVL) ==="
start = Time.now

t3 = Thread.new do
  puts "  Thread 3: starting blocking sleep for 2 seconds"
  BlockingSleep.sleep(2)
  puts "  Thread 3: woke up"
end

t4 = Thread.new do
  sleep(0.1)
  puts "  Thread 4: trying to work, but blocked!"
  3.times do |i|
    puts "  Thread 4: iteration #{i + 1}"
    sleep(0.5)
  end
end

t3.join
t4.join

puts "Execution time: #{(Time.now - start).round(2)} sec"
puts "\nNotice: in the second test, Thread 4 starts working"
puts "only after Thread 3 finishes BlockingSleep.sleep"

