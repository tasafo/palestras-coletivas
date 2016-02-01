json.array! @talks do |talk|
  json.extract! talk, :title, :description, :tags, :presentation_url, :thumbnail
end
