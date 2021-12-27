class SerializableEvent < JSONAPI::Serializable::Resource
  type 'events'

  id { @object.slug }

  attributes :name, :edition, :description, :start_date, :end_date, :street,
             :district, :state, :country

  link :self do
    @url_helpers.event_path(@object.slug)
  end
end
