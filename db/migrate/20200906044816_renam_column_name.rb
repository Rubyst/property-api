class RenamColumnName < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :bookings, :property, :property_details
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
