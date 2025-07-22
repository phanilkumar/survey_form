class CreateSurveyResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :survey_responses do |t|
      t.references :survey, null: false, foreign_key: true
      t.string :user_identifier
      t.json :response_data

      t.timestamps
    end
  end
end
