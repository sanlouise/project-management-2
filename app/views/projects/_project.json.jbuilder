json.extract! project, :id, :title, :details, :deadline, :tenant_id, :created_at, :updated_at
json.url project_url(project, format: :json)