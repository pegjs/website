= Oyster

* http://github.com/jcoglan/oyster

Oyster is a command-line input parser that doesn't hate you. It provides a simple
API that you use to write a spec for the user interface to your program, and it
handles mapping the input to a hash for you. It supports both long and short option
names, subcommands, and various types of input data.


=== Installation

  sudo gem install oyster


=== Features

* Parses command line options into a hash for easy access
* Supports long (<tt>--example</tt>) and short (<tt>-e</tt>) names, including compound (<tt>-zxvf</tt>) short options
* Supports subcommand recognition
* Can parse options as booleans, strings, arrays, files, globs
* Automatically handles single-letter shortcuts for option names
* Allows shortcuts to be specified for common groupings of flags
* Is easily extensible to support custom input types
* Automatically outputs man-page-style help for your program


=== Usage

You begin your command-line script by writing a spec for its options, layed out
like a Unix manual page. This spec will be used to parse input and to generate
help text using the <tt>--help</tt> flag. This example demonstrates a wide range of
the spec API. You can use as much or as little of it as you like, none of the fields
are required.

  require 'rubygems'
  require 'oyster'
  
  spec = Oyster.spec do
    name  'myprog -- something to move files around'
    
    synopsis <<-EOS
      myprog [options] --sources SCR --dest DEST
      myprog [options] --sources SRC --exec SCRIPT
    EOS
    
    description <<-EOS
      myprog is a command-line utility for moving files around or executing
      scripts against them. It can be invoked from any directory.
    EOS
    
    flag    :verbose,   :default => false,
            :desc => 'Print verbose output'
    
    flag    :recurse,   :default => true,
            :desc => 'Enter directories recursively'
    
    shortcut :all, '--verbose --recurse'
    
    string  :type,      :default => 'f',
            :desc => 'Which type of files to move'
    
    integer :status,    :default => 200,
            :desc => 'Tell the program the status code to return'
    
    float   :quality,   :default => 0.5,
            :desc => 'Level of compression loss incurred when copying'
    
    glob    :files,     :desc => <<-EOS
    Pattern for selecting which files to move. For example, to select all the
    JavaScript files, you might use:
    
      --files ./*.js    (this directory)
      --files **/*.js   (search recursively)
    EOS
    
    array   :sources,   :desc => 'List of files to move'
    
    string  :dest,      :desc => 'Location of directory to move to'
    
    file    :exec,      :desc => 'File to read script from'
    
    notes <<-EOS
      This program may make destructive changes to your files. Make
      sure you have a full backup before running any dangerous scripts.
    EOS
    
    author    'James Coglan <jcoglan@nospam.com>'
    
    copyright <<-EOS
      (c) 2008 James Coglan. This program is free software, distributed under
      the MIT license. You are free to use it for whatever purpose you see fit.
    EOS
  end

Having defined your spec, you can use it to parse user input. Input is specified
as an array of string tokens, and defaults to +ARGV+. If the program is invoked using
<tt>--help</tt>, Oyster will throw a <tt>Oyster::HelpRendered</tt> exception that you can
use to halt your program if necessary. An example taking input from the command
line:

  begin; opts = spec.parse
  rescue Oyster::HelpRendered; exit
  end
  
<tt>spec.parse</tt> will return a <tt>Hash</tt> containing the values of the options
as specified by the user. For example:

  Input:    --verbose
  Output:   opts[:verbose] == true
  
  Input:    --no-recurse
  Oupput:   opts[:recurse] == false
  
  Input:    --all
  Output    options[:verbose] == true
            options[:recurse] == true
  
  Input:    --dest /path/to/mydir
  Output:   opts[:dest] == '/path/to/mydir'
  
  Input:    -q 0.7
  Output:   opts[:quality] == 0.7
  
  Input:    --sources foo bar baz -d somewhere
  Output:   opts[:sources] == ['foo', 'bar', 'baz']
            opts[:dest] == 'somewhere'

Options specified as +file+ options will take the input and read the contents of
the specified file. Use this option if you want to take input from files without
knowing the name of the file itself:

  Input:    --exec myscript.sh
  Output:   opts[:exec] == '(contents of myscript.sh)'

If you have a +glob+ option, it will expand its input using <tt>Dir.glob</tt>.
You must quote your input for this to work, otherwise the shell will expand the
glob before handing it to the Ruby interpreter.

  Input:    -f **/*.rb
  Output:   ARGV == ['-f', 'foo.rb', 'bar.rb']
            -- Oyster will call Dir.glob('foo.rb')
               opts[:files] == ['foo.rb']
  
  Input:    -f '**/*.rb'
  Output:   ARGV == ['-f', '**/*.rb']
            -- Oyster will call Dir.glob('**/*.rb')
               opts[:files] == ['foo.rb', 'bar.rb', 'dir/baz.rb', ...]


=== Unclaimed input

Any input tokens not absorbed by one of the option flags will be written to an
array in <tt>opts[:unclaimed]</tt>:

  Input:    -s foo.rb bar.rb -d /path/to/dir some_arg
  Output:   opts[:sources] == ['foo.rb', 'bar.rb']
            opts[:dest] == '/path/to/dir'
            opts[:unclaimed] == ['some_arg']


=== Subcommands

You can easily create subcommands by nesting specs inside the main one:

  # Main program spec
  spec = Oyster.spec do
    # Front matter
    name    'someprog'
    
    # Options
    flag    :verbose,   :default => true
    
    # Subcommand 'add'
    subcommand :add do
      name    'someprog-add'
      flag    :force,   :default => false
    end
  end

Subcommand options are stored as a hash inside the main options hash:
  
  Input:    --no-verbose
  Output:   opts == {:verbose => false}
  
  Input:    -v add -f
  Output:   opts == {:verbose => true, :add => {:force => true}}
  
  Input:    add --help
  Output:   prints help for 'add' command only

Beware that you cannot give a subcommand the same name as an option flag,
otherwise you'll get a name collision in the output.


=== License

(The MIT License)

Copyright (c) 2008 James Coglan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
