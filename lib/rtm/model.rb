module RTM
  class Model
    attr_accessor :created_at, :updated_at

    def initialize(attrs)
      attrs.each_pair do |name, value|
        assigner = "#{name}="
        if self.respond_to?(assigner)
          self.send(assigner, value)
        else
          raise ArgumentError, "invalid attribute #{name}"
        end
      end
      self.created_at = Time.now
    end

    def self.has_one(name, klass)
      attr_accessor "#{name}_id"
      define_method name do
        klass.storage.get_first { |obj| obj.id = self.send "#{name}_id" }
      end

      define_method "#{name}=" do |value|
        self.send "#{name}_id=", value.id
      end
    end

    def self.property(name, options = {})

    end

    def save
      self.updated_at = Time.now
      @@storage.add(self)
    end

    def self.storage
      @@storage
    end

    def self.storage=(v)
      @@storage = v
    end

    def self.create(attrs)
      new(attrs).save
    end

    def self.get(&query)
      @@storage.get(&query)
    end

    def self.get_first(&query)
      @@storage.get_first(&query)
    end

    def self.del(&query)
      @@storage.del(&query)
    end

    def dump
      @@storage.class.dump_object(self)
    end

    def self.load(string)
      @@storage.class.load_object(string)
    end
  end
end

