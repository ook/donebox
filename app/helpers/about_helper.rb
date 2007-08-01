module AboutHelper
  def curl(method, url, args=nil)
    content_tag :code,
      h("curl -H 'Accept: application/xml' -H 'Content-Type: text/xml' -u login:password -X #{method.to_s.upcase} #{url} #{args}"),
      :class => 'terminal'
  end
  
  def you(text)
    say :you, text
  end
  
  def me(text)
    say :me, text
  end
  
  def say(who, text)
    "<p><strong>#{who}</strong> #{h text}</p>"
  end
  
  def link_to_home
    link_to '&laquo; Back to your Donebox', home_path
  end
end
