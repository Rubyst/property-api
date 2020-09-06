class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.string :message
      t.integer :property

      t.timestamps
    end
  end
end
