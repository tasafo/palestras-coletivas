class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::FullTextSearch
  include Geocoder::Model::Mongoid
  include UpdateCounter
  include Commentable
  include Rateable

  field :name, type: String
  field :edition, type: String
  slug :name, :edition
  field :description, type: String
  field :stocking, type: Integer, :default => 0
  field :tags, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  field :deadline_date_enrollment, type: Date
  field :days, type: Integer
  field :to_public, type: Boolean, :default => false
  field :rating, type: Fixnum, :default => 0
  field :place, type: String

  field :street, type: String
  field :district, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :coordinates, type: Array

  field :owner, type: String
  field :counter_registered_users, type: Integer, default: 0
  field :counter_present_users, type: Integer, default: 0

  field :accepts_dynamic_programming, type: Boolean, :default => false

  embeds_many :comments, :as => :commentable
  embeds_many :ratings, :as => :rateable

  has_and_belongs_to_many :users

  has_and_belongs_to_many :groups

  has_many :schedules

  has_many :enrollments

  validates_presence_of :name, :edition, :tags, :start_date, :end_date, :deadline_date_enrollment, :place, :street, :district, :city, :state, :country, :owner

  validates_length_of :description, maximum: 500

  validates_numericality_of :stocking, greater_than_or_equal_to: 0

  geocoded_by :address

  after_validation :geocode

  before_save :number_of_days

  scope :by_name, order_by(:_slugs => :asc)

  scope :by_start_date, order_by(:start_date => :asc)

  scope :all_public, lambda { where(:to_public => true).order_by(:start_date => :desc) }

  scope :present_users, where(:counter_present_users.gt => 0).order_by(:counter_present_users => :desc, :_slugs => :asc, :edition => :asc).limit(5)

  scope :last_events, -> (limit) { all.order_by('created_at DESC').limit(limit) }

  def name_and_edition
    [name, edition].compact.join(' - ')
  end

  def address
    [street, district, city, state, country].compact.join(', ')
  end

  def is_in_progress?
    (start_date..end_date).include?(Date.today)
  end

  def update_list_organizers(owner, list_id_organizers)
    if self.users?
      owner.set_counter(:organizing_events, :dec)

      self.users.each do |organizer|
        organizer.set_counter(:organizing_events, :dec)
      end

      self.users = nil
    end

    self.users << owner
    owner.set_counter(:organizing_events, :inc)

    if list_id_organizers
      list_id_organizers.each do |organizer|
        user = User.find(organizer)
        if user
          self.users << user
          user.set_counter(:organizing_events, :inc)
        end
      end
    end
  end

  def update_list_groups(list_id_groups)
    if self.groups?
      self.groups.each do |group|
        group.set_counter(:participation_events, :dec)
      end

      self.groups = nil
    end

    if list_id_groups
      list_id_groups.each do |g|
        group = Group.find(g)
        if group
          self.groups << group
          group.set_counter(:participation_events, :inc)
        end
      end
    end
  end

private
  def number_of_days
    self.days = (self.start_date..self.end_date).to_a.count
  end
end
