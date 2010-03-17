module Oyster
  class ArrayOption < Option
    
    def consume(list)
      data = []
      data << list.shift while list.first and !Oyster.is_name?(list.first)
      data
    end
    
    def default_value
      super([])
    end
    
    def help_names
      super.map { |name| name + ' ARG1 [ARG2 [...]]' }
    end
    
  end
end

