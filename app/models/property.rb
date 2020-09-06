class Property < ApplicationRecord
    belongs_to :user, class_name: "User"
    has_many :bookings, class_name: "Booking", foreign_key: "property"

    attribute :status, :string, default: 'available'

    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true
    validates :property_type, presence: true
    validates :category, presence: true
    validates :location, presence: true
    validates :size, presence: true
end
