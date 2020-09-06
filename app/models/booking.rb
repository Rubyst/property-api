class Booking < ApplicationRecord
    belongs_to :property, class_name: "Property", foreign_key: "property_details"
    
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    validates :message, presence: true 
end
