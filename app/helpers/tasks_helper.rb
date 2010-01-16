module TasksHelper
  def group_by_date(tasks)
    tasks.inject({ Date.today => [], 1.days.since.to_date => [] }) do |groups, task|
      (groups[task.due_on.to_date] ||= []) << task
      groups
    end.sort
  end
  
  def tasks_dom_id(element)
    case element
    when Task
      date = element.due_on.to_i || element.kind
    when Date
      date = element.to_time.to_i
    when String
      date = element.downcase
    end
    "tasks_#{date}"
  end
  
  def late(date)
    return false unless date.kind_of? Date
    date && date.to_date < Date.today
  end
  
  def format_task_name(name)
    auto_link(h(name), :all, :target => '_blank') do |text|
      truncate(text, 50).gsub 'http://', ''
    end
  end
  
  def permanent_date?(date)
    [Date.today, 1.days.since.to_date, 'Later', 'ASAP'].include? date
  end
  
  def insert_new_section_for(task)
    page.call 'Tasks.insertNewSection', tasks_dom_id(task),
              render(:partial => 'tasks', :locals => { :tasks => [], :date => task.due_on ? task.due_on.to_date : nil })
  end
  
  def refresh
    page.call 'Tasks.refresh'
  end
  
  def js_autocomplete_array(categories)
    "['" + categories.collect { |c| "[#{c}] " }.join("', '") + "', '" + 
    categories.collect { |c| "@#{c} " }.join("', '") + "']"
  end
end
