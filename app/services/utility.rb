class Utility
  def self.until_two_names(name)
    name_array = name.split
    name_size = name_array.size
    name_one = name_array[0]

    if name_size > 1
      "#{name_one} #{name_array[name_size - 1]}".titleize
    else
      name_one.titleize
    end
  end

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
