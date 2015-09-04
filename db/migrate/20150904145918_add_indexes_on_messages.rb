class AddIndexesOnMessages < ActiveRecord::Migration
  def change
  	add_index(:messages, [:user_id, :gmail_id], unique: true) 
  end
end
