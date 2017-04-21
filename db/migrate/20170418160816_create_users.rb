class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login_id, :null => false
      t.string :screen_name, :null => false
      t.string :password_digest
      t.boolean :is_admin

      t.timestamps
    end
  end
end
