module ApplicationHelper
  def gravatar_image(email, alt)
    url = Gravatar.url(email)
    image_tag url, :alt => alt, :class => "avatar"
  end
end
