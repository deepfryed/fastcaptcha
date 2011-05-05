# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fastcaptcha}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = %q{2011-05-05}
  s.description = %q{A simple and fast image captcha generator that uses opencv and memcached.}
  s.email = %q{deepfryed@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    "README",
     "VERSION",
     "ext/fastcaptcha.c",
     "lib/fastcaptcha.rb",
     "lib/moneta/redis2.rb",
     "lib/sinatra/captcha.rb"
  ]
  s.homepage = %q{http://github.com/deepfryed/fastcaptcha}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A simple and fast image captcha generator}
  s.test_files = [
    "test/fastcaptcha_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<moneta>, [">= 0.6.0"])
      s.add_development_dependency(%q<ansi>, [">= 1.2.1"])
      s.add_development_dependency(%q<redis>, [">= 2.1.1"])
    else
      s.add_dependency(%q<moneta>, [">= 0.6.0"])
      s.add_dependency(%q<ansi>, [">= 1.2.1"])
      s.add_dependency(%q<redis>, [">= 2.1.1"])
    end
  else
    s.add_dependency(%q<moneta>, [">= 0.6.0"])
    s.add_dependency(%q<ansi>, [">= 1.2.1"])
    s.add_dependency(%q<redis>, [">= 2.1.1"])
  end
end

