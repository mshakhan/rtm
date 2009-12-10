$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), 'rtm')

require 'core_ext'
require 'notebook'
require 'yaml_storage'
require 'model'
require 'task'
require 'ui'

module RTM
  class Tracker
    def initialize(options)
      Task::storage = Notebook::path(
        options.delete(:notebook), Task)
      @ui = UI.new
    end
    
    def show(options)
      query = make_query(options)
      tasks = Task.get &query
      @ui.show_tasks(tasks)
    end
    
    def add(options)
      Task.create(options)
      @ui.message "Task has been created"
    end
    
    def del(options)
      query = make_query(options)
      count = Task.del &query
      @ui.message "#{count} tasks has been deleted"
    end
    
    protected
    def make_query(options)
      if interval = options[:interval]
        proc { |obj| obj.created_at > interval.first && obj.created_at < interval.last  }
      elsif oid = options[:id]
        proc { |obj| obj.id == oid.to_i }
      else 
        proc { |obj| true }
      end   
    end
  end
end
