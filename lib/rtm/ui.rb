require 'erb'
require 'time'

module RTM
  class UI        
    def template
      @template ||= File.read(File.join(File.dirname(__FILE__), 'task.erb'))
    end
    
    def width
      50
    end
    
    def separator
      '-' * width
    end
    
    def show_task(task)
      @task = task
      puts ERB.new(template).result(binding)
    end
    
    def show_tasks(tasks)
      if tasks && !tasks.empty?
        puts
        tasks.each { |task| show_task(task); puts }
      else
        self.message "No tasks"
      end
    end
    
    def message(text)
      puts text
    end
  end
end
