require 'open-uri'

class Facebook
  def self.thumbnail(url)
    begin
      unless url.blank?
        id = url.split("/").last
        id = id.split("?").first if id.include?("?")

        object = open("https://graph.facebook.com/#{id}/picture?type=large")

        image_url = object.base_uri.to_s

        image_url.include?("gPCjrIGykBe.gif") ? nil : image_url
      end
    rescue
      nil
    end
  end
end
