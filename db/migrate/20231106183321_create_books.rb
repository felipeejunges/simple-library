class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.string :synopsis
      t.integer :copies
      t.string :language
      t.integer :pages
      t.string :series
      t.integer :volume

      t.timestamps
    end
  end
end
