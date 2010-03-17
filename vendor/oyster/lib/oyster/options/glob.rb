module Oyster
  class GlobOption < Option
    
    def consume(list)
      Dir.glob(list.shift)
    end
    
    def default_value
      super([])
    end
    
    def help_names
      super.map { |name| name + ' ARG' }
    end
    
  end
end

