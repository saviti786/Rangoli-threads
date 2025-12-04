class Product < ApplicationRecord
  belongs_to :category

  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  has_one_attached :image

  validates :name, :price, :stock, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, length: { maximum: 150 }
end
