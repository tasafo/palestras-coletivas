class ExternalEvent
  include Mongoid::Document

  field :name, type: String
  field :place, type: String
  field :date, type: Date
  field :url, type: String

  embedded_in :talk

  validates_presence_of :name, :place, :date

  scope :by_date, order_by(:date => :desc)
end