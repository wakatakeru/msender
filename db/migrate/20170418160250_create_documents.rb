class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :title, :null => false
      t.text :content
      t.integer :user_id
      t.boolean :is_send
      t.timestamps
    end
  end
end
