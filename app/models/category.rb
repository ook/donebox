class Category < ActiveRecord::Base
  has_many :tasks
end
