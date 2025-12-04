class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  before_create :assign_user_order_number

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  validates :gst_rate, :pst_rate, :hst_rate,
            numericality: { greater_than_or_equal_to: 0 }

  private

  def assign_user_order_number
    last_order_number = user.orders.maximum(:user_order_number)
    self.user_order_number = last_order_number.to_i + 1
  end
end
