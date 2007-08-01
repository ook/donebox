class RenameTasksDueAtToDueOn < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :due_at, :due_on
  end

  def self.down
    rename_column :tasks, :due_on, :due_at
  end
end
