json.extract! feedback, :id, :submissionid, :rating, :description, :created_at, :updated_at
json.url feedback_url(feedback, format: :json)
