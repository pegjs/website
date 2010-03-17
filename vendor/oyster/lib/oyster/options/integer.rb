module Oyster
  class IntegerOption < StringOption
    
    def consume(list)
      super.to_i
    end
    
    def default_value
      super(0)
    end
    
  end
end

