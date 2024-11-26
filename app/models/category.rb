class Category < ApplicationRecord
  has_rich_text :description
  has_one_attached :image
  has_many :products
  belongs_to :category, optional: true

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
