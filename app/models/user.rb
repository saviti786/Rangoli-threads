class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :validatable

  # Associations
  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 100 }

  # validates :street, presence: true, length: { maximum: 200 }
  # validates :city,   presence: true, length: { maximum: 100 }

  # # Canadian postal code validation (A1A 1A1 format)
  # validates :postal_code, presence: true,
  #                         format: {
  #                           with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
  #                           message: "must be a valid Canadian postal code (e.g., A1A 1A1)"
  #                         }

  # Province foreign key validation (if not null)
  validates :province_id, numericality: { only_integer: true }, allow_nil: true

  # Email & password are already validated by Devise:
  # - email presence
  # - email format
  # - password length >= 6
end
