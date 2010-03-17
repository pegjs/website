ENV['MINISPEC'] = 'true'

require File.join(File.dirname(__FILE__), *%w[.. lib rainpress])
require 'rubygems'
require 'minitest/spec'

include MiniTest

Unit.autorun

describe 'Rainpress module' do
  it 'removes comments' do
    options = {
      :comments => true,
      :newlines => false,
      :spaces   => false,
      :colors   => false,
      :misc     => false
    }

    # plain comment -> ''
    Rainpress.compress('/* sss */', options).must_equal ''

    # no comment -> no change
    Rainpress.compress('sss', options).must_equal 'sss'

    # comment floating in text
    Rainpress.compress('s/*ss*/ss', options).must_equal 'sss'

    # multiple comments floating in text
    Rainpress.compress('s/*ss*/ss/*ss*/s', options).must_equal 'ssss'

    # empty string
    Rainpress.compress('', options).must_equal ''
  end

  it 'removes newlines' do
    options = {
      :comments => false,
      :newlines => true,
      :spaces   => false,
      :colors   => false,
      :misc     => false
    }

    # plain unix-newline
    Rainpress.compress("\n", options).must_equal ''

    # plain mac newline
    Rainpress.compress("\r", options).must_equal ''

    # plain windows newline
    Rainpress.compress("\r\n", options).must_equal ''

    # no newline
    Rainpress.compress('rn', options).must_equal 'rn'

    # newlines floatin in text
    Rainpress.compress("sss\n||\r\nsss", options).must_equal 'sss||sss'

    # empty string
    Rainpress.compress('', options).must_equal ''
  end

  it 'removes spaces' do
    options = {
      :comments => false,
      :newlines => false,
      :spaces   => true,
      :colors   => false,
      :misc     => false
    }

    # (a) Turn mutiple Spaces into a single, but not less
    Rainpress.compress('  ', options).must_equal ' ' # 2 spaces
    Rainpress.compress('   ', options).must_equal ' ' # 3 spaces

    # (b) remove spaces around ;:{},
    Rainpress.compress(' ; ', options).must_equal ';'
    Rainpress.compress(' : ', options).must_equal ':'
    Rainpress.compress(' { ', options).must_equal '{'
    Rainpress.compress(' } ', options).must_equal '}'
    Rainpress.compress(',', options).must_equal ','

    # (c) remove tabs
    Rainpress.compress("\t", options).must_equal ''
  end

  it 'shortens colors' do
    options = {
      :comments => false,
      :newlines => false,
      :spaces   => false,
      :colors   => true,
      :misc     => false
    }
    # rgb(50,101,152) to #326598
    Rainpress.compress('color:rgb(12,101,152)', options).must_equal 'color:#0c6598'

    # #AABBCC to #ABC
    Rainpress.compress('color:#AAbBCC', options).must_equal 'color:#AbC'

    # Keep chroma(color="#FFFFFF"); ... due to IE
    Rainpress.compress('chroma(color="#FFFFFF");', options).must_equal 'chroma(color="#FFFFFF");'

    # shorten several names to numbers
    Rainpress.compress('color:white;', options).must_equal 'color:#fff;'
    Rainpress.compress('color: white}', options).must_equal 'color:#fff}'

    # shotern several numbers to names
    Rainpress.compress('color:#ff0000;', options).must_equal 'color:red;'
    Rainpress.compress('color:#F00;', options).must_equal 'color:red;'
  end

  it 'does misc' do
    options = {
      :comments => false,
      :newlines => false,
      :spaces   => false,
      :colors   => false,
      :misc     => true
    }
    # Replace 0(pt,px,em,%) with 0
    %w[px em pt % in cm mm pc ex].each { |x| Rainpress.compress(" 0#{x}", options).must_equal ' 0' }
    Rainpress.compress(':0mm', options).must_equal ':0'
    Rainpress.compress('  0ex', options).must_equal '  0'
    Rainpress.compress(' 10ex', options).must_equal ' 10ex'

    # Replace 0 0 0 0; with 0.
    Rainpress.compress(':0 0;', options).must_equal ':0;'
    Rainpress.compress(':0 0 0;', options).must_equal ':0;'
    Rainpress.compress(':0 0 0 0;', options).must_equal ':0;'
    Rainpress.compress(':0 0 0 0}', options).must_equal ':0}'

    # Keep 'background-position:0 0;' !!
    Rainpress.compress('background-position:0 0;', options).must_equal 'background-position:0 0;'

    # Replace 0.6 to .6, but only when preceded by : or a white-space
    Rainpress.compress(' 0.6', options).must_equal ' .6'
    Rainpress.compress(':0.06', options).must_equal ':.06'
    Rainpress.compress('10.6', options).must_equal '10.6'

    # Replace ;;;; with ;
    Rainpress.compress('ss;;;ss', options).must_equal 'ss;ss'

    # Replace ;} with }
    Rainpress.compress('ss;sss;}ss', options).must_equal 'ss;sss}ss'

    # Replace font-weight:normal; with 400, bold with 700
    Rainpress.compress('font-weight: normal;', options).must_equal 'font-weight:400;'
    Rainpress.compress('font: normal;', options).must_equal 'font: 400;'
    Rainpress.compress('font: bold 1px;', options).must_equal 'font: 700 1px;'
  end
end
