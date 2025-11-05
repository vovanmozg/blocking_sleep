Gem::Specification.new do |s|
  s.name        = 'blocking_sleep'
  s.version     = '0.1.0'
  s.summary     = 'Native blocking sleep for Ruby thread experiments'
  s.description = 'A simple C extension that provides blocking sleep without releasing GVL'
  s.authors     = ['Vladimir Polukhin']
  s.email       = 'vovanmozg@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + Dir['ext/**/*.{c,rb}']
  s.extensions  = ['ext/blocking_sleep/extconf.rb']
  s.homepage    = 'https://example.com'
  s.license     = 'MIT'
  
  s.required_ruby_version = '>= 2.5.0'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
end
