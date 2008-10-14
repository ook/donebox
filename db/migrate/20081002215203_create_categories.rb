class CreateCategories < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :category, :legacy_cat
    create_table :categories do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    add_column :tasks, :category_id, :integer
  end

  def self.down
    remove_column :tasks, :category_id
    remove_column :tasks, :category
    drop_table :categories
    rename_column :tasks, :legacy_cat, :category
  end
end
