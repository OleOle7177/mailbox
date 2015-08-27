class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.string  :subject
      t.text 		:body
      t.string  :from
      t.string  :to

      t.timestamps
    end
  end
end
