require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  def setup
    @survey = Survey.new(
      title: "Test Survey",
      description: "This is a test survey description"
    )
  end

  test "should be valid with valid attributes" do
    assert @survey.valid?
  end

  test "should require title" do
    @survey.title = nil
    assert_not @survey.valid?
    assert_includes @survey.errors[:title], "can't be blank"
  end

  test "should require description" do
    @survey.description = nil
    assert_not @survey.valid?
    assert_includes @survey.errors[:description], "can't be blank"
  end

  test "should validate title length" do
    @survey.title = "ab"
    assert_not @survey.valid?
    assert_includes @survey.errors[:title], "is too short (minimum is 3 characters)"

    @survey.title = "a" * 256
    assert_not @survey.valid?
    assert_includes @survey.errors[:title], "is too long (maximum is 255 characters)"
  end

  test "should validate description length" do
    @survey.description = "a" * 1001
    assert_not @survey.valid?
    assert_includes @survey.errors[:description], "is too long (maximum is 1000 characters)"
  end

  test "should have many survey responses" do
    survey = Survey.create!(title: "Test", description: "Test description")
    response1 = survey.survey_responses.create!(
      user_identifier: "user1",
      response_data: { "question1" => "answer1" }
    )
    response2 = survey.survey_responses.create!(
      user_identifier: "user2",
      response_data: { "question1" => "answer2" }
    )

    assert_includes survey.survey_responses, response1
    assert_includes survey.survey_responses, response2
  end

  test "should destroy associated responses when deleted" do
    survey = Survey.create!(title: "Test", description: "Test description")
    response = survey.survey_responses.create!(
      user_identifier: "user1",
      response_data: { "question1" => "answer1" }
    )

    assert_difference 'SurveyResponse.count', -1 do
      survey.destroy
    end
  end

  test "should order by created_at desc in recent scope" do
    # Clear existing data to avoid conflicts
    SurveyResponse.delete_all
    Survey.delete_all
    
    survey1 = Survey.create!(title: "First", description: "First description")
    sleep(0.1) # Ensure different timestamps
    survey2 = Survey.create!(title: "Second", description: "Second description")

    recent_surveys = Survey.recent
    assert_equal survey2, recent_surveys.first
    assert_equal survey1, recent_surveys.last
  end
end
