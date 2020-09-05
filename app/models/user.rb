class User < ApplicationRecord
    has_secure_password
    has_many :properties, class_name: "Property", foreign_key: "user_id", dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: ConstantData::VALID_EMAIL_REGEX }
    validates :password_digest, presence: true, length: {minimum: 6}
    validates :office_address, presence: true
    validates :phone_number, presence: true
    validates :profile_picture, presence: true  
end
