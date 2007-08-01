class AddCategoryToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :category, :string
  end

  def self.down
    remove_column :tasks, :category
  end
end
