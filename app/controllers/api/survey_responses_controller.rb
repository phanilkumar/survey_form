class Api::SurveyResponsesController < ApplicationController
  before_action :set_survey, only: [:index, :create]
  before_action :set_survey_response, only: [:show, :update]

  def index
    @responses = @survey.survey_responses.recent
    render json: {
      status: 'success',
      data: @responses.map { |response| response_data(response) }
    }
  end

  def show
    render json: {
      status: 'success',
      data: response_data(@survey_response)
    }
  end

  def create
    @survey_response = @survey.survey_responses.build(survey_response_params)
    
    if @survey_response.save
      render json: {
        status: 'success',
        message: 'Survey response submitted successfully',
        data: response_data(@survey_response)
      }, status: :created
    else
      render json: {
        status: 'error',
        message: 'Failed to submit survey response',
        errors: @survey_response.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    unless @survey_response.editable?
      return render json: {
        status: 'error',
        message: 'Response cannot be edited after 24 hours'
      }, status: :unprocessable_entity
    end

    if @survey_response.update(survey_response_params)
      render json: {
        status: 'success',
        message: 'Survey response updated successfully',
        data: response_data(@survey_response)
      }
    else
      render json: {
        status: 'error',
        message: 'Failed to update survey response',
        errors: @survey_response.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def user_responses
    user_identifier = params[:user_identifier]
    @responses = SurveyResponse.by_user(user_identifier).includes(:survey).recent
    
    render json: {
      status: 'success',
      data: @responses.map { |response| user_response_data(response) }
    }
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: 'error',
      message: 'Survey not found'
    }, status: :not_found
  end

  def set_survey_response
    @survey_response = SurveyResponse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: 'error',
      message: 'Survey response not found'
    }, status: :not_found
  end

  def survey_response_params
    params.require(:survey_response).permit(:user_identifier, response_data: {})
  end

  def response_data(response)
    {
      id: response.id,
      survey_id: response.survey_id,
      user_identifier: response.user_identifier,
      response_data: response.response_data,
      created_at: response.created_at,
      updated_at: response.updated_at,
      editable: response.editable?
    }
  end

  def user_response_data(response)
    {
      id: response.id,
      survey: {
        id: response.survey.id,
        title: response.survey.title,
        description: response.survey.description
      },
      user_identifier: response.user_identifier,
      response_data: response.response_data,
      created_at: response.created_at,
      updated_at: response.updated_at,
      editable: response.editable?
    }
  end
end
