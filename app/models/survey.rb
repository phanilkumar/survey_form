class Survey < ApplicationRecord
  has_many :survey_responses, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }
  
  scope :recent, -> { order(created_at: :desc) }
end
