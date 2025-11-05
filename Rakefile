require 'rake/extensiontask'

Rake::ExtensionTask.new('blocking_sleep') do |ext|
  ext.lib_dir = 'lib/blocking_sleep'
end

task default: :compile

desc 'Clean compiled files'
task :clean do
  sh 'rm -rf lib/blocking_sleep/*.so'
  sh 'rm -rf ext/blocking_sleep/*.o ext/blocking_sleep/Makefile'
  sh 'rm -f blocking_sleep.so'
end

