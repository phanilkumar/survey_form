require "test_helper"

class Api::SurveysControllerTest < ActionDispatch::IntegrationTest
  def setup
    @survey = Survey.create!(
      title: "Test Survey",
      description: "Test survey description"
    )
  end

  test "should get index" do
    get api_surveys_url
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    
    # Find our test survey in the response
    test_survey_data = json_response["data"].find { |s| s["id"] == @survey.id }
    assert_not_nil test_survey_data
    assert_equal @survey.title, test_survey_data["title"]
    assert_equal @survey.description, test_survey_data["description"]
    assert_equal 0, test_survey_data["responses_count"]
  end

  test "should get show" do
    get api_survey_url(@survey)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal @survey.id, json_response["data"]["id"]
    assert_equal @survey.title, json_response["data"]["title"]
    assert_equal @survey.description, json_response["data"]["description"]
  end

  test "should return 404 for non-existent survey" do
    get api_survey_url(99999)
    assert_response :not_found
    
    json_response = JSON.parse(response.body)
    assert_equal "error", json_response["status"]
    assert_equal "Survey not found", json_response["message"]
  end

  test "should create survey" do
    assert_difference('Survey.count') do
      post api_surveys_url, params: {
        survey: {
          title: "New Survey",
          description: "New survey description"
        }
      }
    end
    
    assert_response :created
    
    json_response = JSON.parse(response.body)
    assert_equal "success", json_response["status"]
    assert_equal "Survey created successfully", json_response["message"]
    assert_equal "New Survey", json_response["data"]["title"]
    assert_equal "New survey description", json_response["data"]["description"]
  end

  test "should not create survey with invalid data" do
    assert_no_difference('Survey.count') do
      post api_surveys_url, params: {
        survey: {
          title: "",
          description: ""
        }
      }
    end
    
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_equal "error", json_response["status"]
    assert_equal "Failed to create survey", json_response["message"]
    assert_includes json_response["errors"], "Title can't be blank"
    assert_includes json_response["errors"], "Description can't be blank"
  end

  test "should not create survey with title too short" do
    assert_no_difference('Survey.count') do
      post api_surveys_url, params: {
        survey: {
          title: "ab",
          description: "Valid description"
        }
      }
    end
    
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_includes json_response["errors"], "Title is too short (minimum is 3 characters)"
  end

  test "should include responses count in survey data" do
    @survey.survey_responses.create!(
      user_identifier: "user1",
      response_data: { "question1" => "answer1" }
    )
    
    get api_survey_url(@survey)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["responses_count"]
  end
end
