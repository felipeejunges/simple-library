class CreateBookDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :book_details do |t|
      t.integer :name
      t.string :description
      t.references :book

      t.timestamps
    end
  end
end
