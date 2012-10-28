class RemoveSaltFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :salt
  end

  def self.down
    add_column :users, :salt, :string
  end
end
