class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :purchase_price, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :purchase_price, numericality: { greater_than_or_equal_to: 0 }
end
