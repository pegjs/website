require 'echoe'
require 'hanna/rdoctask'

Echoe.new('rainpress') do |p|
  p.author = ['Uwe L. Korn', 'Jeff Smick']
  p.email = 'sprsquish@gmail.com'
  p.url = 'http://github.com/sprsquish/rainpress/tree/master'

  p.project = 'squishtech'
  p.summary = 'A CSS compressor'

  p.rdoc_options += %w[-S -T hanna --main README.rdoc --exclude autotest]

  p.test_pattern = 'spec/*_spec.rb'
  p.rcov_options = ['--exclude \/Library\/Ruby\/Gems,spec\/', '--xrefs']

  p.retain_gemspec = true
end
