require 'yaml'

module RTM
  class YamlStorage
    attr_reader :filename
    
    def initialize(filename)
      @filename = filename
      create_storage_if_not_exists
      @storage = load_storage
    end
        
    def add(object)
      if o = self.get_first { |obj| obj.id == object.id }
        self.del { |obj| obj.id == object.id }
      else 
        object.id = new_id
      end
      @storage[:objects] << object.dump
      dump
    end
    
    def get(&query)
      find(&query).map do |object|
        self.class.load_object(object)
      end
    end
    
    def get_first(&query)
      ary = self.get(&query)
      unless ary.empty?
        ary.first
      end
    end
    
    def del(&query)
      count = 0
      objects = self.find(&query)
      if objects && !objects.empty?
        objects.each do |object|
          @storage[:objects].delete(object)
          count += 1
        end          
        dump
      end
      count
    end
    
    def self.dump_object(object)
      YAML::dump(object)
    end
    
    def self.load_object(string)
      YAML::load(string)
    end
    
    protected
    def find(&query)
      @storage[:objects].find_all do |object|
        query.call(self.class.load_object(object))
      end
    end
    
    def create_storage_if_not_exists
      if !File.exists?(@filename)
        create_storage
      end
    end
    
    def create_storage
      File.open(filename, "w") { |file| file.write("") }
    end
    
    def load_storage
      YAML::load(File.read(@filename)) || { :last_id => 0, :objects => [] }
    end
    
    def dump
      File.open(@filename, "w") { |file| file.write(YAML::dump(@storage)) }
    end
    
    def new_id
      @storage[:last_id] += 1
    end    
  end
end
