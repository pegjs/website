module Oyster
  VERSION = '0.9.3'
  
  LONG_NAME   = /^--([a-z\[][a-z0-9\]\-]+)$/i
  SHORT_NAME  = /^-([a-z0-9]+)$/i
  
  HELP_INDENT = 7
  HELP_WIDTH  = 80
  
  STOP_FLAG   = '--'
  NEGATOR     = /^no-/
  
  WINDOWS = RUBY_PLATFORM.split('-').any? { |part| part =~ /mswin\d*/i }
  
  class HelpRendered < StandardError; end
  
  def self.spec(*args, &block)
    spec = Specification.new
    spec.instance_eval(&block)
    spec.flag(:help, :default => false, :desc => 'Displays this help message') unless spec.has_option?(:help)
    spec
  end
  
  def self.is_name?(string)
    !string.nil? and !!(string =~ LONG_NAME || string =~ SHORT_NAME || string == STOP_FLAG)
  end
end

[ 'specification',
  'option',
  'options/flag',
  'options/string',
  'options/integer',
  'options/float',
  'options/file',
  'options/array',
  'options/glob',
  'options/shortcut',
  'options/subcommand'
].each do |file|
  require File.dirname(__FILE__) + '/oyster/' + file
end

