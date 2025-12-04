class Page < ApplicationRecord
  validates :title, :content, :slug, presence: true
  validates :slug, uniqueness: true
  validates :title, length: { maximum: 150 }
  validates :slug, length: { maximum: 150 }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= title.parameterize if title.present?
  end
end
