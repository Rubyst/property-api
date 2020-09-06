class Booking < ApplicationRecord
    belongs_to :property, class_name: "Property", foreign_key: "property_details"
    
    validates :name, presence: true
    validates :email, presence: true
    validates :subject, presence: true
    validates :message, presence: true 
end
