module TasksExtensions
  def dated
    find :all, :conditions => 'due_on IS NOT NULL AND completed_at IS NULL',
               :order => 'due_on, position'
  end
  
  def later
    find :all, :conditions => 'due_on IS NULL AND completed_at IS NULL',
               :order => 'position'
  end
  
  def completed
    find :all, :conditions => 'completed_at IS NOT NULL',
               :order => 'completed_at desc'
  end
end