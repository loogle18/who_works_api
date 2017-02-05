class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :password_digest
      t.integer :status_code
      t.string :status
      t.string :avatar
      t.string :full_name

      t.timestamps
    end
  end
end
