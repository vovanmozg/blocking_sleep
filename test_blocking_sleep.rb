#!/usr/bin/env ruby
# Simple runtime checks for BlockingSleep behaviour.

require 'minitest/autorun'
require 'thread'

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'blocking_sleep'

class BlockingSleepTest < Minitest::Test
  MONOTONIC_CLOCK = Process::CLOCK_MONOTONIC

  def test_fractional_sleep_duration
    duration = 0.12
    started_at = Process.clock_gettime(MONOTONIC_CLOCK)

    BlockingSleep.sleep(duration)

    elapsed = Process.clock_gettime(MONOTONIC_CLOCK) - started_at
    assert_in_delta duration, elapsed, 0.03, "sleep elapsed #{elapsed}, expected about #{duration}"
  end

  def test_blocks_ruby_threads
    flag = :unset
    observed = Queue.new

    worker = Thread.new do
      BlockingSleep.sleep(0.3)
      flag = :finished
    end

    observer = Thread.new do
      # Try to observe the flag after a brief delay.
      sleep 0.05
      observed << flag
    end

    worker.join
    observer.join

    # Если GVL удерживается, наблюдатель увидит уже обновлённое значение.
    assert_equal :finished, flag
    assert_equal :finished, observed.pop
  end
end
