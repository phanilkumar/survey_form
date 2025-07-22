require "test_helper"

class SurveyResponseTest < ActiveSupport::TestCase
  def setup
    @survey = Survey.create!(title: "Test Survey", description: "Test description")
    @survey_response = SurveyResponse.new(
      survey: @survey,
      user_identifier: "test_user",
      response_data: { "question1" => "answer1" }
    )
  end

  test "should be valid with valid attributes" do
    assert @survey_response.valid?
  end

  test "should require survey" do
    @survey_response.survey = nil
    assert_not @survey_response.valid?
    assert_includes @survey_response.errors[:survey], "must exist"
  end

  test "should require user_identifier" do
    @survey_response.user_identifier = nil
    assert_not @survey_response.valid?
    assert_includes @survey_response.errors[:user_identifier], "can't be blank"
  end

  test "should require response_data" do
    @survey_response.response_data = nil
    assert_not @survey_response.valid?
    assert_includes @survey_response.errors[:response_data], "can't be blank"
  end

  test "should validate user_identifier length" do
    @survey_response.user_identifier = "ab"
    assert_not @survey_response.valid?
    assert_includes @survey_response.errors[:user_identifier], "is too short (minimum is 3 characters)"

    @survey_response.user_identifier = "a" * 101
    assert_not @survey_response.valid?
    assert_includes @survey_response.errors[:user_identifier], "is too long (maximum is 100 characters)"
  end

  test "should belong to survey" do
    @survey_response.save!
    assert_equal @survey, @survey_response.survey
  end

  test "should filter by user in by_user scope" do
    user1_response = @survey.survey_responses.create!(
      user_identifier: "user1",
      response_data: { "question1" => "answer1" }
    )
    user2_response = @survey.survey_responses.create!(
      user_identifier: "user2",
      response_data: { "question1" => "answer2" }
    )

    user1_responses = SurveyResponse.by_user("user1")
    assert_includes user1_responses, user1_response
    assert_not_includes user1_responses, user2_response
  end

  test "should order by updated_at desc in recent scope" do
    # Clear existing responses to avoid conflicts
    SurveyResponse.delete_all
    
    response1 = @survey.survey_responses.create!(
      user_identifier: "user1",
      response_data: { "question1" => "answer1" }
    )
    sleep(0.1) # Ensure different timestamps
    response2 = @survey.survey_responses.create!(
      user_identifier: "user2",
      response_data: { "question1" => "answer2" }
    )

    recent_responses = SurveyResponse.recent
    assert_equal response2, recent_responses.first
    assert_equal response1, recent_responses.last
  end

  test "should be editable within 24 hours" do
    @survey_response.save!
    assert @survey_response.editable?
  end

  test "should not be editable after 24 hours" do
    @survey_response.save!
    @survey_response.update_column(:created_at, 25.hours.ago)
    assert_not @survey_response.editable?
  end

  test "should store and retrieve JSON response data" do
    complex_data = {
      "multiple_choice" => "option_a",
      "rating" => 5,
      "comments" => "Great survey!",
      "nested_data" => {
        "sub_question" => "sub_answer"
      }
    }
    
    @survey_response.response_data = complex_data
    @survey_response.save!
    
    retrieved_response = SurveyResponse.find(@survey_response.id)
    assert_equal complex_data, retrieved_response.response_data
  end
end
