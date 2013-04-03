class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :gravatar_url, type: String
  field :name, type: String
  slug :name
  field :tags, type: String
  field :thumbnail_url, type: String
  field :owner, type: String
  field :counter_participation_events, type: Integer, default: 0

  has_and_belongs_to_many :users

  has_and_belongs_to_many :events

  validates_presence_of :name, :tags, :owner

  def set_counter(field, operation)
    field = "counter_#{field}"

    if operation == :inc
      self[field] = self[field] + 1
    elsif operation == :dec
      self[field] = self[field] - 1 if self[field] > 0
    end

    self.save
  end
end