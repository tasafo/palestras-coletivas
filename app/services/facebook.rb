require 'open-uri'

#:nodoc:
class Facebook
  def self.thumbnail(url)
    unless url.blank?
      id = url.split('/').last
      id = id.split('?').first if id.include?('?')

      object = extract(id)

      image_url = object.nil? ? '' : object.base_uri.to_s
      image_url.include?('gPCjrIGykBe.gif') ? nil : image_url
    end
  end

  def self.extract(id)
    url = "https://graph.facebook.com/#{id}/picture?type=large"

    begin
      open(url)
    rescue OpenURI::HTTPError
      nil
    end
  end
end
