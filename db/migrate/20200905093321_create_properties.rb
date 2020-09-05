class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.decimal :price
      t.string :type
      t.string :category
      t.string :status
      t.string :location
      t.integer :size

      t.timestamps
    end
  end
end
