json.extract! attachment, :id, :name, :key, :project_id, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)