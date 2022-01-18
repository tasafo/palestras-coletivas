module ApplicationHelper
  include Pagy::Frontend

  def thumbnail(user, size = '80x80', klass = 'rounded-circle img-responsive')
    thumbnail = user.thumbnail

    if thumbnail
      image_tag(thumbnail, alt: user.name, size: size, class: klass, style: 'vertical-align: top;')
    else
      font_size = size.split('x').first
      "<i class=\"fa fa-user-circle #{klass}\" style=\"font-size: #{font_size}px;\"></i>".html_safe
    end
  end
end
