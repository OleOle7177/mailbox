class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer   :message_id
      t.string    :attachment_file_name
    end
  end
end
