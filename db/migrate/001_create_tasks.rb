class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :name,         :string
      t.column :created_at,   :datetime
      t.column :due_at,       :datetime
      t.column :completed_at, :datetime
    end
  end

  def self.down
    drop_table :tasks
  end
end
