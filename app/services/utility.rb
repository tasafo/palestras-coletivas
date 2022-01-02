class Utility
  def self.suspension_points(text, max)
    text.size > max ? "#{text[0, max]}..." : text
  end

  def self.https(url)
    return '' unless url

    change = url[0, 2] == '//' ? '//' : 'http://'

    url.gsub(change, 'https://')
  end

  def self.zero_fill(field, size = 2)
    field.to_s.rjust(size, '0')
  end
end
