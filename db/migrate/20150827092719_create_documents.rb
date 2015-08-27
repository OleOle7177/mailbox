class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer   :message_id
      t.string    :attachment_file_name
      t.string  	:attachment_content_type
      t.integer 	:attachment_file_size
      t.datetime  :attachment_updated_at
    end
  end
end
