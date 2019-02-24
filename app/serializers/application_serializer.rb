class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :links do
    id = object.respond_to?('slug') ? object.slug : object.id
    {
      self: send("#{object.class.to_s.downcase}_path", id)
    }
  end
end
