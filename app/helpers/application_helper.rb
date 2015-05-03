module ApplicationHelper
  def thumbnail(user, size = "80x80", klass = 'img-circle')
    image_tag user.thumbnail, alt: user.username, size: size, class: klass
  end

  def suspension_points(text, max)
    text.size > max ? text[0, max] + "..." : text
  end
end
