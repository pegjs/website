# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rainpress}
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Uwe L. Korn, Jeff Smick"]
  s.date = %q{2009-01-14}
  s.default_executable = %q{csspress}
  s.description = %q{A CSS compressor}
  s.email = %q{sprsquish@gmail.com}
  s.executables = ["csspress"]
  s.extra_rdoc_files = ["bin/csspress", "CHANGELOG", "lib/autotest/discover.rb", "lib/autotest/spec.rb", "lib/rainpress.rb", "README.rdoc"]
  s.files = ["bin/csspress", "CHANGELOG", "lib/autotest/discover.rb", "lib/autotest/spec.rb", "lib/rainpress.rb", "Manifest", "rainpress.gemspec", "Rakefile", "README.rdoc", "spec/build_safe.rb", "spec/rainpress_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/sprsquish/rainpress/tree/master}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rainpress", "--main", "README.rdoc", "-S", "-T", "hanna", "--main", "README.rdoc", "--exclude", "autotest"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{squishtech}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A CSS compressor}
  s.test_files = ["spec/rainpress_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
