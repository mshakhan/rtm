require 'fileutils'

module RTM
  module Notebook extend self
    def root
      File.join(File.dirname(__FILE__), '..', '..', 'db')
    end

    def path(name, klass, storage_klass = YamlStorage)
      notebook_path = File.join(root, name)
      storage_path = File.join(notebook_path, "#{klass.name.downcase}.#{storage_klass.file_ext}")

      if !File.exists?(notebook_path)
        FileUtils::mkdir_p(notebook_path)
      end
      klass.storage = storage_klass.new(storage_path)
    end
  end
end

