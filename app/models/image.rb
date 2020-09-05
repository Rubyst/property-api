class Image < ApplicationRecord
    belongs_to :property, class_name: "Property", foreign_key: "property"
end
