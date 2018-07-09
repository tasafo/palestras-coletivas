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

  def event_image(event)
    if event.image?
      https(event.image.url)
    else
      image_url("covers/#{event.static_cover}-large.jpg")
    end
  end

  def cover_helper(event)
    if event.image.present?
      url  = https(event.image.url)
    else
      url = asset_url("covers/#{event.static_cover}-large.jpg")
    end

    "style=background:url(#{url});background-repeat:no-repeat;background-position:center;background-size:cover"
  end
end
