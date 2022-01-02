class TagsGenerator
  def self.generate(object)
    tags = separators(object.tags)

    tags = tags.split if tags.is_a?(String)

    tags
  end

  def self.separators(tags)
    [', ', ',', '; ', ';'].each do |separator|
      if tags.include?(separator)
        tags = tags.split(separator)
        break
      end
    end

    tags
  end
end
