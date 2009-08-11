class AddKindToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :kind, :string, :null => :true
    add_index :tasks, :kind
  end

  def self.down
    remove_index :tasks, :kind
    remove_column :tasks, :kind
  end
end
