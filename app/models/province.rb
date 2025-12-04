class Province < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :gst_rate, :pst_rate, :hst_rate,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
