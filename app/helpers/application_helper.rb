module ApplicationHelper
  include Pagy::Frontend

  def thumbnail(user, size = '80x80', klass = 'img-circle')
    image_tag(user.thumbnail, alt: user.username, size: size, class: klass)
  end
end
