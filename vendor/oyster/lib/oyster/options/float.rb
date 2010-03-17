module Oyster
  class FloatOption < StringOption
    
    def consume(list)
      super.to_f
    end
    
    def default_value
      super(0)
    end
    
  end
end

