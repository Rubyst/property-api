class Property < ApplicationRecord
    belongs_to :user, class_name: "User"
    has_many :bookings, class_name: "Booking", foreign_key: "property"
    has_many :images, class_name: "Image", foreign_key: "property"

    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true
    validates :type, presence: true
    validates :category, presence: true
    validates :status, presence: true
    validates :location, presence: true
    validates :size, presence: true
end
