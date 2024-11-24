class Product < ApplicationRecord
  has_rich_text :description
  has_many_attached :images
  belongs_to :category, optional: true
  has_many :carts, through: :cart_items
  has_many :cart_items
  attribute :on_sale, :boolean, default: false

  # Include PgSearch for full-text search
  include PgSearch::Model
  
  # Define a pg_search_scope to search by name and rich text description
  pg_search_scope :search_by_name_and_description,
    against: :name,
    associated_against: { rich_text_description: :body },
    using: {
      tsearch: { prefix: true } # Enables partial word matching
    }
end
