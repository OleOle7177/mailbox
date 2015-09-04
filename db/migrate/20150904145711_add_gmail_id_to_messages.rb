class AddGmailIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :gmail_id, :integer
  end
end
