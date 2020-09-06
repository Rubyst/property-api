class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :message
      t.integer :property

      t.timestamps
    end
  end
end
