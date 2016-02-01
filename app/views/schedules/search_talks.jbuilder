json.array! @talks do |talk|
  json.extract! talk, :_id, :_slugs, :title, :description, :tags, :thumbnail
end
