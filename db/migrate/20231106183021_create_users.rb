class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :salt
      t.string :crypted_password
      t.integer :type

      t.timestamps
    end
  end
end
