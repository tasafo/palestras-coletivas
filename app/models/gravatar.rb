class Gravatar
  def self.url(email)
    hash = Digest::MD5.hexdigest(email)

    "http://gravatar.com/avatar/#{hash}?d=mm"
  end
end