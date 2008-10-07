class CreateCategories < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :category, :legacy_cat
    create_table :categories do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
    rename_column :tasks, :legacy_cat, :category
  end
end
