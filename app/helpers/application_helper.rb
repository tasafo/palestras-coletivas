module ApplicationHelper
  def thumbnail(user, size = '80x80', klass = 'img-circle')
    image_tag(https(user.thumbnail), alt: user.username, size: size, class: klass)
  end

  def suspension_points(text, max)
    text.size > max ? "#{text[0, max]}..." : text
  end

  def https(url)
    return '' unless url

    change = url[0, 2] == '//' ? '//' : 'http://'

    url.gsub(change, 'https://')
  end
end
