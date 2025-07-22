# API Documentation - Quick Reference

## Base URL
```
http://localhost:3000/api
```

## Endpoints

### Surveys

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/surveys` | List all surveys |
| GET | `/surveys/:id` | Get survey details |
| POST | `/surveys` | Create new survey |

### Survey Responses

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/surveys/:survey_id/survey_responses` | List survey responses |
| GET | `/surveys/:survey_id/survey_responses/:id` | Get response details |
| POST | `/surveys/:survey_id/survey_responses` | Submit response |
| PATCH | `/surveys/:survey_id/survey_responses/:id` | Update response |

### User Responses

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users/:user_identifier/responses` | Get all responses by user |

## Example Requests

### Create Survey
```bash
curl -X POST http://localhost:3000/api/surveys \
  -H "Content-Type: application/json" \
  -d '{
    "survey": {
      "title": "My Survey",
      "description": "Survey description"
    }
  }'
```

### Submit Response
```bash
curl -X POST http://localhost:3000/api/surveys/1/survey_responses \
  -H "Content-Type: application/json" \
  -d '{
    "survey_response": {
      "user_identifier": "user123",
      "response_data": {
        "rating": "5",
        "comments": "Great survey!"
      }
    }
  }'
```

### Update Response
```bash
curl -X PATCH http://localhost:3000/api/surveys/1/survey_responses/1 \
  -H "Content-Type: application/json" \
  -d '{
    "survey_response": {
      "response_data": {
        "rating": "4",
        "comments": "Updated comments"
      }
    }
  }'
```

### Get User Responses
```bash
curl -X GET http://localhost:3000/api/users/user123/responses
```

## Response Format

All responses follow this format:
```json
{
  "status": "success|error",
  "message": "Optional message",
  "data": {...},
  "errors": ["Error messages"]
}
```

## Error Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `422` - Unprocessable Entity 