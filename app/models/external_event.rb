class ExternalEvent
  include Mongoid::Document

  field :name, type: String
  field :place, type: String
  field :date, type: Date
  field :url, type: String
  field :active, type: Boolean, default: true

  embedded_in :talk

  validates_presence_of :name, :place, :date

  scope :by_date, -> { order_by(date: :desc) }
  scope :only_active, -> { where(active: true) }

  def self.list(owns)
    owns ? by_date : only_active.by_date
  end
end