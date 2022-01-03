module ApplicationHelper
  include Pagy::Frontend

  def thumbnail(user, size = '80x80', klass = 'img-circle')
    image_tag(user.thumbnail, alt: user.name, size: size, class: klass, title: user.name)
  end
end
