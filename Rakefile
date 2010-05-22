require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/extensiontask'

CLEAN << FileList[ 'ext/Makefile', 'ext/fastcaptcha.so' ]

begin
  require 'jeweler'
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Jeweler::Tasks.new do |gem|
  gem.name        = 'fastcaptcha'
  gem.summary     = 'A simple and fast image captcha generator'
  gem.description = 'A simple and fast image captcha generator that uses opencv and memcached.'
  gem.email       = 'deepfryed@gmail.com'
  gem.homepage    = 'http://github.com/deepfryed/fastcaptcha'
  gem.authors     = ['Bharanee Rathna']
 
  gem.add_dependency 'memcached', '>= 0.17.7'
  gem.add_development_dependency 'ansi', '>= 1.2.1'

  gem.files = FileList[
    'lib/**/*.rb',
    'ext/*.{h,c}',
    'VERSION',
    'README'
  ]
  gem.extensions  = FileList[ 'ext/**/extconf.rb' ]
  gem.test_files  = FileList[ 'test/**/*_test.rb' ]
end

Jeweler::GemcutterTasks.new

Rake::ExtensionTask.new do |ext|
  ext.name    = 'fastcaptcha'
  ext.ext_dir = 'ext'
  ext.lib_dir = 'ext'
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fastcaptcha #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test    => [ :compile, :check_dependencies ]
task :default => :test
