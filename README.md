# Survey Form API

A backend survey form application built with Ruby on Rails, similar to Typeform and Google Forms. This application provides RESTful APIs for creating surveys, submitting responses, and managing survey data.

## Features

### Basic Requirements ✅
- **Create Surveys**: API to create new surveys with title and description
- **Store Responses**: API to submit survey responses with user identification
- **Fetch Responses**: API to retrieve survey responses

### Next Level Requirements ✅
- **Edit Responses**: Users can edit their responses multiple times after submission (within 24 hours)
- **User Response History**: API to list all responses submitted by a specific user

## Technology Stack

- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite3 (for development/testing)
- **Language**: Ruby 3.2.2
- **Testing**: Rails built-in test framework

## Installation Steps

### Prerequisites
- Ruby 3.2.2 or higher
- Rails 8.0.2
- SQLite3

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd survey_form
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

The application will be available at `http://localhost:3000`

## API Documentation

### Base URL
```
http://localhost:3000/api
```

### 1. Surveys

#### List All Surveys
```http
GET /api/surveys
```

**Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "title": "Customer Satisfaction Survey",
      "description": "Help us improve our services",
      "created_at": "2025-07-22T08:40:41.201Z",
      "updated_at": "2025-07-22T08:40:41.201Z",
      "responses_count": 2
    }
  ]
}
```

#### Get Survey Details
```http
GET /api/surveys/:id
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "title": "Customer Satisfaction Survey",
    "description": "Help us improve our services",
    "created_at": "2025-07-22T08:40:41.201Z",
    "updated_at": "2025-07-22T08:40:41.201Z",
    "responses_count": 2
  }
}
```

#### Create Survey
```http
POST /api/surveys
Content-Type: application/json

{
  "survey": {
    "title": "New Survey",
    "description": "Survey description"
  }
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Survey created successfully",
  "data": {
    "id": 2,
    "title": "New Survey",
    "description": "Survey description",
    "created_at": "2025-07-22T08:40:41.201Z",
    "updated_at": "2025-07-22T08:40:41.201Z",
    "responses_count": 0
  }
}
```

### 2. Survey Responses

#### List Survey Responses
```http
GET /api/surveys/:survey_id/survey_responses
```

**Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "survey_id": 1,
      "user_identifier": "user123",
      "response_data": {
        "overall_satisfaction": "5",
        "service_quality": "4",
        "comments": "Great service!"
      },
      "created_at": "2025-07-22T08:40:41.201Z",
      "updated_at": "2025-07-22T08:40:41.201Z",
      "editable": true
    }
  ]
}
```

#### Get Response Details
```http
GET /api/surveys/:survey_id/survey_responses/:id
```

#### Submit Survey Response
```http
POST /api/surveys/:survey_id/survey_responses
Content-Type: application/json

{
  "survey_response": {
    "user_identifier": "user123",
    "response_data": {
      "overall_satisfaction": "5",
      "service_quality": "4",
      "recommendation_likelihood": "5",
      "comments": "Great service, very satisfied!"
    }
  }
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Survey response submitted successfully",
  "data": {
    "id": 1,
    "survey_id": 1,
    "user_identifier": "user123",
    "response_data": {
      "overall_satisfaction": "5",
      "service_quality": "4",
      "recommendation_likelihood": "5",
      "comments": "Great service, very satisfied!"
    },
    "created_at": "2025-07-22T08:40:41.201Z",
    "updated_at": "2025-07-22T08:40:41.201Z",
    "editable": true
  }
}
```

#### Update Survey Response
```http
PATCH /api/surveys/:survey_id/survey_responses/:id
Content-Type: application/json

{
  "survey_response": {
    "response_data": {
      "overall_satisfaction": "4",
      "service_quality": "5",
      "recommendation_likelihood": "4",
      "comments": "Updated comments"
    }
  }
}
```

**Note**: Responses can only be edited within 24 hours of creation.

#### Get User Responses
```http
GET /api/users/:user_identifier/responses
```

**Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "survey": {
        "id": 1,
        "title": "Customer Satisfaction Survey",
        "description": "Help us improve our services"
      },
      "user_identifier": "user123",
      "response_data": {
        "overall_satisfaction": "5",
        "service_quality": "4"
      },
      "created_at": "2025-07-22T08:40:41.201Z",
      "updated_at": "2025-07-22T08:40:41.201Z",
      "editable": true
    }
  ]
}
```

## Error Responses

All APIs return consistent error responses:

```json
{
  "status": "error",
  "message": "Error description",
  "errors": ["Detailed error messages"]
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `422` - Unprocessable Entity

## Code Architecture

### Models
- **Survey**: Manages survey data with validations and associations
- **SurveyResponse**: Handles response data with user identification and editability logic

### Controllers
- **Api::SurveysController**: Handles survey CRUD operations
- **Api::SurveyResponsesController**: Manages response operations including editing and user history

### Key Features
- **JSON Response Data**: Flexible schema for storing various question types
- **User Identification**: Simple string-based user identification
- **Response Editing**: 24-hour window for editing responses
- **RESTful Design**: Clean, predictable API endpoints
- **Error Handling**: Comprehensive validation and error responses

## Testing

### Run All Tests
```bash
rails test
```

### Run Specific Test Files
```bash
rails test test/models/survey_test.rb
rails test test/controllers/api/surveys_controller_test.rb
rails test test/controllers/api/survey_responses_controller_test.rb
```

### Test Coverage
- **Model Tests**: Validations, associations, scopes, and business logic
- **Controller Tests**: API endpoints, error handling, and response formats
- **Integration Tests**: End-to-end API functionality

## Sample Data

The application comes with sample data including:
- 3 sample surveys (Customer Satisfaction, Employee Engagement, Product Feedback)
- 4 sample responses with various user identifiers

## Assumptions Made

1. **User Identification**: Using simple string identifiers instead of user accounts
2. **Response Schema**: Flexible JSON structure to accommodate various question types
3. **Edit Window**: 24-hour limit for response editing
4. **Database**: SQLite for simplicity (can be easily changed to PostgreSQL/MySQL)
5. **Authentication**: No authentication required (can be added later)

## Future Enhancements

- User authentication and authorization
- Survey templates and question types
- Response analytics and reporting
- Email notifications
- Survey sharing and collaboration
- Advanced validation rules
- Rate limiting and API versioning

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is open source and available under the MIT License.
