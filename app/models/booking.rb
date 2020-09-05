class Booking < ApplicationRecord
    belongs_to :property, class_name: "Property", foreign_key: "property"
    
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: ConstantData::VALID_EMAIL_REGEX }
    validates :message, presence: true 
end
