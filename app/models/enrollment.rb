class Enrollment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :active, type: Boolean, :default => true
  field :present, type: Boolean, :default => false

  belongs_to :event
  belongs_to :user

  scope :actives, lambda { where(:active => true) }
  scope :presents, lambda { where(:present => true) }

  def update_counter_of_events_and_users(option)
    self.send("update_#{option}_counter")
  end

  def update_active_counter
    operation = self.active? ? :inc : :dec

    user.set_counter(:enrollment_events, operation)

    event.set_counter(:registered_users, operation)    
  end

  def update_present_counter
    operation = self.present? ? :inc : :dec

    user.set_counter(:participation_events, operation)

    event.set_counter(:present_users, operation)
  end
end