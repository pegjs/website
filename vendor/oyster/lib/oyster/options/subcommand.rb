module Oyster
  class SubcommandOption < Option
    
    def initialize(name, spec)
      super(name)
      @spec = spec
    end
    
    def consume(list)
      output = @spec.parse(list)
      list.clear
      output
    end
    
    def parse(*args)
      @spec.parse(*args)
    end
    
  end
end

