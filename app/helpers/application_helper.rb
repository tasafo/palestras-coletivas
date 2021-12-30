module ApplicationHelper
  include Pagy::Frontend

  def thumbnail(user, size = '80x80', klass = 'img-circle')
    image_tag(user.thumbnail, alt: user.username, size: size, class: klass)
  end

  def tags_from(object)
    tags = object.tags
    tags.include?(',') ? tags.split(', ') : tags.split
  end
end
