class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :title, :null => false
      t.text :content
      t.integer :tag_id
      t.timestamps
    end
  end
end
