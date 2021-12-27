class SerializableTalk < JSONAPI::Serializable::Resource
  type 'talks'

  id { @object.slug }

  attributes :id, :slug, :title, :description, :tags, :presentation_url,
             :thumbnail

  link :self do
    @url_helpers.talk_path(@object.slug)
  end
end
