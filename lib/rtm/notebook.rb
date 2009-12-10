require 'fileutils'

module RTM
  module Notebook extend self
    def root
      File.join(File.dirname(__FILE__), '..', '..', 'bin')
    end
    
    def path(key, klass, storage_klass = YamlStorage)
      notebook_path = File.join(root, key)
      storage_path = File.join(notebook_path, "#{klass.name.downcase}.yml")
      
      if !File.exists?(notebook_path)
        FileUtils::mkdir_p(notebook_path)
      end
      klass.storage = storage_klass.new(storage_path)
    end
  end
end
