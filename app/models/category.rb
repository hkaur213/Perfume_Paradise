class Category < ApplicationRecord
  has_rich_text :description
  has_one_attached :image
  has_many :products
  belongs_to :category, optional: true
end
