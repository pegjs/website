module Oyster
  class ShortcutOption < Option
    
    def initialize(name, expansion, options = {})
      super(name, options)
      @expansion = expansion.split(/\s+/).reverse
    end
    
    def consume(list)
      @expansion.each { |e| list.unshift(e) }
      nil
    end
    
    def description
      "Same as '#{@expansion.reverse.join(' ')}'"
    end
    
  end
end

