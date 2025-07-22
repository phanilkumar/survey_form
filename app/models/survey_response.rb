class SurveyResponse < ApplicationRecord
  belongs_to :survey
  
  validates :user_identifier, presence: true, length: { minimum: 3, maximum: 100 }
  validates :response_data, presence: true
  
  scope :by_user, ->(user_identifier) { where(user_identifier: user_identifier) }
  scope :recent, -> { order(updated_at: :desc) }
  
  def editable?
    # Responses can be edited within 24 hours of creation
    created_at > 24.hours.ago
  end
end
