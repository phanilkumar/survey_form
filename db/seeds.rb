# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating sample surveys..."

# Create sample surveys
survey1 = Survey.create!(
  title: "Customer Satisfaction Survey",
  description: "Help us improve our services by providing your feedback on your recent experience."
)

survey2 = Survey.create!(
  title: "Employee Engagement Survey",
  description: "We value your opinion! Please share your thoughts about workplace culture and satisfaction."
)

survey3 = Survey.create!(
  title: "Product Feedback Form",
  description: "Tell us what you think about our latest product features and how we can make them better."
)

puts "Creating sample survey responses..."

# Create sample responses for survey1
SurveyResponse.create!(
  survey: survey1,
  user_identifier: "user123",
  response_data: {
    "overall_satisfaction" => "5",
    "service_quality" => "4",
    "recommendation_likelihood" => "5",
    "comments" => "Great service, very satisfied!"
  }
)

SurveyResponse.create!(
  survey: survey1,
  user_identifier: "user456",
  response_data: {
    "overall_satisfaction" => "3",
    "service_quality" => "4",
    "recommendation_likelihood" => "3",
    "comments" => "Service was okay, room for improvement."
  }
)

# Create sample responses for survey2
SurveyResponse.create!(
  survey: survey2,
  user_identifier: "employee001",
  response_data: {
    "workplace_culture" => "4",
    "job_satisfaction" => "5",
    "work_life_balance" => "4",
    "management_support" => "5",
    "suggestions" => "More team building activities would be great!"
  }
)

# Create sample responses for survey3
SurveyResponse.create!(
  survey: survey3,
  user_identifier: "customer789",
  response_data: {
    "product_rating" => "4",
    "feature_usefulness" => "5",
    "ease_of_use" => "4",
    "additional_features" => "Mobile app would be helpful",
    "overall_impression" => "Very good product!"
  }
)

puts "Seed data created successfully!"
puts "Created #{Survey.count} surveys and #{SurveyResponse.count} responses"
