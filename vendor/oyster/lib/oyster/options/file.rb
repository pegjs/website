module Oyster
  class FileOption < Option
    
    def consume(list)
      File.read(list.shift)
    end
    
    def default_value
      super(nil)
    end
    
    def help_names
      super.map { |name| name + ' ARG' }
    end
    
  end
end

