module ApplicationHelper
  def gravatar_image(email, alt, size = "80x80")
    url = Gravatar.url(email)
    image_tag url, :alt => alt, :size => size, :class => 'img-circle'
  end

  def event_address(event)
    EventPolicy.new(event).address
  end
end
