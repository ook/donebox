class RemoveCategoryFromTasks < ActiveRecord::Migration
  def self.up
    Task.find(:all).each { |t|
      if t.legacy_cat
        cat = Category.find(:name => t.legacy_cat) || Category.create(:name => t.legacy_cat)
        t.category = cat
        t.save
      end
    }
    remove_column :tasks, :legacy_cat
  end

  def self.down
    add_column :tasks, :legacy_cat, :string
    Task.find(:all).each { |t|
      if t.category
        t.legacy_cat = t.category.name
        t.category = nil
        t.save
      end
    }
  end
end
