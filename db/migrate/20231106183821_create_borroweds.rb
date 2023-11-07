class CreateBorroweds < ActiveRecord::Migration[7.0]
  def change
    create_table :borroweds do |t|
      t.references :user
      t.references :book
      t.datetime :borrowed_at
      t.datetime :returned_at

      t.timestamps
    end
  end
end
