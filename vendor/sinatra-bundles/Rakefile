require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra-bundles"
    gem.summary = %Q{Easy asset bundling for sinatra}
    gem.description = %Q{Bundle CSS and Javascript assets to a single file, compress, and cache them for snappier web experiences.}
    gem.email = 'darkhelmet@darkhelmetlive.com'
    gem.homepage = 'http://github.com/darkhelmet/sinatra-bundles'
    gem.authors = ['Daniel Huckstep']
    gem.add_dependency 'rainpress', '>= 0'
    gem.add_dependency 'packr', '>= 0'
    gem.add_dependency 'rack', '>= 1.0'
    gem.add_dependency 'sinatra', '>= 1.0.a'
    gem.add_development_dependency 'rspec', '>= 1.2.9'
    gem.add_development_dependency 'rack-test', '>= 0.5.3'
    gem.add_development_dependency 'yard', '>= 0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files = ['lib/**/*.rb']
  end
rescue LoadError
  task :yardoc do
    abort 'YARD is not available. In order to run yardoc, you must: sudo gem install yard'
  end
end