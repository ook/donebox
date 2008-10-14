require 'chronic'

class Task < ActiveRecord::Base
  belongs_to :category
  
  attr_protected :user_id
  
  acts_as_list :scope => :user_id
  
  named_scope :dated, :conditions => 'due_on IS NOT NULL AND completed_at IS NULL',
                      :order => 'due_on, position'
  named_scope :later, :conditions => 'due_on IS NULL AND completed_at IS NULL',
                      :order => 'position'
  named_scope :completed, :conditions => 'completed_at IS NOT NULL',
                          :order => 'completed_at desc'

  validates_presence_of :name
  
  before_create :extract_category_from_name
  before_create :extract_due_date_from_name
  
  def due_later?
    !due_on?
  end
  
  def complete
    self.completed_at = Time.now
  end
  
  def completed?
    self.completed_at?
  end
  alias_method :completed, :completed?
  
  def completed=(v)
    v ? complete : uncomplete
  end
  
  def uncomplete
    self.completed_at = nil
  end
  
  private
    def extract_category_from_name
      extracted_category, extracted_name = /^(?:\[([^\]]+)\]|)\s?(.*)$/.match(self.name)[1,2]
      
      if extracted_category
        self.category = Category.find_or_create_by_name_and_user_id(extracted_category, user_id)
        self.name = extracted_name
      end
    end
    
    def extract_due_date_from_name
      name_parts = self.name.split(' ')
      date = date_part = nil
      
      (0..name_parts.size).each do |i|
        date_part = name_parts[i, name_parts.size-i].join(' ')
        date = Chronic.parse(date_part)
        break if date
      end
      
      if date
        self.due_on = date.to_date
        self.name.gsub! ' ' + date_part, ''
      end
    end
end
