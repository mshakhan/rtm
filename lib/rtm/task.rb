module RTM
  class Task < Model
    attr_accessor :id, :header, :text    
    has_one :parent, Task
  end
end
