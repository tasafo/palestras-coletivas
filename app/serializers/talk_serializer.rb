class TalkSerializer < ApplicationSerializer
  attributes :id, :slug, :title, :description, :tags, :presentation_url,
             :thumbnail
end
