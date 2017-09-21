json.extract! comment, :id, :user_id, :section_id, :body, :created_at, :updated_at
json.url comment_url(comment, format: :json)
