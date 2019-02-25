#:nodoc:
module ApplicationHelper
  def thumbnail(user, size = '80x80', klass = 'img-circle', data = {})
    image_tag(https(user.thumbnail), alt: user.username, size: size,
                                     class: klass, data: data)
  end

  def suspension_points(text, max)
    text.size > max ? text[0, max] + '...' : text
  end

  def https(url)
    return '' if url.nil?

    change = url[0, 2] == '//' ? '//' : 'http://'

    url.gsub(change, 'https://')
  end
end
