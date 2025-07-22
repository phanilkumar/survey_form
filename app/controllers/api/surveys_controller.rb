class Api::SurveysController < ApplicationController
  before_action :set_survey, only: [:show]

  def index
    @surveys = Survey.recent
    render json: {
      status: 'success',
      data: @surveys.map { |survey| survey_response(survey) }
    }
  end

  def show
    render json: {
      status: 'success',
      data: survey_response(@survey)
    }
  end

  def create
    @survey = Survey.new(survey_params)
    
    if @survey.save
      render json: {
        status: 'success',
        message: 'Survey created successfully',
        data: survey_response(@survey)
      }, status: :created
    else
      render json: {
        status: 'error',
        message: 'Failed to create survey',
        errors: @survey.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_survey
    @survey = Survey.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: 'error',
      message: 'Survey not found'
    }, status: :not_found
  end

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def survey_response(survey)
    {
      id: survey.id,
      title: survey.title,
      description: survey.description,
      created_at: survey.created_at,
      updated_at: survey.updated_at,
      responses_count: survey.survey_responses.count
    }
  end
end
