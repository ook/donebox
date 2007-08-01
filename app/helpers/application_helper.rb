# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Returns a 'human' formatted date string from a Date or Time object: "Yesterday", "Today" or  
  # "Tomorrow" where applicable (a la Mac OS X's Mail.app, amongst others), or otherwise the output of strftime  
  # for the given formatting string (the default, "%B %e, %Y", gives the American-style "Month [D]D, YYYY") 
  # Taken from: http://dev.rubyonrails.org/ticket/5792
  def human_date(date, format = "%B %e, %Y") 
    case Date.today - date.to_date 
      when  1 then "Yesterday" 
      when  0 then "Today" 
      when -1 then "Tomorrow" 
      else date.strftime(format) 
    end 
  end
end
