require 'chronic'

class Task < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  
  attr_protected :user_id
  
  acts_as_list :scope => :user_id
  
  named_scope :asap, :conditions => 'due_on IS NULL AND kind = \'asap\' and completed_at IS NULL', :order => 'position'
  named_scope :dated, :conditions => 'due_on IS NOT NULL AND completed_at IS NULL',
                      :order => 'due_on, position'
  named_scope :later, :conditions => 'due_on IS NULL AND completed_at IS NULL and kind = \'later\'',
                      :order => 'position'
  named_scope :completed, :conditions => 'completed_at IS NOT NULL',
                          :order => 'completed_at desc'

  validates_presence_of :name
  
  before_create :extract_category_from_name
  before_create :extract_due_date_from_name

  before_save :set_kind
  
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
      md = /^(?:\[([^\]]+)\]|@(\S+)|)\s?(.*)$/.match(self.name).to_a
      extracted_category, extracted_name = md[1] , md[3]
      extracted_category ||= md[2].gsub(/_/, ' ') unless md[2].nil?
      
      if extracted_category
        self.category = Category.find_by_name_and_user_id(extracted_category, user.id)
        self.category ||= Category.create(:name => extracted_category, :user_id => user.id)
        self.name = extracted_name
      end
    end
    
    def extract_due_date_from_name
      # first, try to extract due date from the last comma
      name_parts = self.name.split(',')
      date = Chronic.parse(name_parts[-1])
      if date
        self.due_on = date.to_date
        self.name = name_parts[0, name_parts.size-1].join(',')
        return
      end

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

    def dump(hash)
      ret = ''
      hash.each_pair do |k,v|
        old_val = v.first 
        new_val = v.last 
        old_val ||= 'nil'
        new_val ||= 'nil'
        ret += "{ #{k} => [#{old_val}, #{new_val}] }\n"
      end
      ret
    end

    def set_kind
      will_kind = changes['kind'] ? changes['kind'].last : kind
      will_due_on = changes['due_on'] ? changes['due_on'].last : due_on

      if will_due_on.nil? && will_kind.nil?
        self.kind = 'asap'
      end
      if !will_due_on.nil?
        self.kind = nil
      end
    end
end
