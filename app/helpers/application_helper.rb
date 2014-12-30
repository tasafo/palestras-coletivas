module ApplicationHelper
  def gravatar_image(email, alt, size = "80x80", klass = 'img-circle')
    image_tag Gravatar.new(email).url, alt: alt, size: size, class: klass
  end

  def event_address(event)
    EventPolicy.new(event).address
  end
end
