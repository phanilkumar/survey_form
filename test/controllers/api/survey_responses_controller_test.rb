require "test_helper"

class Api::SurveyResponsesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @survey = Survey.create!(
      title: "Test Survey",
      description: "Test survey description"
    )
    @survey_response = @survey.survey_responses.create!(
      user_identifier: "test_user",
      response_data: { "question1" => "answer1" }
    )
  end

  test "should get index" do
    get api_survey_survey_responses_url(@survey)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal 1, json_response["data"].length
    assert_equal @survey_response.id, json_response["data"][0]["id"]
  end

  test "should get show" do
    get api_survey_survey_response_url(@survey, @survey_response)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal @survey_response.id, json_response["data"]["id"]
    assert_equal @survey_response.user_identifier, json_response["data"]["user_identifier"]
    assert_equal @survey_response.response_data, json_response["data"]["response_data"]
  end

  test "should return 404 for non-existent response" do
    get api_survey_survey_response_url(@survey, 99999)
    assert_response :not_found
    
    json_response = JSON.parse(response.body)
    assert_equal "error", json_response["status"]
    assert_equal "Survey response not found", json_response["message"]
  end

  test "should create survey response" do
    assert_difference('SurveyResponse.count') do
      post api_survey_survey_responses_url(@survey), params: {
        survey_response: {
          user_identifier: "new_user",
          response_data: { "question1" => "new_answer" }
        }
      }
    end
    
    assert_response :created
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal "Survey response submitted successfully", json_response["message"]
    assert_equal "new_user", json_response["data"]["user_identifier"]
    assert_equal({ "question1" => "new_answer" }, json_response["data"]["response_data"])
  end

  test "should not create response with invalid data" do
    assert_no_difference('SurveyResponse.count') do
      post api_survey_survey_responses_url(@survey), params: {
        survey_response: {
          user_identifier: "",
          response_data: nil
        }
      }
    end
    
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_equal "error", json_response["status"]
    assert_equal "Failed to submit survey response", json_response["message"]
    assert_includes json_response["errors"], "User identifier can't be blank"
    assert_includes json_response["errors"], "Response data can't be blank"
  end

  test "should update survey response" do
    patch api_survey_survey_response_url(@survey, @survey_response), params: {
      survey_response: {
        response_data: { "question1" => "updated_answer" }
      }
    }
    
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal "Survey response updated successfully", json_response["message"]
    assert_equal({ "question1" => "updated_answer" }, json_response["data"]["response_data"])
  end

  test "should not update response after 24 hours" do
    @survey_response.update_column(:created_at, 25.hours.ago)
    
    patch api_survey_survey_response_url(@survey, @survey_response), params: {
      survey_response: {
        response_data: { "question1" => "updated_answer" }
      }
    }
    
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_equal "error", json_response["status"]
    assert_equal "Response cannot be edited after 24 hours", json_response["message"]
  end

  test "should get user responses" do
    # Create another response for the same user
    @survey.survey_responses.create!(
      user_identifier: "test_user",
      response_data: { "question2" => "answer2" }
    )
    
    get api_user_responses_url("test_user")
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal 2, json_response["data"].length
    
    # Check that both responses belong to the same user
    json_response["data"].each do |response|
      assert_equal "test_user", response["user_identifier"]
    end
  end

  test "should return empty array for user with no responses" do
    get api_user_responses_url("non_existent_user")
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal 0, json_response["data"].length
  end

  test "should include editable flag in response data" do
    get api_survey_survey_response_url(@survey, @survey_response)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert json_response["data"]["editable"]
  end

  test "should return 404 for non-existent survey in responses" do
    get api_survey_survey_responses_url(99999)
    assert_response :not_found
    
    json_response = JSON.parse(response.body)
    assert_equal "error", json_response["status"]
    assert_equal "Survey not found", json_response["message"]
  end
end
