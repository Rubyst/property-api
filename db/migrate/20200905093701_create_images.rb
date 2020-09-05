class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :public_id
      t.string :public_url
      t.integer :property

      t.timestamps
    end
  end
end
