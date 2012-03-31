require 'erb'
require 'time'

module RTM
  class UI
    WIDTHS = {
      :id     => 5,
      :header => 30,
      :date   => 30,
      :text   => 50,
      :title  => 10
    }

    TITLE_WIDTH = 10

    def show_tasks(tasks)
      if tasks && !tasks.empty?
        if 1 == tasks.size
          task = tasks.first
          message([
            "#{al(:title, '#')} #{task.id}",
            "#{al(:title, 'Header')} #{task.header}",
            "#{al(:title, 'CR')} #{task.created_at.cli_format}",
            "#{al(:title, 'UPD')} #{task.updated_at.cli_format}",
            "#{al(:title, 'Text')} #{task.text}",
          ].join("\n"))
        else
          message([
            al(:id, '#'),
            al(:header, 'Header'),
            al(:text, 'Text'),
            al(:date, 'CR'),
            al(:date, 'UPD')
          ].join(' '))
          tasks.each do |task|
            puts([
              al(:id, task.id),
              al(:header, task.header),
              al(:text, task.text),
              al(:date, task.created_at.cli_format),
              al(:date, task.updated_at.cli_format)
            ].join(' '))
          end
        end
      else
        self.message "No tasks"
      end
    end

    def message(text)
      puts text
    end

  protected

    def al(field, value)
      value.to_s.align(WIDTHS[field])
    end
  end
end

