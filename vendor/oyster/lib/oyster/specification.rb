module Oyster
  class Specification
    
    include Enumerable
    
    def initialize
      @options     = []
      @subcommands = []
      @data        = {}
    end
    
    def each(&block)
      @options.sort_by { |o| o.name.to_s }.each(&block)
    end
    
    def method_missing(*args)
      opt = Option.create(*args)
      raise "Option name '#{opt.name}' is already used" if has_option?(opt.name)
      opt.alternate(shorthand_for(opt.name))
      @options << opt
    rescue
      name, value = args[0..1]
      @data[name.to_sym] = value.to_s
    end
    
    def subcommand(name, &block)
      opt = SubcommandOption.new(name, Oyster.spec(&block))
      raise "Subcommand name '#{opt.name}' is already used" if has_command?(name)
      @subcommands << opt
    end
    
    def has_option?(name)
      !self[name].nil?
    end
    
    def has_command?(name)
      !command(name).nil?
    end
    
    def command(name)
      @subcommands.each do |command|
        return command if command.has_name?(name)
      end
      nil
    end
    
    def parse(input = ARGV)
      output = {:unclaimed => []}
      return output if input.nil?
      
      input = input.dup
      
      while token = input.shift
        if token == STOP_FLAG
          output[:unclaimed] = output[:unclaimed] + input
          break
        end
        
        option = command(token)
        
        long, short = token.scan(LONG_NAME), token.scan(SHORT_NAME)
        long, short = [long, short].map { |s| s.flatten.first }
        
        input = short.scan(/./).map { |s| "-#{s}" } + input and next if short and short.size > 1
        
        negative = !!(long && long =~ NEGATOR)
        long.sub!(NEGATOR, '') if negative
        
        option ||= self[long] || self[short]
        output[:unclaimed] << token and next unless option
        
        output[option.name] = option.is_a?(FlagOption) ? !negative : option.consume(input)
      end
      
      @options.each do |option|
        next unless output[option.name].nil?
        output[option.name] ||= option.default_value
      end
      
      help and raise HelpRendered if output[:help]
      output
    end
    
  private
    
    def [](name)
      @options.each do |opt|
        return opt if opt.has_name?(name)
      end
      nil
    end
    
    def shorthand_for(name)
      initial = name.to_s.scan(/^./).first.downcase
      initial.upcase! if has_option?(initial)
      return nil if has_option?(initial)
      initial
    end
    
    def help(stream = $stdout)
      render(stream, @data[:name],         1, 'NAME')
      render(stream, @data[:synopsis],     1, 'SYNOPSIS', false, true)
      render(stream, @data[:description],  1, 'DESCRIPTION')
      
      i = 0
      stream.puts "\n#{ bold }OPTIONS#{ normal }"
      each do |option|
        render(stream, option.help_names.join(', '), 1, nil, false, true)
        render(stream, option.description, 2)
        i += 1
        stream.puts "\n" if i < @options.size
      end
      
      render(stream, @data[:notes],        1, 'NOTES')
      render(stream, @data[:author],       1, 'AUTHOR')
      render(stream, @data[:copyright],    1, 'COPYRIGHT')
      stream.puts "\n"
      self
    end
    
    # Plagiarised from Trollop, Copyright (c) 2008 William Morgan
    def display_width
      @width ||= begin
                   require 'curses'
                   Curses.init_screen
                   x = Curses.cols
                   Curses.close_screen
                   x
                 rescue
                   HELP_WIDTH
                 end
      @width - HELP_INDENT
    end
    
    def render(stream, text, level = 1, title = nil, join = true, man = false)
      return unless text
      stream.puts "\n" + format("#{ normal }#{ bold }#{ title }#{ normal }", level - 1) if title
      text = man_format(text) if man
      stream.puts format(text, level, join)
    end
    
    def format(text, level = 1, join = true)
      lines   = text.split(/\n/)
      outdent = lines.inject(1000) { |n,s| [s.scan(/^\s*/).first.size, n].min }
      indent  = level * HELP_INDENT
      width   = display_width - indent
      
      lines.map { |line|
        line.sub(/\s*$/, '').sub(%r{^\s{#{outdent}}}, '')
      }.inject(['']) { |groups, line|
        groups << '' if line.empty? && !groups.last.empty?
        buffer = groups.last
        buffer << (line =~ /^\s+/ || !join ? "\n" : " ") unless buffer.empty?
        buffer << line
        groups
      }.map { |buffer|
        lines = (buffer =~ /\n/) ?
            buffer.split(/\n/) :
            buffer.scan(%r{((?:.(?:\e\[\dm)*){1,#{width}}\S*)\s*}).flatten
        lines.map { |l| (' ' * indent) + l }.join("\n")
      }.join("\n\n")
    end
    
    def man_format(text)
      text.split(/\n/).map { |line|
        " #{line}".scan(/(.+?)([a-z0-9\-\_]*)/i).flatten.map { |token|
          formatter = case true
            when Oyster.is_name?(token)                      then  bold
            when token =~ /[A-Z]/ && token.upcase == token   then  underline
            when token =~ /[a-z]/ && token.downcase == token then  bold
          end
          formatter ? "#{ formatter }#{ token }#{ normal }" : token
        }.join('')
      }.join("\n")
    end
    
    def bold
      WINDOWS ? "" : "\e[1m"
    end
    
    def underline
      WINDOWS ? "" : "\e[4m"
    end
    
    def normal
      WINDOWS ? "" : "\e[0m"
    end
    
  end
end

